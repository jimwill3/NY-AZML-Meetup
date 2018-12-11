#https://rdrr.io/cran/edgarWebR/f/vignettes/edgarWebR.Rmd
install.packages("edgarWebR")
library("knitr")
knitr::opts_chunk$set(collapse = T, comment = "#>")
library("edgarWebR")
set.seed(0451)

tickers <- c("FB", "MSFT", "IBM", "AMZN", "GOOG", "RHT")

for (ticker in tickers) {
    print(ticker)
 ticker <- "MSFT"

filings <- company_filings(ticker, type = "10-K", count = 40)
# Specifying the type provides all forms that start with 10-, so we need to
# manually filter.
filings <- filings[filings$type == "10-K",]

# We're only interested the last 6 years

#filing <- filings[filings$filing_date == "2018-08-03",]
filing <- filings[filings$filing_date > "2012-01-01",]

filing$md_href <- paste0("[Link](", filing$href, ")")
knitr::kable(filing[, c("type", "filing_date", "accession_number", "size",
                                "md_href")],
             col.names = c("Type", "Filing Date", "Accession No.", "Size", "Link"),
             digits = 2,
             format.args = list(big.mark = ","))

# get years
#records in reverse order by year starting with latest - 
i <- 1
for (year in 2017:2012) {
    print(year)
    if (is.na(filing$href[i])) break
    docs <- filing_documents(filing$href[i])

    i <- i + 1
    doc <- docs[docs$description == 'Complete submission text file',]
    doc$md_href <- paste0("[Link](", doc$href, ")")

    knitr::kable(doc[, c("seq", "description", "document", "size",
                     "md_href")],
             col.names = c("Sequence", "Description", "Document",
                           "Size", "Link"),
             digits = 2,
             format.args = list(big.mark = ","))

    parsed_docs <- parse_submission(doc$href)
    knitr::kable(head(parsed_docs[, c("SEQUENCE", "TYPE", "DESCRIPTION", "FILENAME")]),
             col.names = c("Sequence", "Type", "Description", "Document"),
             digits = 2,
             format.args = list(big.mark = ","))

#    knitr::kable(tail(parsed_docs[, c("SEQUENCE", "TYPE", "DESCRIPTION", "FILENAME")]),
#             col.names = c("Sequence", "Type", "Description", "Document"),
#             digits = 2,
#             format.args = list(big.mark = ","))

    # NOTE: the filing document is not always #1, so it is a good idea to also look
    # at the type &  Description
    filing_doc <- parsed_docs[parsed_docs$TYPE == '10-K', 'TEXT']
#                          & parsed_docs$DESCRIPTION == '10-K', 'TEXT']
    if (length(filing_doc) == 0) {
        print("cannot parse doc")
        break
    }
    for (part in c("Item 1","Item 1A", "Item 7", "Item 7A")) { 
        doc <- parse_filing(filing_doc, include.raw = TRUE)
        unique(doc$part.name)
        unique(doc$item.name)
        #head(doc[grepl("7A", doc$item.name, ignore.case = TRUE), "text"], 20)
        if (part == "Item 1" || part == "Item 7") {
            part1 <- paste0(part, "\\W")
        } else {
                part1 <- part
        }
        part
        risks <- doc[grepl(part1, doc$item.name, ignore.case = TRUE, fixed = FALSE, useBytes = FALSE), "text"]
        #risks <- doc[grepl("1A", doc$item.name, ignore.case = TRUE), "raw"]

     # write the file out
        base <- "c:\\Downloads\\"
        t <- paste(ticker, year, part, sep = "")
        sink(t, append = FALSE)
        cat(risks)
        sink()
    }
}
}

#Now the document is all ready for
#    whatever further processing we want. As a quick example we 'll pull out all the italicized risks.
risks <- risks[grep("<b>", risks)]
risks <- gsub("^.*<b>|</b>.*$", "", risks)
risks <- gsub("\n", " ", risks)
risks