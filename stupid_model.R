library(stringr)
for(i in 1:4){
    load(paste("data/dfm_r", i, ".RData",sep=""))
}

predictNextWord <- function(x){
    input <- x
    prev_words <- str_split_fixed(input, " ", n=-1)
    len <- length(prev_words)
    
    output <- NULL
    
    if(len>=3){
        res <- dfm_r4[dfm_r4$V1 %in% prev_words[len-2] & dfm_r4$V2 %in% prev_words[len-1] & dfm_r4$V3 %in% prev_words[len], list(V4, count)]
        if(!is.null(nrow(res)) && nrow(res)>0){
            output <- res[order(-rank(count))]
        }
    }
    if(len >=2 && is.null(output)){
        res <- dfm_r3[dfm_r3$V1 %in% prev_words[len-1] & dfm_r3$V2 %in% prev_words[len], list(V3, count)]
        if(!is.null(nrow(res)) && nrow(res)>0){
            output <- res[order(-rank(count))]
        }
    }
    if(len >=1 && is.null(output)){
        res <- dfm_r2[dfm_r2$V1 %in% prev_words[len], list(V2, count)]
        if(!is.null(nrow(res)) && nrow(res)>0){
            output <- res[order(-rank(count))]
        }
    }
    if(is.null(output)){
        res <- head(dfm_r1,3)
        if(!is.null(nrow(res)) && nrow(res)>0){
            output <- res[order(-rank(count))]
        }
    }
    names(output) <- c("NextWord", "count")
    return(output)
}


