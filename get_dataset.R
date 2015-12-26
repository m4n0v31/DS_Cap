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

# en_US news contain a character at line 77259 that prevents it to be complelty 
# loaded (readLines(...) Warning: incomplete final line found).
# Character will be removed here
if(file.exists("final/en_US/en_US.news.bak")){
    cat("News already corrected... using local copy.\n")
}else{
    cat("Correcting News file... ")
    con <- file("final/en_US/en_US.news.txt", "rb")
    data <- readLines(con)
    close(con)
    file.rename("final/en_US/en_US.news.txt", "final/en_US/en_US.news.bak")
    data <- gsub("\032", "", data)
    con <- file("final/en_US/en_US.news.txt", "wb")
    writeLines(data, con)
    close(con)
    cat("Done.\n")    
}