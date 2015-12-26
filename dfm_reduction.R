library(stringr)
library(data.table)
library(quanteda)

load("data/dfm.RData")
vec <- topfeatures(dfm, n = length(features(dfm)), decreasing = TRUE)
data <- data.frame(keyName = names(vec), count = vec, row.names=NULL)

data$cumsum <- cumsum(data$count)
stats <- c(sum(data$cumsum < sum(data$count)*50/100), sum(data$cumsum < sum(data$count)*90/100), sum(data$cumsum < sum(data$count)*95/100), nrow(data))
stats <- data.frame(as.list(stats))
names(stats) <- c("50%", "90%", "95%", "100%")

dfm_r1 <- data[1:stats$"95%", c("keyName", "count")]
names(dfm_r1) <- c("V1","count")
save(dfm_r1, file="data/dfm_r1.RData")
rm(dfm)
rm(data)
rm(stats)

for(i in 2:4){
    load(paste("data/dfm_", i, ".RData",sep=""))
    dfm <- eval(parse(text=paste("dfm_",i,sep="")))
    rm(list = paste("dfm_",i,sep=""))
    vec <- topfeatures(dfm, n = length(features(dfm)), decreasing = TRUE)
    data <- data.table(keyName = names(vec), count = vec)
    data <- cbind(str_split_fixed(data$keyName, " ", i), data)
    data[,keyName:=NULL]
    for(k in 1:i){
        data <- data[eval(parse(text=c(names(data)[k]))) %in% dfm_r1$V1]
    }
    if(i>2){
        data <- data[count>1,]
    }
    setkey(data,count)
    data <- data[,tail(.SD,3),by=c(names(data)[1:(i-1)])]
    cols <- names(data)[1:i]
    data[,(cols):=lapply(.SD, as.factor),.SDcols=cols]    
    assign(paste("dfm_r",i,sep=""), data)
    save(list = paste("dfm_r",i,sep=""), file=paste("data/dfm_r", i, ".RData", sep=""))
    rm(data)
    rm(vec)
    rm(list = paste("dfm_r",i,sep=""))
    rm(dfm)
}
rm(dfm_r1)


