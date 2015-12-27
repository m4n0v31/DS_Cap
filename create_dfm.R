# Compute dtm
library(ggplot2)
library(knitr)
library(tm)
library(quanteda)


corpora <- corpus(textfile("data/*train.txt"))

if(!file.exists("data/dfm.RData")){
    dfm <- dfm(corpora)
    save(dfm, file="data/dfm.RData")
    rm(dfm)
}

for(i in 2:4){
    if(!file.exists(paste("data/dfm_", i, ".RData", sep=""))){
        assign(paste("dfm_",i,sep=""), dfm(corpora, ngrams = i, concatenator = " "))
        save(list = paste("dfm_",i,sep=""), file=paste("data/dfm_", i, ".RData", sep=""))
        rm(list = paste("dfm_",i,sep=""))
    }
}
# 
# # load 1-grams
# load("data/dfm.RData")
# vec <- topfeatures(dfm, n = length(features(dfm)), decreasing = TRUE)
# data <- data.frame(keyName = names(vec), count = vec, row.names=NULL)
# rm(dfm)
# # barplot with 20 most occuring
# ggplot(data[1:20,], aes(x = reorder(keyName, -count), y = count)) + geom_bar(stat = "identity")
# # Calculate 1-grams coverage of the dataset
# data$cumsum <- cumsum(data$count)
# stats <- c(sum(data$cumsum < sum(data$count)*50/100), sum(data$cumsum < sum(data$count)*90/100), sum(data$cumsum < sum(data$count)*95/100), nrow(data))
# stats <- data.frame(as.list(stats))
# names(stats) <- c("50%", "90%", "95%", "100%")
# knitr::kable((stats))
# 
# # load 2-grams
# load("data/dfm_2.RData")
# vec <- topfeatures(dfm_2, n = length(features(dfm_2)), decreasing = TRUE)
# data <- data.frame(keyName = names(vec), count = vec, row.names=NULL)
# rm(dfm_2)
# # barplot with 20 most occuring
# ggplot(data[1:20,], aes(x = reorder(keyName, -count), y = count)) + geom_bar(stat = "identity")
# # Calculate 2-grams coverage of the dataset
# data$cumsum <- cumsum(data$count)
# stats <- c(sum(data$cumsum < sum(data$count)*50/100), sum(data$cumsum < sum(data$count)*90/100), sum(data$cumsum < sum(data$count)*95/100), nrow(data))
# stats <- data.frame(as.list(stats))
# names(stats) <- c("50%", "90%", "95%", "100%")
# knitr::kable((stats))
