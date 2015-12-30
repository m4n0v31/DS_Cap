library(stringr)
library(data.table)
for(i in 1:4){
    load(paste("dfm_r", i, ".RData",sep=""))
}

predictNextWord <- function(x){
    input <- x
    prev_words <- str_split_fixed(str_to_lower(input), " ", n=-1)
    len <- length(prev_words)
    
    output <- NULL
    
    dfm_r4[V1==prev_words[len-2] & V2==prev_words[len-1] & V3==prev_words[len], .(count = sum(count)), by=(NextWord=V4)][order(-count)]    
    dfm_r4[V1==prev_words[len-2], .(count = sum(count)), by=(NextWord=V4)][order(-count)]
    dfm_r4[V1==prev_words[len-2] & V2==prev_words[len-1], .(count = sum(count)), by=(NextWord=V4)][order(-count)]
    dfm_r4[V1==prev_words[len-2] & V3==prev_words[len], .(count = sum(count)), by=(NextWord=V4)][order(-count)]    
    
    dfm_r3[V1==prev_words[len-1] & V2==prev_words[len], .(count = sum(count)), by=(NextWord=V3)][order(-count)]    
    dfm_r3[V1==prev_words[len-1], .(count = sum(count)), by=(NextWord=V3)][order(-count)]

    dfm_r2[V1==prev_words[len], .(count = sum(count)), by=(NextWord=V2)][order(-count)] 
    
    head(dfm_r1,n=3)
    
    return(output)
}


