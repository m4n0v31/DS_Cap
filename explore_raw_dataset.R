# Explore data set

# load library
library(stringi)
library(tm)

if(!dir.exists("final")){
    stop("Download and extract the Capstone dataset!")
}

# display unzipped data
list.files("final")

# display en_US data
list.files("final/en_US")

# explore en_US data sets
inputs <- c("blogs", "news", "twitter")

# Quiz 1 questions: 
for(i in inputs){
    print(paste("Processing ", i))
    input <- paste("final/en_US/en_US.", i, ".txt", sep = "")
    # 1) Size in MB;
    size_MB <- file.size(input)/1024
    data <- readLines(input, encoding="UTF-8")
    # 2) lines of text;
    lines_text <- length(data)
    # 3) length longest line;
    char_number <- nchar(data)
    # 4) love/hate;
    love_hate <- length(grep("love", data, ignore.case = FALSE))/length(grep("hate",data, ignore.case = FALSE))
    # 5) "biostats" match
    biostats <- data[grep("biostats", data, ignore.case = TRUE)]
    # 6) number of "^A computer once beat me at chess, but it was no match for me at kickboxing$"
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
