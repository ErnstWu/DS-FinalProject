library(knitr)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(gridExtra)
library(scales)

setwd("U:/Documents/Courses/107/final project/Original Dataset")
dat <- read_csv("train_users_2.csv")
dat <- rename(dat, countries=country_destination)

countries <- c("AU - Australia", "CA - Canada", "DE - Germany","ES - Spain","FR - France","GB - United Kingdom","IT - Italy","NDF - no destination found","NL - Netherlands","other","PT - Portugal","US - United States") 
bookings <- c(539,1428,1061,2249,5023,2324,2835,124543,762,10094,217,62376) 
percentage <- c(0.25, 0.67, 0.50,1.05,2.35,1.09,1.33,58.35,0.36,4.73,0.10,29.22)  

distn.y <- bind_rows(data_frame(Countries=countries,  
                                "Number of Bookings" = bookings,
                                "Percentage of Bookings" = percentage))
distn.y <- distn.y %>% arrange(bookings)

ggplot(dat, aes(countries, fill=countries)) + geom_bar()


ggplot(dat, aes(country_destination, fill=gender)) + geom_bar(aes(position="fill")) +scale_y_log10()
ggplot(dat, aes(country_destination, fill=signup_method)) + geom_bar(aes(position="fill")) +scale_y_log10()
ggplot(dat, aes(country_destination, fill=signup_flow)) + geom_bar(aes(position="fill")) +scale_y_log10()
ggplot(dat, aes(country_destination, fill=language)) + geom_bar(aes(position="fill")) 
ggplot(dat, aes(country_destination, fill=affiliate_channel)) + geom_bar(aes(position="fill")) +scale_y_log10()
ggplot(dat, aes(country_destination, fill=affiliate_provider)) + geom_bar(aes(position="fill")) +scale_y_log10()
ggplot(dat, aes(country_destination, fill=first_affiliate_tracked)) + geom_bar(aes(position="fill")) +scale_y_log10()
ggplot(dat, aes(country_destination, fill=signup_app)) + geom_bar(aes(position="fill")) +scale_y_log10()
ggplot(dat, aes(country_destination, fill=first_device_type)) + geom_bar(aes(position="fill")) +scale_y_log10()

ggplot(dat, aes(first_device_type, fill=country_destination )) + geom_bar(aes(position="fill")) +scale_y_log10()

ggplot(dat, aes(first_device_type , fill=country_destination)) + 
  geom_bar(aes(y = (..count..)/sum(..count..), position="fill")) + scale_y_continuous(labels = percent)

############################################################################################################################

#difference between sub-categories among destinations
gender.eda <- ggplot(dat, aes(gender, fill=countries)) 
gender.g1 <- gender.eda + geom_bar(aes(position="stack")) +
  ylab("destination distribution in counts") +
  ggtitle("Difference between gender's sub-categories among destinations")

#difference within sub-categories among destinations
gender.g2 <- gender.eda + geom_bar(position="fill") +
  ylab("destination distribution in percentage") +
  ggtitle("Difference within gender's sub-categories among destinations")

#put var plots together
grid.arrange(gender.g1, gender.g2, nrow=1)

#further investigation on gender and destinations
gender.g3 <- dat %>%
  filter(gender %in% c("FEMALE", "MALE") & countries %in% c("AU","CA", "DE", "ES", "FR", "GB", "IT", "NL", "PT")) %>%
  ggplot(., aes(countries, fill=gender)) 
gender.g3 + geom_bar(position="dodge")
############################################################################################################################


#difference between sub-categories among destinations
language.eda <- ggplot(dat, aes(language, fill=countries)) 
language.eda + geom_bar(aes(position="stack")) + 
  scale_y_log10() +
  ylab("destination distribution in log counts") +
  ggtitle("Difference between language's sub-categories among destinations")
############################################################################################################################

#difference between sub-categories among destinations
method.eda <- ggplot(dat, aes(signup_method, fill=countries)) 
method.g1 <- method.eda + geom_bar(aes(position="stack")) + 
  ylab("destination distribution in counts") +
  ggtitle("Difference between sign-up method's sub-categories among destinations")

#difference within sub-categories among destinations
method.g2 <- method.eda + geom_bar(position="fill") +
  ylab("destination distribution in percentage") +
  ggtitle("Difference within sign-up method's sub-categories among destinations")

#put var plots together
grid.arrange(method.g1, method.g2, nrow=1)
############################################################################################################################

#difference between sub-categories among destinations
flow.eda <- ggplot(dat, aes(signup_flow, fill=countries)) 
flow.eda + geom_bar(aes(position="stack")) + 
  scale_y_log10() +
  ylab("destination distribution in counts") +
  ggtitle("Difference between sign-up flow's sub-categories among destinations")
############################################################################################################################

#difference between sub-categories among destinations
app.eda <- ggplot(dat, aes(signup_app, fill=countries)) 
app.g1 <- app.eda + geom_bar(aes(position="stack")) + 
  ylab("destination distribution in counts") +
  ggtitle("Difference between sign-up app's sub-categories among destinations")

#difference within sub-categories among destinations
app.g2 <- app.eda + geom_bar(position="fill") +
  ylab("destination distribution in percentage") +
  ggtitle("Difference within sign-up app's sub-categories among destinations")

#put var plots together
grid.arrange(app.g1, app.g2, nrow=1)
############################################################################################################################

#difference between sub-categories among destinations
device.eda <- ggplot(dat, aes(first_device_type, fill=countries)) 
device.g1 <- device.eda + geom_bar(aes(position="stack")) + 
  ylab("destination distribution in counts") +
  ggtitle("Difference between first device type's sub-categories among destinations")

#difference within sub-categories among destinations
device.g2 <- device.eda + geom_bar(position="fill") +
  ylab("destination distribution in percentage") +
  ggtitle("Difference within first device type's sub-categories among destinations")

#put var plots together
grid.arrange(device.g1, device.g2)
############################################################################################################################

#difference between sub-categories among destinations
browser.eda <- ggplot(dat, aes(first_browser, fill=countries)) 
browser.eda + geom_bar(aes(position="stack")) + 
  scale_y_log10() +
  ylab("destination distribution in counts") +
  ggtitle("Difference between first web browser's sub-categories among destinations")
############################################################################################################################

#difference between sub-categories among destinations
channel.eda <- ggplot(dat, aes(affiliate_channel, fill=countries)) 
channel.eda + geom_bar(aes(position="stack")) + 
  scale_y_log10() +
  ylab("destination distribution in counts") +
  ggtitle("Difference between affiliate channel's sub-categories among destinations")
############################################################################################################################

#difference between sub-categories among destinations
provider.eda <- ggplot(dat, aes(affiliate_provider, fill=countries)) 
provider.eda + geom_bar(aes(position="stack")) + 
  scale_y_log10() +
  ylab("destination distribution in counts") +
  ggtitle("Difference between affiliate provider's sub-categories among destinations")
############################################################################################################################

#difference between sub-categories among destinations
tracked.eda <- ggplot(dat, aes(first_affiliate_tracked, fill=countries)) 
tracked.eda + geom_bar(aes(position="stack")) + 
  scale_y_log10() +
  ylab("destination distribution in counts") +
  ggtitle("Difference between first affiliate tracked sub-categories among destinations")
############################################################################################################################

#clean out the memory
gc()

library(knitr)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(gridExtra)
library(scales)

setwd("U:/Documents/Courses/107/final project/")
dat <- read_csv("ModelDst.csv")
dat <- rename(dat, countries=country_destination)

#age
#without missing values
age.eda <- dat %>% 
  filter(age != "-99") %>%
  ggplot(., aes(age, fill=countries))
age.g1 <- age.eda + geom_bar(aes(position="stack"))+ 
  ylab("destination distribution in counts") +
  ggtitle("Difference between ages among destinations")
age.g2 <- age.eda + geom_bar(position="fill") +
  ylab("destination distribution in percentage") +
  ggtitle("Difference within ages among destinations")

#put var plots together
grid.arrange(age.g1, age.g2)


#First booking since user created file on AirBnB 
#without missing values
Acct.eda <- dat %>% 
  filter(Mth_AcctCtnsBooking != "-99") %>%
  ggplot(., aes(Mth_AcctCtnsBooking, fill=countries))
Acct.g1 <- Acct.eda + geom_bar(aes(position="stack"))+ 
  ylab("destination distribution in counts") +
  ggtitle("Difference between months among destinations")
Acct.g2 <- Acct.eda + geom_bar(position="fill") +
  ylab("destination distribution in percentage") +
  ggtitle("Difference within months among destinations")

#put var plots together
grid.arrange(Acct.g1, Acct.g2)


#First booking since user created file on AirBnB 
#without missing values
Active.eda <- dat %>% 
  filter(Mth_BookingsinceActive != "-99") %>%
  ggplot(., aes(Mth_BookingsinceActive, fill=countries))
Active.g1 <- Active.eda + geom_bar(aes(position="stack"))+ 
  ylab("destination distribution in counts") +
  ggtitle("Difference between months among destinations")
Active.g2 <- Active.eda + geom_bar(position="fill") +
  ylab("destination distribution in percentage") +
  ggtitle("Difference within months among destinations")

#put var plots together
grid.arrange(Active.g1, Active.g2)

############################################################################################################################

dat$Mth_AcctCtnsBooking <- NULL
dat$countries <- NULL

#partitioned the dataset
set.seed(755)
n_test <- round(nrow(dat) * 0.4)
test_indices <- sample(1:nrow(dat), n_test, replace=FALSE)
test <- dat[test_indices,]
train <- dat[-test_indices,]
rm(dat) #to save space 

library(xgboost)

n_train <- round(nrow(train) / 5)
train_indices <- sample(1:nrow(train), n_train, replace=FALSE)
dtrain <- train[train_indices,]

dtrain$Mth_BookingsinceActive <- NULL

label <- as.numeric(dtrain[[56]])
data <- as.matrix(sapply(dtrain[2:55], as.numeric))

#cross validation
cv.res <- xgb.cv(data = data, nfold = 3, label = label,  
                 objective = "multi:softmax", num_class = 12,
                 eval_metric = "merror",
                 nrounds = 1000, nthread =8, 
                 eta = 0.05, gamma = 1,  
                 max_depth = 4, min_child_weight = 1, max_delta_step = 1, verbose = T, 
                 subsample = 0.8, colsample_bytree = 0.8)

xgb.func <- xgboost(data = data, label = label, objective = "multi:softmax", num_class = 12,
                    eval_metric = "merror",
                    nrounds = 200, nthread =8, 
                    eta = 0.05, gamma = 1,  
                    max_depth = 4, min_child_weight = 1, max_delta_step = 1, verbose = F, 
                    subsample = 0.8, colsample_bytree = 0.8)


#variable's importance 
importance_matrix<-xgb.importance(dimnames(data)[[2]], model = xgb.func)
xgb.plot.importance(importance_matrix)

dtest <- as.matrix(sapply(test[2:55], as.numeric))
pred <- predict(xgb.func, dtest)
testlabel <- as.numeric(test[[57]])
sumit <-data.frame(true_target = testlabel,predicted = pred)
n_correct <- sumit %>% 
  mutate(error=true_target-predicted) %>%
  filter(error=="0") %>%
  summarise(n())

#error 
(nrow(test) - n_correct) / nrow(test)
error.rate <- 0.3808035
xgb_results <- data_frame(method="XGBoost",  ErrorRate = error.rate )
xgb_results %>% kable

