str(data)

cdata<- data %>%
  mutate(total_volume=length_inches*width_inches*height_inches)%>%
  mutate(torque_n=substr(torque, 1, 3))

#make categorical to numerical
cdata$is_new <- as.integer(as.logical(cdata$is_new))
cdata$make_name <- as.numeric(as.factor(cdata$make_name))
cdata$listing_color <- as.numeric(as.factor(cdata$listing_color))
cdata$torque_n <- as.integer(cdata$torque_n)

#replace NAs with median
cdata$owner_count[is.na(cdata$owner_count)] <- median(cdata$owner_count, na.rm = TRUE)
cdata$mileage[is.na(cdata$mileage)] <- median(cdata$mileage, na.rm = TRUE)
cdata$engine_displacement[is.na(cdata$engine_displacement)] <- median(cdata$engine_displacement, na.rm = TRUE)
cdata$highway_fuel_economy[is.na(cdata$highway_fuel_economy)] <- median(cdata$highway_fuel_economy, na.rm = TRUE)
cdata$horsepower[is.na(cdata$horsepower)] <- median(cdata$horsepower, na.rm = TRUE)
cdata$fuel_tank_volume_gallons[is.na(cdata$fuel_tank_volume_gallons)] <- median(cdata$fuel_tank_volume_gallons, na.rm = TRUE)
cdata$seller_rating[is.na(cdata$seller_rating)] <- median(cdata$seller_rating, na.rm = TRUE)
cdata$city_fuel_economy[is.na(cdata$city_fuel_economy)] <- median(cdata$city_fuel_economy, na.rm = TRUE)
cdata$torque_n[is.na(cdata$torque_n)] <- median(cdata$torque_n, na.rm = TRUE)

carr<- cdata%>%
  select_if(~is.numeric(.))%>%
  subset(select=-c(length_inches,width_inches,height_inches))

set.seed(1031)
split = createDataPartition(y=carr$price,p = 0.8,list = F,groups = 100)
train = carr[split,]
test = carr[-split,]

subsets = regsubsets(price~.,data=train, nvmax=21)
summary(subsets)

subsets_measures = data.frame(model=1:length(summary(subsets)$cp),
                              cp=summary(subsets)$cp,
                              bic=summary(subsets)$bic, 
                              adjr2=summary(subsets)$adjr2)
subsets_measures
#based on CP - 21 variables
#based on BIC - 17 variables
#based on adjr2 - 20 variables

start_mod = lm(price~.,data=train)
empty_mod = lm(price~1,data=train)
full_mod = lm(price~.,data=train)
backwardStepwise = step(start_mod,
                        scope=list(upper=full_mod,lower=empty_mod),
                        direction='backward')

str(cdata)

#xgboost
features = c('year','horsepower','mileage','owner_count','listing_color','maximum_seating','make_name','is_new','wheelbase_inches','back_legroom_inches','front_legroom_inches','engine_displacement','total_volume','daysonmarket','seller_rating','torque_n','fuel_tank_volume_gallons','highway_fuel_economy')
target = 'price'

xgtrain = xgb.DMatrix(data = as.matrix(train[, features]),
                      label = train[, target])
xgtest = xgb.DMatrix(data = as.matrix(test[, features]),
                     label = test[, target])

model = xgboost(data=xgtrain, nrounds=2000, verbose = 1)

str(carr)

scoringData = read.csv('scoringData.csv')

scoringData1<- scoringData %>%
  mutate(total_volume=length_inches*width_inches*height_inches)%>%
  mutate(torque_n=substr(torque, 1, 3))

#make categorical to numerical
scoringData1$is_new <- as.integer(as.logical(scoringData1$is_new))
scoringData1$make_name <- as.numeric(as.factor(scoringData1$make_name))
scoringData1$listing_color <- as.numeric(as.factor(scoringData1$listing_color))
scoringData1$torque_n <- as.integer(scoringData1$torque_n)

#replace NAs with median
scoringData1$owner_count[is.na(scoringData$owner_count)] <- median(scoringData1$owner_count, na.rm = TRUE)
scoringData1$city_fuel_economy[is.na(scoringData$city_fuel_economy)] <- median(scoringData1$city_fuel_economy, na.rm = TRUE)
scoringData1$mileage[is.na(scoringData$mileage)] <- median(scoringData1$mileage, na.rm = TRUE)
scoringData1$engine_displacement[is.na(scoringData$engine_displacement)] <- median(scoringData1$engine_displacement, na.rm = TRUE)
scoringData1$highway_fuel_economy[is.na(scoringData$highway_fuel_economy)] <- median(scoringData1$highway_fuel_economy, na.rm = TRUE)
scoringData1$horsepower[is.na(scoringData$horsepower)] <- median(scoringData1$horsepower, na.rm = TRUE)
scoringData1$seller_rating[is.na(scoringData$seller_rating)] <- median(scoringData1$seller_rating, na.rm = TRUE)
scoringData1$fuel_tank_volume_gallons[is.na(scoringData$fuel_tank_volume_gallons)] <- median(scoringData1$fuel_tank_volume_gallons, na.rm = TRUE)
scoringData1$torque_n[is.na(scoringData1$torque_n)] <- median(scoringData1$torque_n, na.rm = TRUE)

scoringData2<- scoringData1%>%
  select_if(~is.numeric(.))%>%
  subset(select=-c(length_inches,width_inches,height_inches))

pred = predict(model, newdata = as.matrix(scoringData2[, features]))
submissionFile = data.frame(id = scoringData$id, price = pred)
write.csv(submissionFile, 'sample_submission6666.csv',row.names = F)


     