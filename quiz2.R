library(stringr)
for(i in 1:4){
    load(paste("data/dfm_r", i, ".RData",sep=""))
}

in <- "at the end"
prev_words <- str_split_fixed("at the end", " ")
prev_words



next_word  <- list("world", "story", "life", "street")

dfm_r1[dfm_r1$V1 %in% next_word,]
dfm_r2[dfm_r2$V1 %in% prev_words[3] & dfm_r2$V2 %in% next_word,]
dfm_r3[dfm_r3$V1 %in% prev_words[2] & dfm_r3$V2 %in% prev_words[3] & dfm_r3$V3 %in% next_word,]
dfm_r4[dfm_r4$V1 %in% prev_words[1] & dfm_r4$V2 %in% prev_words[2] & dfm_r4$V3 %in% prev_words[3] & dfm_r4$V4 %in% next_word,]
