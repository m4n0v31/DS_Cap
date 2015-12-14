# install required packages
#install.packages("stringi")
#install.packages("tm")

# load library
library(stringi)
library(tm)

# set wd
setwd("GitHub/DS_Cap/")

# Download and Unzip
force_update <- FALSE

if(file.exists("Coursera-SwiftKey.zip") && !force_update){
  cat("No need to download Capstone Dataset... using local copy.\n")
}else{
  cat("Downloading Capstone Dataset... ")
  download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", "Coursera-SwiftKey.zip")  
  cat("Done.\n")
}

if(dir.exists("final") && !force_update){
  cat("No need to unzip Capstone Dataset... using local copy.\n")
}else{
  cat("Unzipping Capstone Dataset... ")
  unzip("Coursera-SwiftKey.zip") 
  cat("Done.\n")
}

# display unzipped data
list.files("final")

# display en_US data
list.files("final/en_US")

# explore en_US data sets
inputs <- c("blogs", "news", "twitter")

# Quiz 1 questions: 1) Size in MB; 2) lines of text; 3) length longest line; 4) love/hate; 5) "biostats" match 6) number of "^A computer once beat me at chess, but it was no match for me at kickboxing$"
for(i in inputs){
  print(paste("Processing ", i))
  input <- paste("final/en_US/en_US.", i, ".txt", sep = "")
  size_MB <- file.size(input)/1024
  data <- readLines(input, encoding="UTF-8")
  lines_text <- length(data)
  char_number <- nchar(data)
  love_hate <- length(grep("love", data, ignore.case = FALSE))/length(grep("hate",data, ignore.case = FALSE))
  biostats <- data[grep("biostats", data, ignore.case = TRUE)]
  exact_sentence <- length(grep("^A computer once beat me at chess, but it was no match for me at kickboxing$", data))
  stringi_stats <- stri_stats_general(data)
  stringi_words <- stri_count_words(data, locale = "en_US")

  print(paste("size_MB: ", size_MB))
  print(paste("lines_text: ", lines_text))
  print(paste("summary(char_number): "))
  print(summary(char_number))
  print(paste("love_hate: ", love_hate))
  print(paste("biostats: ", biostats))
  print(paste("exact_sentence: ", exact_sentence))
  print(paste("stringi_stats: "))
  print(stringi_stats)
  print(paste("summary(stringi_words): "))
  print(summary(stringi_words))

  #out <- stri_split_boundaries(data, type="sentence", skip_sentence_sep=TRUE)
}
