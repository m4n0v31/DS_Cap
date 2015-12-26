# Clean data set
library(tm)
sources <- DirSource(directory = "final/en_US/",
                     encoding = "UTF-8",
                     pattern = ".txt",
                     mode = "text")

corpora <- Corpus(sources, readerControl = list(reader = readPlain, 
                                                language = "en_US"))

# http://stat.ethz.ch/R-manual/R-patched/library/base/html/regex.html
# remove non ASCII characters
corpora <- tm_map(corpora , function(x) gsub("[^[:graph:]]", " ", x, perl = TRUE))
# convert to lowercase
corpora <- tm_map(corpora , tolower)
# remove special combinations
corpora <- tm_map(corpora , function(x) gsub("[\u2018\u2019\u201A\u201B\u2032\u2035\u0092\u009d\u0096\u0093\u0094\u0099\u0091]","'",x, perl = TRUE))
corpora <- tm_map(corpora , function(x) gsub("[\031]","'",x, perl = TRUE))
corpora <- tm_map(corpora , function(x) gsub("[\u008B\u201C\u201D\u201E\u201F\u2033\u2036\u0097\u0083\u0082\u0080\u0081\u0090\u0095\u009f\u0098\u009b\u009c\u008d\u008b\u0089\u0087\u008a]"," ",x, perl = TRUE))
corpora <- tm_map(corpora , function(x) gsub("((mr)|(mr?s))\\.","\\1 ", x, perl = TRUE))
# remove URLs
corpora <- tm_map(corpora , function(x) gsub("[^[:space:]]*://[^[:space:]]*", " ", x, perl = TRUE))
# remove emails
corpora <- tm_map(corpora , function(x) gsub("[A-Z0-9\\._%\\+-]+@[A-Z0-9\\.-]+\\.[A-Z]{2,}", " ", x, perl = TRUE))
# convert @ to at
corpora <- tm_map(corpora , function(x) gsub("[[:space:]]@[[:space:]]", " at ", x, perl = TRUE))
# convert `´ to '
corpora <- tm_map(corpora , function(x) gsub("`´", "'", x, perl = TRUE))
# convert sentence enclosing punctuation to .
corpora <- tm_map(corpora , function(x) gsub("[!\\(\\):;\\?\\[\\]\\{\\}]", ".", x, perl = TRUE))
# remove extra characters
corpora <- tm_map(corpora , function(x) gsub("[\"#\\$%&\\*\\+,\\-/<=>@\\\\\\^_`\\|~]", " ", x, perl = TRUE))
# remove double words
corpora <- tm_map(corpora , function(x) gsub("\\b(\\w+)(\\s+\\1)+\\b", "\\1" , x, perl = TRUE))
# remove multiple .
corpora <- tm_map(corpora , function(x) gsub("(\\s*\\.\\s*)+", ".", x, perl = TRUE))
# remove multiple '
corpora <- tm_map(corpora , function(x) gsub("[']+", "'", x, perl = TRUE))
# remove string mixed with numbers
corpora <- tm_map(corpora , function(x) gsub("[[:alpha:]]*[[:digit:]]+[[:alpha:]]*", " ", x, perl = TRUE))
# remove extra spaces
corpora <- tm_map(corpora , function(x) gsub("[[:blank:]]+", " ", x, perl = TRUE))
# correct *n t to *n't
corpora <- tm_map(corpora , function(x) gsub("n[[:blank:]]+t[[:blank:]]+", "n't ", x, perl = TRUE))
corpora <- tm_map(corpora , function(x) gsub("i[[:blank:]]+m[[:blank:]]+", "i'm ", x, perl = TRUE))
# divide sentences
corpora[[1]] <- unlist(strsplit(corpora[[1]], "\\."))
corpora[[2]] <- unlist(strsplit(corpora[[2]], "\\."))
corpora[[3]] <- unlist(strsplit(corpora[[3]], "\\."))
# trim
corpora <- tm_map(corpora , function(x) gsub("^[[:blank:]]+", "", x, perl = TRUE))
corpora <- tm_map(corpora , function(x) gsub("[[:blank:]]+$", "", x, perl = TRUE))
# remove empty or too short lines
corpora[[1]] <- corpora[[1]][nchar(corpora[[1]])>2]
corpora[[2]] <- corpora[[2]][nchar(corpora[[2]])>2]
corpora[[3]] <- corpora[[3]][nchar(corpora[[3]])>2]

# remove profanity -> not implemented, profanity will be removed in the prediction!

# divide in sentences and write clean files
if(!dir.exists("data")){
    dir.create("data")
}
writeLines(corpora[[1]], "data/blogs.clean.txt")
writeLines(corpora[[2]], "data/news.clean.txt")
writeLines(corpora[[3]], "data/twitter.clean.txt")

# create subsets
idx_train <- as.logical(rbinom(n=length(corpora[[1]]), size=1, prob=0.2))
writeLines(corpora[[1]][idx_train], "data/blogs.clean.train.txt")
idx_validation <- as.logical(rbinom(n=sum(!idx_train), size=1, prob=0.6))
writeLines(corpora[[1]][!idx_train][idx_validation], "data/blogs.clean.validation.txt")
writeLines(corpora[[1]][!idx_train][!idx_validation], "data/blogs.clean.test.txt")

idx_train <- as.logical(rbinom(n=length(corpora[[2]]), size=1, prob=0.2))
writeLines(corpora[[2]][idx_train], "data/news.clean.train.txt")
idx_validation <- as.logical(rbinom(n=sum(!idx_train), size=1, prob=0.6))
writeLines(corpora[[2]][!idx_train][idx_validation], "data/news.clean.validation.txt")
writeLines(corpora[[2]][!idx_train][!idx_validation], "data/news.clean.test.txt")

idx_train <- as.logical(rbinom(n=length(corpora[[3]]), size=1, prob=0.2))
writeLines(corpora[[3]][idx_train], "data/twitter.clean.train.txt")
idx_validation <- as.logical(rbinom(n=sum(!idx_train), size=1, prob=0.6))
writeLines(corpora[[3]][!idx_train][idx_validation], "data/twitter.clean.validation.txt")
writeLines(corpora[[3]][!idx_train][!idx_validation], "data/twitter.clean.test.txt")