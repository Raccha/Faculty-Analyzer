# import the library 
library(tidyverse)
library(DT)
library(shiny)
library(writexl)
library(dplyr)
library(text2vec)
library(readr)
library(stringr)
library(stopwords)
library(textstem)
library(tm)
library(NLP)
library(quanteda)
library(corpus)
library(tibble)
library(proto)
library(gsubfn)
library(tidytext)

scoreResult = function(input1,input2){
  #first input file
  cobine <- read.csv(input1,stringsAsFactors = F) 
  colnames(cobine)<- c("course", "description")
  
  #second input file
  resume_t <- read_file(input2)
  
  # make resume content a dataframe
  resume_tmt <- tibble(course = "Total", description=resume_t)
  
  # combine resume and job description
  combine_resume <- rbind(resume_tmt,cobine)
  
  # data cleaning function 
  prep_fun = function(x) {
    # make text lower case
    x = str_to_lower(x)
    # remove non-alphanumeric symbols
    x = str_replace_all(x, "[^[:alnum:]]", " ")
    # remove numbers
    x = gsub("\\d", " ", x)
    # remove stopwords
    x = removeWords(x, stopwords())
    # remove single character
    x = gsub("\\b[A-z]\\b{1}", " ", x)
    # collapse multiple spaces
    x= gsub("\\s+", " ", x)
    # lemmatization 
    x = lemmatize_strings(x)}
  
  # clean the course description data and create a new column
  combine_resume$description_clean = lemmatize_words(prep_fun(combine_resume$description))
  
  # use vocabulary_based vectorization
  ca_resume = itoken(combine_resume$description_clean, progressbar = FALSE)
  bac_resume = create_vocabulary(ca_resume)
  
  # eliminate very frequent and very infrequent terms
  bac_resume = prune_vocabulary(bac_resume)
  vectorizer_resume = vocab_vectorizer(bac_resume)
  
  # apply TF-IDF transformation
  dtm_resume = create_dtm(ca_resume, vectorizer_resume)
  racc = TfIdf$new()
  dtm_tfidf_resume = fit_transform(dtm_resume, racc)
  
  # compute similarity-score against each row
  resume_tfidf_cos_sim = sim2(x = dtm_tfidf_resume, method = "cosine", norm = "l2")
  resume_tfidf_cos_sim[1:15,1:15]
  
  # create a new column for similarity_score of dataframe
  combine_resume["similarity_score"] = resume_tfidf_cos_sim[1:nrow(resume_tfidf_cos_sim)]
  
  # create a new column for percentage numerical score of dataframe
  # Create user-defined function:percent
  percent <- function(x, digits = 1, format = "f", ...) {
    paste0(formatC(x * 100, format = format, digits = digits, ...), "%")
  }
  combine_resume$percent <- percent(ecdf(combine_resume$similarity_score)(combine_resume$similarity_score))
  
  
  # sort the dataframe by similarity score from the highest to the lowest
  combine_resume_result<- combine_resume[order(-combine_resume$similarity_score),c(1,4,5)]
  
  #delete the first line
  combine_resume_result2<- combine_resume_result[-c(1), ]
  
  #change header
  combine_resume_result3<-rbind(c( "Title","Similiarity Score","Percent"), combine_resume_result2)
  
  #add date row
  combine_resume_result4<-rbind(c("Date:",format(Sys.time(), "%Y-%m-%d"),""), combine_resume_result3)
  
  
  return(combine_resume_result4)
  
}

#########Shiny Server##########

shinyServer(function(input ,output, session) {
  restab <- eventReactive(input$go,{
    
    req(input$upload_resume)
    req(input$upload_cd)
    
    scoreResult(input$upload_cd$datapath,input$upload_resume$datapath)
  })
  
  output$combine_resume_result4 <- renderTable({
    restab()
  })
})
  
