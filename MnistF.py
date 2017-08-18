#mnistF.py is the functional API version and vs code based version of a parallel jupyter notebook from the
#aug 17 2017 meetup on coding cntk for convulutional nets.
#including the launch and settings.json files for this if you need to recreate in vs code
from __future__ import print_function # Use a function definition from future version (say 3.x from 2.7 interpreter)
import matplotlib.image as mpimg
import matplotlib.pyplot as plt
import numpy as np
import os
import sys
import time
import cntk as C
import datetime

print("CNTK version",C.__version__)
                                                    #let's set up safety and tracing flags
C.debugging.set_computation_network_trace_level(1)  #1000 is more and 1000000 is intense
C.logging.set_trace_level(2)                        #info

print("CNTK sees device(s): ",C.all_devices())
#Ensure we always get the same randomizer init
np.random.seed(0)

# Define the data dimensions
input_dim_model = (1, 28, 28)    # images are 28 x 28 with 1 channel of color (gray)
input_dim = 28*28                # used by readers to treat input data as a vector
num_output_classes = 10

# Read a CTF formatted text (as mentioned above) using the CTF deserializer from a file
def create_reader(path, is_training, input_dim, num_label_classes):
    
    ctf = C.io.CTFDeserializer(path, C.io.StreamDefs(
          labels=C.io.StreamDef(field='labels', shape=num_label_classes, is_sparse=False),
          features=C.io.StreamDef(field='features', shape=input_dim, is_sparse=False)))
                          
    return C.io.MinibatchSource(ctf,
        randomize = is_training, max_sweeps = C.io.INFINITELY_REPEAT if is_training else 1)

data_found=False # A flag to indicate if train/test data found in local cache
for data_dir in [os.path.join("C:\local\cntk-2-0\cntk\Scripts\CNTK-Samples-2-0", "Examples", "Image", "DataSets", "MNIST"),
                 os.path.join("data", "MNIST")]:
    
    train_file=os.path.join(data_dir, "Train-28x28_cntk_text.txt")
    test_file=os.path.join(data_dir, "Test-28x28_cntk_text.txt")
    
    if os.path.isfile(train_file) and os.path.isfile(test_file):
        data_found=True
        break
        
if not data_found:
    raise ValueError("Please generate the data by completing CNTK 103 Part A")
    
print("Data directory is {0}".format(data_dir))

#we need a real progress printer
progprint = C.logging.progress_print.ProgressPrinter(freq=0,first=2,log_to_file='mnistf.log')

progprint.log('Initializng the Model' + repr(datetime.datetime.now().strftime("%A, %d. %B %Y %I:%M%p")))

#prep our input/output containers/shapes
x = C.input_variable(input_dim_model)
y = C.input_variable(num_output_classes)

def create_criterion_function(model, labels):
    loss = C.cross_entropy_with_softmax(model, labels)
    errs = C.classification_error(model, labels)
    return loss, errs # (model, labels) -> (loss, error metric)

# Define a utility function to compute the moving average sum.
# A more efficient implementation is possible with np.cumsum() function
def moving_average(a, w=5):
    if len(a) < w:
        return a[:]    # Need to send a copy of the array
    return [val if idx < w else sum(a[(idx-w):idx])/w for idx, val in enumerate(a)]


# Defines a utility that prints the training progress
def print_training_progress(trainer, mb, frequency, verbose=1):
    training_loss   = "NA"
    eval_error      = "NA"

    if mb%frequency == 0:
        training_loss = trainer.previous_minibatch_loss_average
        eval_error = trainer.previous_minibatch_evaluation_average
        if verbose: 
            print ("Minibatch: {0}, Loss: {1:.4f}, Error: {2:.2f}%".format(mb, training_loss, eval_error*100))
        
    return mb, training_loss, eval_error


def train_test(train_reader, test_reader, model_func, num_sweeps_to_train_with=10):  #sweeps was 10
    
    # Instantiate the model function; x is the input (feature) variable 
    # We will scale the input image pixels within 0-1 range by dividing all input value by 255.
    tmodel = model_func(x/255)
    tensprint = C.logging.TensorBoardProgressWriter(freq=10, log_dir='C:/users/jiwillia/documents/repos', model=tmodel)
    
    # Instantiate the loss and error function
    loss, label_error = create_criterion_function(tmodel, y)
    
    # Instantiate the trainer object to drive the model training
    learning_rate = 0.2
    lr_schedule = C.learning_rate_schedule(learning_rate, C.UnitType.minibatch)
    learner = C.sgd(z.parameters, lr_schedule)
    trainer = C.Trainer(z, (loss, label_error), [learner],[tensprint]) #bind up trainer, learner,model,loss...
    #note that the trainer does not have the progress printer associated with it jw 8/16
    
    # Initialize the parameters for the trainer
    minibatch_size = 64             #was 64
    num_samples_per_sweep = 6000    #was 60000 - use this for demos
    num_minibatches_to_train = (num_samples_per_sweep * num_sweeps_to_train_with) / minibatch_size
    
    # Map the data streams to the input and labels 
    input_map={
        y  : train_reader.streams.labels,
        x  : train_reader.streams.features
    } 
    
    # Uncomment below for more detailed logging
    training_progress_output_freq = 500
    
     
    # Start a timer
    start = time.time()

    for i in range(0, int(num_minibatches_to_train)):
        # Read a mini batch from the training data file
        data=train_reader.next_minibatch(minibatch_size, input_map=input_map) 
        trainer.train_minibatch(data)
        print_training_progress(trainer, i, training_progress_output_freq, verbose=1)
    # Print training time
    print("Training took {:.1f} sec".format(time.time() - start))
    
    # Test the model
    test_input_map = {
        y  : test_reader.streams.labels,
        x  : test_reader.streams.features
    }

    # Test data for trained model
    test_minibatch_size = 512   #original was 512
    num_samples = 10000         #our unseen images
    num_minibatches_to_test = num_samples // test_minibatch_size

    test_result = 0.0   

    for i in range(num_minibatches_to_test):
    
        # We are loading test data in batches specified by test_minibatch_size
        # Each data point in the minibatch is a MNIST digit image of 784 dimensions 
        # with one pixel per dimension that we will encode / decode with the 
        # trained model.
        data = test_reader.next_minibatch(test_minibatch_size, input_map=test_input_map)
        eval_error = trainer.test_minibatch(data)
        test_result = test_result + eval_error

    # Average of evaluation errors of all test minibatches
    print("Average test error: {0:.2f}%".format(test_result*100 / num_minibatches_to_test))

    #add do traintest
def do_train_test():
        global z
        z = create_model(x)
        print("the z network model is ",repr(z))
        print("model type is: ",type(z))
        reader_train = create_reader(train_file, True, input_dim, num_output_classes)
        reader_test = create_reader(test_file, False, input_dim, num_output_classes)
        train_test(reader_train, reader_test, z)


# function to build model using functional API approach
def create_model(features):
    #the defaults can be overridden at layer level
    with C.layers.default_options(init = C.layers.glorot_uniform(), activation = C.relu):
            r = C.layers.Sequential([
            #features,
            C.layers.Convolution2D(filter_shape=(5,5),num_filters=8,strides=(1,1),pad=True, name="First_Conv"),
            
            C.layers.MaxPooling(filter_shape=(2,2), strides=(2,2), name="First_Max"),
            
            C.layers.Convolution2D(filter_shape=(3,3),  num_filters=16, strides=(1,1), pad=True, name="Second_Conv"),
            
            C.layers.Convolution2D(filter_shape=(5,5),num_filters=24,strides=(1,1), pad=True,name="Third_Conv"),
            
            C.layers.MaxPooling(filter_shape=(3,3), strides=(1,1), name="Second_Max"),
            
            C.layers.Dense(96,name='Dense96'),                              # add a layer of 96 densely connection nodes

            C.layers.layers.Dropout(0.5,name='DropOutB4FinalClassifier'),   # overfit protection

            C.layers.Dense(num_output_classes,activation=None,name='Classifier')
            ]) 

            #r = C.layers.layers.Dropout(0.5,name='DropOutAfterDenseClassifier')(r) #jw 8/14 0.39 avg test error
            #print("\n final network",repr(r)) #add 8/8 1:00PM - shows droput
            cntkfunclist = C.logging.graph.depth_first_search(r(features),lambda j: (True),depth=-1)
            progprint.log("CNTK Objects/Functions Dump")
            for afunc in cntkfunclist:
                progprint.log("Name: " + afunc.name +" --Val: " + repr(afunc) )
                if type(afunc) is C.variables.Parameter:
                    progprint.log(repr(afunc.name) + repr(afunc.value))
                    progprint.log('---------------------------------') 
            #an alternate for just getting parameters
            modparms = r.parameters
            for parm in modparms:
                progprint.log(parm.name + ":" + repr(parm.shape) + "\n" + repr(parm.value))
            
            print('---------------------------------------------------------------------')
            r = r(features) #need to add the feature dimensions and shape to the model otherwise this will fail
                            #at runtime - this is different from the graph API style where the features were passed 
                            # into model at creation
            print("final model:\n ",repr(r))            
            #r=C.debugging.debug_model(r) # - !!! do not use from non-tty enabled interfaces
            return r                        
        
do_train_test()
