#https://www.r-bloggers.com/sentiment-analysis-and-topic-detection-in-r-using-microsoft-cognitive-services/
install.packages("mscstexta4r")

library(mscstexta4r)
textaInit()



setwd("C:\\Users\\acomas\\Source\\Repos\\RSEC\\RSEC")
files <- c("MSFT2017Item 1A", "IBM2017Item 1A", "FB2017Item 1A", "GOOG2017Item 1A", "AMZN2017Item 1A")
#for (filePath in c("MSFT2017Item 1", "MSFT2016Item 1", "MSFT2015Item 1", "MSFT2014Item 1", "MSFT2013Item 1", "MSFT2012Item 1")) {
#filePath <- "IBM2017Item 1"
#text <- readLines(filePath)
files <- c("MSFT2017Item 1", "MSFT2016Item 1", "MSFT2015Item 1", "MSFT2014Item 1", "MSFT2013Item 1", "MSFT2012Item 1")
files <- c("IBM2017Item 1", "IBM2016Item 1", "IBM2015Item 1", "IBM2014Item 1", "IBM2013Item 1", "IBM2012Item 1")
files <- c("FB2017Item 1", "FB2016Item 1", "FB2015Item 1", "FB2014Item 1", "FB2013Item 1", "FB2012Item 1")
files <- c("GOOG2017Item 1", "GOOG2016Item 1", "GOOG2015Item 1", "GOOG2014Item 1", "GOOG2013Item 1", "GOOG2012Item 1")
files <- c("AMZN2017Item 1", "AMZN2016Item 1", "AMZN2015Item 1", "AMZN2014Item 1", "AMZN2013Item 1", "AMZN2012Item 1")

files <- c("IBM2017Item 1A", "IBM2016Item 1", "IBM2015Item 1", "IBM2014Item 1", "IBM2013Item 1", "IBM2012Item 1")
files <- c("FB2017Item 1A", "FB2016Item 1A", "FB2015Item 1A", "FB2014Item 1A", "FB2013Item 1A", "FB2012Item 1A")
files <- c("GOOG2017Item 1A", "GOOG2016Item 1", "GOOG2015Item 1", "GOOG2014Item 1", "GOOG2013Item 1", "GOOG2012Item 1")
files <- c("AMZN2017Item 1A", "AMZN2016Item 1", "AMZN2015Item 1", "AMZN2014Item 1", "AMZN2013Item 1", "AMZN2012Item 1")

files <- c("IBM2017Item 7", "IBM2016Item 7", "IBM2015Item 7", "IBM2014Item 7", "IBM2013Item 7", "IBM2012Item 7")
files <- c("FB2017Item 7", "FB2016Item 7", "FB2015Item 7", "FB2014Item 7", "FB2013Item 7", "FB2012Item 7")
files <- c("GOOG2017Item 7", "GOOG2016Item 1", "GOOG2015Item 1", "GOOG2014Item 7", "GOOG2013Item 7", "GOOG2012Item 7")
files <- c("AMZN2017Item 7", "AMZN2016Item 1", "AMZN2015Item 1", "AMZN2014Item 7", "AMZN2013Item 7", "AMZN2012Item 7")

files <- c("IBM2017Item 7A", "IBM2016Item 7A", "IBM2015Item 7A", "IBM2014Item 7A", "IBM2013Item 7A", "IBM2012Item 7A")
files <- c("FB2017Item 7A", "FB2016Item 7A", "FB2015Item 7A", "FB2014Item 7A", "FB2013Item 7A", "FB2012Item 7A")
files <- c("GOOG2017Item 7A", "GOOG2016Item 7A", "GOOG2015Item 7A", "GOOG2014Item 7A", "GOOG2013Item 7A", "GOOG2012Item 7A")
files <- c("AMZN2017Item 7A", "AMZN2016Item 7A", "AMZN2015Item 7A", "AMZN2014Item 7A", "AMZN2013Item 7A", "AMZN2012Item 7A")
files <- c("MSFT2017Item 7A", "MSFT2016Item 7A", "MSFT2015Item 7A", "MSFT2014Item 7A", "MSFT2013Item 7A", "MSFT2012Item 7A")

fileList = rbind(
c("MSFT2017Item 1", "MSFT2016Item 1", "MSFT2015Item 1", "MSFT2014Item 1", "MSFT2013Item 1", "MSFT2012Item 1")
, c("IBM2017Item 1", "IBM2016Item 1", "IBM2015Item 1", "IBM2014Item 1", "IBM2013Item 1", "IBM2012Item 1")
, c("FB2017Item 1", "FB2016Item 1", "FB2015Item 1", "FB2014Item 1", "FB2013Item 1", "FB2012Item 1")
, c("RHT2017Item 1", "RHT2016Item 1", "RHT2015Item 1", "RHT2014Item 1", "RHT2013Item 1", "RHT2012Item 1")
, c("GOOG2017Item 1", "GOOG2016Item 1", "GOOG2015Item 1")
, c("AMZN2017Item 1", "AMZN2016Item 1", "AMZN2015Item 1", "AMZN2014Item 1", "AMZN2013Item 1", "AMZN2012Item 1")

, c("MSFT2017Item 1A", "MSFT2016Item 1A", "MSFT2015Item 1A", "MSFT2014Item 1A", "MSFT2013Item 1A", "MSFT2012Item 1A")
, c("IBM2017Item 1A", "IBM2016Item 1A", "IBM2015Item 1A", "IBM2014Item 1A", "IBM2013Item 1A", "IBM2012Item 1A")
, c("FB2017Item 1A", "FB2016Item 1A", "FB2015Item 1A", "FB2014Item 1A", "FB2013Item 1A", "FB2012Item 1A")
, c("RHT2017Item 1", "RHT2016Item 1", "RHT2015Item 1", "RHT2014Item 1", "RHT2013Item 1", "RHT2012Item 1")
, c("RHT2017Item 1A", "RHT2016Item 1A", "RHT2015Item 1A", "RHT2014Item 1A", "RHT2013Item 1A", "RHT2012Item 1A")
, c("GOOG2017Item 1A", "GOOG2016Item 1A", "GOOG2015Item 1A")
, c("AMZN2017Item 1A", "AMZN2016Item 1A", "AMZN2015Item 1A", "AMZN2014Item 1A", "AMZN2013Item 1A", "AMZN2012Item 1A")

, c("MSFT2017Item 7", "MSFT2016Item 7", "MSFT2015Item 7", "MSFT2014Item 7", "MSFT2013Item 7", "MSFT2012Item 7")
, c("IBM2017Item 7", "IBM2016Item 7", "IBM2015Item 7", "IBM2014Item 7", "IBM2013Item 7", "IBM2012Item 7")
, c("FB2017Item 7", "FB2016Item 7", "FB2015Item 7", "FB2014Item 7", "FB2013Item 7", "FB2012Item 7")
, c("RHT2017Item 7", "RHT2016Item 7", "RHT2015Item 7", "RHT2014Item 7", "RHT2013Item 7", "RHT2012Item 7")
, c("GOOG2017Item 7", "GOOG2016Item 7", "GOOG2015Item 7")
, c("AMZN2017Item 7", "AMZN2016Item 7", "AMZN2015Item 7", "AMZN2014Item 7", "AMZN2013Item 7", "AMZN2012Item 7")

, c("MSFT2017Item 7A", "MSFT2016Item 7A", "MSFT2015Item 7A", "MSFT2014Item 7A", "MSFT2013Item 7A", "MSFT2012Item 7A")
, c("IBM2017Item 7A", "IBM2016Item 7A", "IBM2015Item 7A", "IBM2014Item 7A", "IBM2013Item 7A", "IBM2012Item 7A")
, c("FB2017Item 7A", "FB2016Item 7A", "FB2015Item 7A", "FB2014Item 7A", "FB2013Item 7A", "FB2012Item 7A")
, c("RHT2017Item 7A", "RHT2016Item 7A", "RHT2015Item 7A", "RHT2014Item 7A", "RHT2013Item 7A", "RHT2012Item 7A")
, c("GOOG2017Item 7A", "GOOG2016Item 7A", "GOOG2015Item 7A")
, c("AMZN2017Item 7A", "AMZN2016Item 7A", "AMZN2015Item 7A", "AMZN2014Item 7A", "AMZN2013Item 7A", "AMZN2012Item 7A")
)

file = "FB2014Item 7A"
text = readLines(file)

for (i in 1:24) {
    files = fileList[i,]
    j <- 1
    m10ks <- unlist(lapply(files, function(x) readLines(x)))
    item <- Map(data.frame, text = m10ks)
    names(item) <- files # seq(2012, 2017)
    set.seed(1234)
    png(filename = paste0("Results/", names(item)[1], "Sentiment.png"), width = 12, height = 8, units = 'in', res = 300)
    plot.new()
    par(mfrow = c(2, 3))
    for (text in m10ks) {
        docsText <- unlist(strsplit(text, ".", fixed = TRUE))
        docsLanguage <- rep("en", length(docsText))

        # Sentiment Analysis
        tryCatch({
        sentiment <- textaSentiment(
                documents = docsText,
                languages = docsLanguage
            )
    }, error = function(err) {
        geterrmessage()
    })
        summary(sentiment$results["score"])
        d <- density(unlist(sentiment$results["score"]))
        plot(d, main = paste0("file:", names(item)[j]))
       j <- j + 1
    }
    dev.off()
}

# Key Phrases
#   tryCatch({
#    keyPhrases <- textaKeyPhrases(
#       documents = docsText,
#       languages = docsLanguage
#       )
#   }, error = function(err) {
#       geterrmessage()
#   })


#  no longer supported
#    tryCatch({
#        # Detect top topics
#        textaEntities(
#            documents = docsText, # At least 100 docs/sentences (English only)
#            stopWords = NULL, # Stop word list (optional)
#            topicsToExclude = c("may", "business", "data", "significant", "changes", "source", "also",
#                "adversely", "lead", "also", "use", "can", "cause", "including", "item", "continue", "relating",
#                "period", "retain", "collect", "deploy", "limit", "affect",
#                "custom", "impact", "global", "success", "increase", "result", "grow", "claim", "inform",
#                "new", "every", "world", "believe", "available", "gaze", "vice", "president", "since", "senior",
#                "jeffrey", "red", "hat", "december", "february", "company"), # Topics to exclude (optional)
#            minDocumentsPerWord = NULL, # Threshold to exclude rare topics (optional)
#            maxDocumentsPerWord = NULL, # Threshold to exclude ubiquitous topics (optional)
#            resultsPollInterval = 60L, # Poll interval (in s, default: 30s, use 0L for async)
#            resultsTimeout = 2000L, # Give up timeout (in s, default: 1200s = 20mn)
#            verbose = TRUE # If set to TRUE, print every poll status to stdout
#        )
#    }, error = function(err) {
#        # Print error
#        geterrmessage()
#    })

 
