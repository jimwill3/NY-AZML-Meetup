#http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know
#Install
install.packages("dplyr")
install.packages("xtable")
install.packages("ggplot2")
install.packages("lsa")
install.packages("tm") # for text mining
install.packages("SnowballC") # for text stemming
install.packages("wordcloud") # word-cloud generator 
install.packages("RColorBrewer") # color palettes

#install.packages("openNLPmodels.en")
# Load
library(dplyr)
library(xtable)
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("plyr")
library(ggplot2)
library(lsa)


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

files <- c("IBM2017Item 1", "IBM2016Item 1", "IBM2015Item 1", "IBM2014Item 1", "IBM2013Item 1", "IBM2012Item 1")
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

fileList = rbind(
c("MSFT2017Item 1", "MSFT2016Item 1", "MSFT2015Item 1", "MSFT2014Item 1", "MSFT2013Item 1", "MSFT2012Item 1")
,c("IBM2017Item 1", "IBM2016Item 1", "IBM2015Item 1", "IBM2014Item 1", "IBM2013Item 1", "IBM2012Item 1")
,c("FB2017Item 1", "FB2016Item 1", "FB2015Item 1", "FB2014Item 1", "FB2013Item 1", "FB2012Item 1")
,c("RHT2017Item 1", "RHT2016Item 1", "RHT2015Item 1", "RHT2014Item 1", "RHT2013Item 1", "RHT2012Item 1")
,c("GOOG2017Item 1", "GOOG2016Item 1", "GOOG2015Item 1")
,c("AMZN2017Item 1", "AMZN2016Item 1", "AMZN2015Item 1", "AMZN2014Item 1", "AMZN2013Item 1", "AMZN2012Item 1")

,c("MSFT2017Item 1A", "MSFT2016Item 1A", "MSFT2015Item 1A", "MSFT2014Item 1A", "MSFT2013Item 1A", "MSFT2012Item 1A")
,c("IBM2017Item 1A", "IBM2016Item 1A", "IBM2015Item 1A", "IBM2014Item 1A", "IBM2013Item 1A", "IBM2012Item 1A")
,c("FB2017Item 1A", "FB2016Item 1A", "FB2015Item 1A", "FB2014Item 1A", "FB2013Item 1A", "FB2012Item 1A")
,c("RHT2017Item 1", "RHT2016Item 1", "RHT2015Item 1", "RHT2014Item 1", "RHT2013Item 1", "RHT2012Item 1")
,c("RHT2017Item 1A", "RHT2016Item 1A", "RHT2015Item 1A", "RHT2014Item 1A", "RHT2013Item 1A", "RHT2012Item 1A")
,c("GOOG2017Item 1A", "GOOG2016Item 1A", "GOOG2015Item 1A")
,c("AMZN2017Item 1A", "AMZN2016Item 1A", "AMZN2015Item 1A", "AMZN2014Item 1A", "AMZN2013Item 1A", "AMZN2012Item 1A")

,c("MSFT2017Item 7", "MSFT2016Item 7", "MSFT2015Item 7", "MSFT2014Item 7", "MSFT2013Item 7", "MSFT2012Item 7")
,c("IBM2017Item 7", "IBM2016Item 7", "IBM2015Item 7", "IBM2014Item 7", "IBM2013Item 7", "IBM2012Item 7")
,c("FB2017Item 7", "FB2016Item 7", "FB2015Item 7", "FB2014Item 7", "FB2013Item 7", "FB2012Item 7")
,c("RHT2017Item 7", "RHT2016Item 7", "RHT2015Item 7", "RHT2014Item 7", "RHT2013Item 7", "RHT2012Item 7")
,c("GOOG2017Item 7", "GOOG2016Item 7", "GOOG2015Item 7")
,c("AMZN2017Item 7", "AMZN2016Item 7", "AMZN2015Item 7", "AMZN2014Item 7", "AMZN2013Item 7", "AMZN2012Item 7")

,c("MSFT2017Item 7A", "MSFT2016Item 7A", "MSFT2015Item 7A", "MSFT2014Item 7A", "MSFT2013Item 7A", "MSFT2012Item 7A")
,c("IBM2017Item 7A", "IBM2016Item 7A", "IBM2015Item 7A", "IBM2014Item 7A", "IBM2013Item 7A", "IBM2012Item 7A")
,c("FB2017Item 7A", "FB2016Item 7A", "FB2015Item 7A", "FB2014Item 7A", "FB2013Item 7A", "FB2012Item 7A")
,c("RHT2017Item 7A", "RHT2016Item 7A", "RHT2015Item 7A", "RHT2014Item 7A", "RHT2013Item 7A", "RHT2012Item 7A")
,c("GOOG2017Item 7A", "GOOG2016Item 7A", "GOOG2015Item 7A")
,c("AMZN2017Item 7A", "AMZN2016Item 7A", "AMZN2015Item 7A", "AMZN2014Item 7A", "AMZN2013Item 7A", "AMZN2012Item 7A")
)

for (i in 1:24) {
    files = fileList[i,]
    m10ks <- unlist(lapply(files, function(x) readLines(x)))
    item <- Map(data.frame, text = m10ks)
    names(item) <- files # seq(2012, 2017)

    toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
    docs <- lapply(item, function(x) {
        Corpus(VectorSource(x$text)) %>%
        tm_map(toSpace, "/") %>%
        tm_map(toSpace, "@") %>%
        tm_map(toSpace, "\\|")
    })

    # Convert the text to lower case
    docs <- lapply(docs, function(doc) tm_map(doc, content_transformer(tolower)))
    # Remove numbers
    docs <- lapply(docs, function(doc) tm_map(doc, removeNumbers))
    # Remove english common stopwords
    docs <- lapply(docs, function(doc) tm_map(doc, removeWords, stopwords("english")))
    # Remove your own stop word
    # specify your stopwords as a character vector
    docs <- lapply(docs, function(doc) tm_map(doc, removeWords, c("may", "business", "data", "significant", "changes", "source", "also",
        "adversely", "lead", "also", "use", "can", "cause", "including", "item", "continue", "relating",
        "period", "retain", "collect", "deploy", "limit", "affect", 
        "custom", "impact", "global", "success", "increase", "result", "grow", "claim", "inform",
        "new", "every", "world", "believe", "available", "gaze", "vice", "president", "since", "senior",
        "jeffrey", "red", "hat", "december", "february", "company")))
    # Remove punctuations
    docs <- lapply(docs, function(doc) tm_map(doc, removePunctuation))
    # Eliminate extra white spaces
    docs <- lapply(docs, function(doc) tm_map(doc, stripWhitespace))
    # Text stemming
    #docs <- lapply(docs, function(doc) tm_map(doc, stemDocument))

    dtm <- lapply(docs, function(doc) TermDocumentMatrix(doc))

    m <- lapply(dtm, function(doc) as.matrix(doc))

    #resumne old...
    v <- lapply(m, function(x) sort(rowSums(x), decreasing = TRUE))
    d <- lapply(v, function(x) data.frame(word = names(x), freq = x))
    lapply(d, function(x) head(x, 5))

    #heatmap(as.matrix(d[1])[,1])
    # t <- paste(filePath, "_words", sep = "")
    #write.table(head(d, 20), file = t, sep = ",")

    #plot all years in 1 table
    png(filename = paste0("Results/", names(d)[1], "BPSummary.png"), width = 12, height = 8, units = 'in', res = 300)
    plot.new()
    par(mar=rep(4,4))
    par(mfrow = c(2, 3))
    lapply(names(d), function(x) {
        #png(filename = paste0("Results/", x, "BP.png"), width = 12, height = 8, units = 'in', res = 300))
        barplot(d[[x]][1:10,]$freq, las = 2, names.arg = d[[x]][1:10,]$word,
        col = "lightblue", main = paste0("MFWs:", x),
        ylab = "Word frequencies:")
        #dev.off()
    })
    dev.off()

    # plot all years in one page
    set.seed(1234)
    png(filename = paste0("Results/", names(d)[1], "WCSummary.png"), width = 12, height = 8, units = 'in', res = 300)
    plot.new()
    par(mar = rep(0, 4))
    par(mfrow = c(2, 3))
    lapply(names(d), function(x) {
        wordcloud(words = d[[x]]$word, freq = d[[x]]$freq, scale = c(8, 0.2), min.freq = 2,
          max.words = 100, random.order = FALSE, rot.per = 0.15, size = 1.6,
          colors = brewer.pal(8, "Dark2"), main = "Title")
        text(x = 0.2, y = 0.0, paste0("File: ", x))
    })
    dev.off()
}

#write out each file individually
#lapply(names(d), function(x) {
#    png(filename = paste0("Results/", x, "WC.png"))
#    layout(matrix(c(1, 2), nrow = 2), heights = c(1, 4))
#    par(mar = rep(0, 4))
#    plot.new()
#    text(x = 0.3, y = 0.3, paste0("File: ", x))
#    wordcloud(words = d[[x]]$word, freq = d[[x]]$freq, scale = c(8, 0.2), min.freq = 3,
#          max.words = 100, random.order = FALSE, rot.per = 0.15,
#          colors = brewer.pal(8, "Dark2"), main = "Title")
#    dev.off()
#})


comparison.cloud(as.matrix(d), max.words = 300, random.order = FALSE,
    rot.per = .1, colors = brewer.pal(max(3, ncol(term.matrix)), "Dark2"),
    use.r.layout = FALSE, title.size = 3)

x = rbind(c(1, 2), c(3, 4))
for (i in 1:2) {
    print(x[i,])
}
