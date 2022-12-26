#Individual Project 2

#Insert Libraries
library("twitteR") 
library(dplyr)
library(tidyr)
library("plotly")
library(ggplot2)
library(RColorBrewer)
library(tidytext)
library(rtweet)
library(tm)
library(slam)
library(wordcloud)
library(wordcloud2)
library(corpus)


#Extract from twitter using your developer's credentials. 
#Choose any keyword you want.

#Set-up credentials
CONSUMER_SECRET <-"cPjVH3WbIzgg5TnV8co99GRjSrmAPH9xHGLvvH5HTtprJQaitO"
CONSUMER_KEY <-"anRJmejG8LPugdGrtqe8naWQk"
ACCESS_SECRET <- "A4vhfNX6RX5AhAZQrI3gpasRBGw2VHbmAm5XMdm0YrNov" 
ACCESS_TOKEN <- "1596107281610858498-sSmW933erENXHM1POaXUjSLhVQ0yAH" 

#connect to twitter app
setup_twitter_oauth(consumer_key = CONSUMER_KEY,
                    consumer_secret = CONSUMER_SECRET,
                    access_token = ACCESS_TOKEN,
                    access_secret = ACCESS_SECRET)
#Getting a data
#it would take few minutes to load which depend the number of data you need
#but when you already save this data as a file you can skip this part.
trendTweets2 <- searchTwitter("#music -filter:retweets",
                             n = 10000,
                             lang = "en",
                             since = "2022-12-16",
                             until = "2022-12-25",
                             retryOnRateLimit=120)

trendTweets2

# CONVERTING LIST DATA TO DATA FRAME.
trendtweetsDF <- twListToDF(trendTweets2)

# SAVE DATA FRAME FILE.
save(trendtweetsDF,file = "trendtweetsDF.Rdata")

# LOAD DATA FRAME FILE.
load(file = "trendtweetsDF.Rdata")

# CHECKING FOR MISSING VALUES IN A DATA FRAME.
sap_data <- sapply(trendtweetsDF, function(x) sum(is.na(x)))
sap_data

#Tweets
# SUBSETTING USING THE dplyr() PACKAGE.
tweets <- trendtweetsDF %>%
  select(screenName,text,created, isRetweet) %>% filter(isRetweet == FALSE)
tweets

# GROUPING THE DATA CREATED. 
tweets %>%  
  group_by(1) %>%  
  summarise(max = max(created), min = min(created))

crt_data <- tweets %>%  mutate(Created_At_Round = created %>% round(units = 'hours') %>% as.POSIXct())
crt_data

mn <- tweets %>% pull(created) %>% min()
mn 
mx <- tweets %>% pull(created) %>% max()
mx

# Plot on tweets by time using the library(plotly) and ggplot().
plt_data <- ggplot(crt_data, aes(x = Created_At_Round)) +
  geom_histogram(aes(fill = ..count..)) +
  theme(legend.position = "right") +
  xlab("Time") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4")

plt_data %>% ggplotly()


#Retweets

sub_tweets <- trendtweetsDF %>%
  select(screenName,text,created, isRetweet) %>% filter(isRetweet == TRUE)
sub_tweets


sub_tweets %>%  
  group_by(1) %>%  
  summarise(max = max(created), min = min(created))

crt2 <- sub_tweets %>%  mutate(Created_At_Round = created %>% round(units = 'hours') %>% as.POSIXct())
crt2

mn <- sub_tweets %>% pull(created) %>% min()
mn 
mx <- sub_tweets %>% pull(created) %>% max()
mx

# Plot on tweets by time using the library(plotly) and ggplot().
plt_data <- ggplot(crt2, aes(x = Created_At_Round)) +
  geom_histogram(aes(fill = ..count..)) +
  theme(legend.position = "right") +
  xlab("Time") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4")

plt_data %>% ggplotly()
