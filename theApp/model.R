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
  out$count <- out$count/sum(dfm_r1$count)
  names(out) <- c('next','prob')
  return(out)
}

## Check bigrams
nextWords_2 <- function(x) {
  len <- length(x)
  if (len < 1)
    return(data.table("next" = character(0), "prob" = numeric(0)))
  out <- dfm_r2[V1 == x[len], .(count = sum(count)), by=(NextWord=V2)][order(-count)]
  out$count <- out$count/sum(out$count)
  names(out) <- c('next','prob')
  return(out)
}

## Check trigrams
nextWords_3 <- function(x, gamma=0.3) {
  len <- length(x)
  if (len < 2)
    return(data.table("next" = character(0), "prob" = numeric(0)))  
  out <- dfm_r3[V1==x[len-1] & V2==x[len], .(count = sum(count)), by=(NextWord=V3)][order(-count)]    
  out$count <- out$count/sum(out$count)*(1-gamma)
  names(out) <- c('next','prob')  
  
  out2 <- dfm_r3[V1==x[len-1], .(count = sum(count)), by=(NextWord=V3)][order(-count)]
  out2$count <- out2$count/sum(out2$count)*gamma
  names(out2) <- c('next','prob')  
  
  out <- rbind(out, out2)
  out <- out[,.(prob=sum(prob)),by="next"]
  return(out)
}

## Check quadgrams
nextWords_4 <- function(x, gamma=0.3) {
  len <- length(x)
  if (len < 3)
    return(data.table("next" = character(0), "prob" = numeric(0)))  
  out <- dfm_r4[V1==x[len-2] & V2==x[len-1] & V3==x[len], .(count = sum(count)), by=(NextWord=V4)][order(-count)]     
  out$count <- out$count/sum(out$count)*(1-gamma)
  names(out) <- c('next','prob')  
  
  out2 <- dfm_r4[V1==x[len-2], .(count = sum(count)), by=(NextWord=V4)][order(-count)]
  out2$count <- out2$count/sum(out2$count)*gamma*(1/3)
  names(out2) <- c('next','prob')  
  out <- rbind(out, out2)
  
  out2 <- dfm_r4[V1==x[len-2] & V2==x[len-1], .(count = sum(count)), by=(NextWord=V4)][order(-count)]
  out2$count <- out2$count/sum(out2$count)*gamma*(1/3)
  names(out2) <- c('next','prob')  
  out <- rbind(out, out2)
  
  out2 <- dfm_r4[V1==x[len-2] & V3==x[len], .(count = sum(count)), by=(NextWord=V4)][order(-count)] 
  out2$count <- out2$count/sum(out2$count)*gamma*(1/3)
  names(out2) <- c('next','prob')  
  out <- rbind(out, out2)
  
  out <- out[,.(prob=sum(prob)),by="next"]
  return(out)
}

predictNextWord <- function(x, lambda=c(0.4,0.3,0.2,0.1)){
  x <- splitInput(x)
  
  out <- nextWords_4(x)
  out$prob <- out$prob * lambda[1]
  
  out2 <- nextWords_3(x)
  out2$prob <- out2$prob * lambda[2]
  out <- rbind(out, out2)
  
  out2 <- nextWords_2(x)
  out2$prob <- out2$prob * lambda[3]
  out <- rbind(out, out2)
  
  out2 <- nextWords_1()
  out2$prob <- out2$prob * lambda[4]
  out <- rbind(out, out2)
  
  out <- out[,.(prob=sum(prob)),by="next"][order(-prob)]
  
  out$prob <- out$prob * 100
  names(out) <- c("next", "confidence (%)")
  
  return(filterProfanity(head(out,n=3)))
}


