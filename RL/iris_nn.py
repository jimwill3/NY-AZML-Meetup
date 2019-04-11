# iris_nn.py
# PyTorch 0.4.1 Anaconda3 5.2.0 (Python 3.6.5)

import numpy as np
import torch as T

# -----------------------------------------------------------

class Batch:
  def __init__(self, num_items, bat_size, seed=0):
    self.num_items = num_items; self.bat_size = bat_size
    self.rnd = np.random.RandomState(seed)

  def next_batch(self):
    return self.rnd.choice(self.num_items, self.bat_size,
      replace=False)
    
# -----------------------------------------------------------

class Net(T.nn.Module):
  def __init__(self):
    super(Net, self).__init__()
    self.fc1 = T.nn.Linear(4, 7)
    T.nn.init.xavier_uniform_(self.fc1.weight)  # glorot
    T.nn.init.zeros_(self.fc1.bias)

    self.fc2 = T.nn.Linear(7, 3)
    T.nn.init.xavier_uniform_(self.fc2.weight)
    T.nn.init.zeros_(self.fc2.bias)

  def forward(self, x):
    z = T.tanh(self.fc1(x))
    z = self.fc2(z)  # see CrossEntropyLoss() below
    return z

# -----------------------------------------------------------

def accuracy(model, data_x, data_y):
  X = T.Tensor(data_x)
  Y = T.LongTensor(data_y)
  oupt = model(X)
  (_, arg_maxs) = T.max(oupt.data, dim=1) 
  num_correct = T.sum(Y==arg_maxs)
  acc = (num_correct * 100.0 / len(data_y))
  return acc.item()

# -----------------------------------------------------------

def main():
  # 0. get started
  print("\nBegin Iris Dataset with PyTorch demo \n")
  T.manual_seed(1);  np.random.seed(1)
  
  # 1. load data
  print("Loading Iris data into memory \n")
  train_file = ".\\Data\\iris_train.txt"
  test_file = ".\\Data\\iris_test.txt"

  train_x = np.loadtxt(train_file, usecols=range(0,4),
    delimiter=",",  skiprows=0, dtype=np.float32)
  train_y = np.loadtxt(train_file, usecols=[4],
    delimiter=",", skiprows=0, dtype=np.float32)

  test_x = np.loadtxt(test_file, usecols=range(0,4),
    delimiter=",",  skiprows=0, dtype=np.float32)
  test_y = np.loadtxt(test_file, usecols=[4],
    delimiter=",", skiprows=0, dtype=np.float32)

  # 2. define model
  net = Net()

# -----------------------------------------------------------

  # 3. train model
  net = net.train()  # set training mode
  lrn_rate = 0.01; b_size = 12
  max_i = 600; n_items = len(train_x)

  loss_func = T.nn.CrossEntropyLoss()  # applies softmax()
  optimizer = T.optim.SGD(net.parameters(), lr=lrn_rate)
  batcher = Batch(num_items=n_items, bat_size=b_size)

  print("Starting training")
  for i in range(0, max_i):
    if i > 0 and i % (max_i/10) == 0:
      print("iteration = %4d" % i, end="")
      print("  loss = %7.4f" % loss_obj.item(), end="")
      acc = accuracy(net, train_x, train_y)
      print("  accuracy = %0.2f%%" % acc)

    curr_bat = batcher.next_batch()
    X = T.Tensor(train_x[curr_bat])
    Y = T.LongTensor(train_y[curr_bat])
    optimizer.zero_grad()
    oupt = net(X)
    loss_obj = loss_func(oupt, Y)
    loss_obj.backward()
    optimizer.step()
  print("Training complete \n")
    
  # 4. evaluate model
  net = net.eval()  # set eval mode
  acc = accuracy(net, test_x, test_y)
  print("Accuracy on test data = %0.2f%%" % acc)  

  # 5. save model
  # TODO

# -----------------------------------------------------------

  # 6. make a prediction
  unk = np.array([[6.1, 3.1, 5.1, 1.1]], dtype=np.float32)
  unk = T.tensor(unk)  # to Tensor
  logits = net(unk)  # values do not sum to 1.0
  probs_t = T.softmax(logits, dim=1)  # as Tensor
  probs = probs_t.detach().numpy()    # to numpy array

  print("\nSetting inputs to:")
  for x in unk[0]: print("%0.1f " % x, end="")
  print("\nPredicted: (setosa, versicolor, virginica)")
  for p in probs[0]: print("%0.4f " % p, end="") 

  print("\n\nEnd Iris demo")

if __name__ == "__main__":
  main()
