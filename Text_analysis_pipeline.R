###
#Text analysis pipeline
###


#Ultimately wrap this whole pipeline into function...


# Packages ----------------------------------------------------------------


require(rjson)
#require(RJSONIO)
require(NLP)
require(tm)
require(topicmodels)
require(SnowballC)
require(LDAvis)




# Load Data ---------------------------------------------------------------



json_file <- fromJSON(file='clean_data.json') 
json_file <- lapply(json_file,function(x){
  x[sapply(x,is.null)]<-NA
  unlist(x)
})


df <- as.data.frame(do.call('rbind',json_file))
df<-na.omit(df)




# Clean text for topic modeling and create TFIDF matrix -------------------


content <- df$content
content <- VCorpus(VectorSource(content))
#Currently runs on 2 cores, specificy mc.cores param to adjust
content <- tm_map(content,
                   content_transformer(function(x) iconv(x, to='UTF-8', sub='byte')),
                   mc.cores=2)


content.clean <- tm_map(content, stripWhitespace)                       #strip whitespace
content.clean <- tm_map(content.clean,removeNumbers)                    #remove numbers
content.clean <- tm_map(content.clean,removePunctuation)                #remove punctuation
content.clean <- tm_map(content.clean,content_transformer(tolower))     #convert to lower case
content.clean <- tm_map(content.clean,removeWords,stopwords("english")) #removestop words
conent.clean <- tm_map(content.clean,stemDocument)                      #stem words

#create tfidf (?) matrix
tfidf <- DocumentTermMatrix(content.clean,control = list(weighting = weightTf))

#removing empty rows from tfidf (i.e. empty docs)
rowsums <- apply(tfidf,1,sum)
tfidf <- tfidf[rowsums > 0 ]



# Topic Modeling ----------------------------------------------------------








# Explore TM results ------------------------------------------------------














