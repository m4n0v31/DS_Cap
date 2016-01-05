for(i in 1:4){
  load(paste("dfm_r", i, ".RData",sep=""))
}

profanitiesFilter <- TRUE
if (file.exists("swearWords.txt")) {
  # Read in the data
  if ( profanitiesFilter)
    profanities <- scan("swearWords.txt", what="", sep="\n")
  else
    profanities <- list()
}

## Clean input sentence
cleanInput <- function(x) {
  # convert to lowercase
  x <- tolower(x)
  # remove brackets
  x <- gsub("^[(]|[)]$", " ", x)
  x <- gsub("[(].*?[)]", " ", x)  
  # remove numbers
  x <- gsub("\\S*[0-9]+\\S*", " ", x)
  # reduce whitespaces and trim whitespace
  x <- gsub("\\s+"," ",x)
  x <- gsub("^\\s+|\\s+$", "", x)
  return(x)
}

## Split input sentence
splitInput <- function(x) {
  return(str_split_fixed(cleanInput(x), " ", n=-1))
}

## Split input sentence
filterProfanity <- function(x) {
  x[x$"next" %in% profanities]$"next" <- "$@#!"
  return(x)
}

## Check unigrams
nextWords_1 <- function() {
  out <- data.table(head(dfm_r1,n=3))
  out$count <- out$count/sum(out$count)
  res <- data.table(matrix(data=0,nrow=nrow(out),ncol=6))
  res$V1 <- out$count
  res <- cbind(word=as.character(out$V1),res)
  return(res)
}

## Check bigrams
nextWords_2 <- function(x) {
  len <- length(x)
  if (len < 1)
    return(data.table("word" = character(0), matrix(data=0,nrow=0,ncol=6)))
  out <- dfm_r2[V1 == x[len], .(count = sum(count)), by=V2][order(-count)]
  out$count <- out$count/sum(out$count)
  res <- data.table(matrix(data=0,nrow=nrow(out),ncol=6))
  res$V2 <- out$count
  res <- cbind(word=as.character(out$V2),res)  
  return(res)
}

## Check trigrams
nextWords_3 <- function(x) {
  len <- length(x)
  if (len < 2)
    return(data.table("word" = character(0), matrix(data=0,nrow=0,ncol=6)))  
  out <- dfm_r3[V1==x[len-1] & V2==x[len], .(count = sum(count)), by=V3][order(-count)]    
  out$count <- out$count/sum(out$count)
  res <- data.table(matrix(data=0,nrow=nrow(out),ncol=6))
  res$V3 <- out$count
  res <- cbind(word=as.character(out$V3),res)  
  
  out <- dfm_r3[V1==x[len-1], .(count = sum(count)), by=V3][order(-count)]
  out$count <- out$count/sum(out$count)
  res2 <- data.table(matrix(data=0,nrow=nrow(out),ncol=6))
  res2$V4 <- out$count
  res2 <- cbind(word=as.character(out$V3),res2) 
  
  res <- rbind(res, res2)
  return(res)
}

## Check quadgrams
nextWords_4 <- function(x) {
  len <- length(x)
  if (len < 3)
    return(data.table("word" = character(0), matrix(data=0,nrow=0,ncol=6)))  
  out <- dfm_r4[V1==x[len-2] & V2==x[len-1] & V3==x[len], .(count = sum(count)), by=V4][order(-count)]     
  out$count <- out$count/sum(out$count)
  res <- data.table(matrix(data=0,nrow=nrow(out),ncol=6))
  res$V5 <- out$count
  res <- cbind(word=as.character(out$V4),res)   

  out <- dfm_r4[V1==x[len-2], .(count = sum(count)), by=V4][order(-count)]
  out$count <- out$count/sum(out$count)*(1/3)
  res2 <- data.table(matrix(data=0,nrow=nrow(out),ncol=6))
  res2$V6 <- out$count
  res2 <- cbind(word=as.character(out$V4),res2) 
  res <- rbind(res, res2)  

  out <- dfm_r4[V1==x[len-2] & V2==x[len-1], .(count = sum(count)), by=V4][order(-count)]
  out$count <- out$count/sum(out$count)*(1/3)
  res2 <- data.table(matrix(data=0,nrow=nrow(out),ncol=6))
  res2$V6 <- out$count
  res2 <- cbind(word=as.character(out$V4),res2) 
  res <- rbind(res, res2)  
  
  out <- dfm_r4[V1==x[len-2] & V3==x[len], .(count = sum(count)), by=V4][order(-count)] 
  out$count <- out$count/sum(out$count)*(1/3)
  res2 <- data.table(matrix(data=0,nrow=nrow(out),ncol=6))
  res2$V6 <- out$count
  res2 <- cbind(word=as.character(out$V4),res2) 
  res <- rbind(res, res2) 

  return(res)
}

predictNextWord <- function(x, gamma=c(0.3,0.2), lambda=c(0.02,0.2,0.3,0.48)){
  x <- splitInput(x)
  len <- length(x)
  
  out <- nextWords_1()
  if (len > 0)
    out <- rbind(out, nextWords_2(x))
  if (len > 1)
    out <- rbind(out, nextWords_3(x))  
  if (len > 2)
    out <- rbind(out, nextWords_4(x))   
  
  theFactor <- sum(lambda[1:min(4,len+1)])
  out <- out[,.(prob=(sum(V1)*lambda[1]+sum(V2)*lambda[2]+(sum(V3)*(1-gamma[1])+sum(V4)*gamma[1])*lambda[3]+(sum(V5)*(1-gamma[2])+sum(V6)*gamma[2])*lambda[4])/theFactor),by="word"][order(-prob)]
  
  out$prob <- out$prob * 100
  
  names(out) <- c("word","prob (%)")
  
  return(filterProfanity(out))
}


