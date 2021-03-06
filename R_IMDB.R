#----import----
library(MASS)
library(AER)
library(readr)
#dataset
movie_metadata <- read.csv("movie_metadata.csv")
movie_metadata1 <- read.csv("movie_metadata1.csv")
movie_metadata11 <- read.csv("movie_metadata11.csv")

#只考慮類別變數建立模型
attach(movie_metadata)
ml=lm(gross~language+country+genres+as.factor(content_rating))#???l
boxcox(ml)
qqnorm(gross^0.25)
hist(gross^0.25)
fit1=lm(gross^0.25~language+country+genres+as.factor(content_rating))
summary(fit1)
vif(fit1)
residualPlot(fit1)


#加入FB讚數#3000筆資料
attach(movie_metadata1)
ml=lm(gross~language+country+genres+as.factor(content_rating)+director_likes+actor1_likes+actor2_likes+actor3_likes+allcast_likes+budget)#???l
boxcox(ml)
qqnorm(gross^0.25)
hist(gross^0.25)
fit1=lm(gross^0.25~language+country+genres+as.factor(content_rating)+director_likes+actor1_likes+actor2_likes+actor3_likes+allcast_likes+budget)#^0.25
summary(fit1)
vif(fit1)

fit2=lm(gross^0.25~language+country+genres+as.factor(content_rating)+director_likes+actor3_likes+allcast_likes+budget)#
summary(fit2)
vif(fit2)

#建立新變數
actor1_ratio=actor1_likes/allcast_likes
actor2_ratio=actor2_likes/allcast_likes
actor3_ratio=actor3_likes/allcast_likes
director_ratio=director_likes/(director_likes+allcast_likes)
allactor_ratio1=actor1_likes/(actor1_likes+actor2_likes+actor3_likes)
allactor_ratio2=actor2_likes/(actor1_likes+actor2_likes+actor3_likes)
allactor_ratio3=actor3_likes/(actor1_likes+actor2_likes+actor3_likes)


fit3=lm(gross^0.25~language+country+genres+as.factor(content_rating)+director_likes+allcast_likes+actor1_ratio+budget)#final model
summary(fit3)
vif(fit3)
rstudent(fit3)
plot(rstudent(fit3))




#刪去outlier,R-square from 0.2702->0.4322
attach(movie_metadata11)
fit4=lm(gross^0.25~language+country+genres+as.factor(content_rating)+director_likes+allcast_likes+actor1_ratio+budget)#final model
summary(fit4)
vif(fit4)

plot(rstudent(fit4))
qqnorm(gross^0.25)
hist(gross^0.25)

#prediction
#install.packages("ROCR")
library(ROCR)
pred=predict(lm(fit4),movie_metadata11,interval = "prediction")
console=pred^4
plot(console-gross)
#console預測結果


