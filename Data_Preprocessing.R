library(readxl)
library(openxlsx)
library(stringr)

data<- read_excel("Ristorazione.xls",sheet=2)
View(data)

#Rimuovo colonne superflue relative alla seconda data
data[2:4] <- list(NULL)

#cambio il nome della colonna relativa alle date
colnames(data)[1] <- "date"

#Estraggo l'informazione relativa al giorno della settimana e del mese:
data$weekday <- word(data$date, 1)
data$month <- word(data$date, 3)

#Elimino informazione relativa al giorno della settimana nella colonna "date"
data$date<-gsub("Do","",as.character(data$date))
data$date<-gsub("Lu","",as.character(data$date))
data$date<-gsub("Ma","",as.character(data$date))
data$date<-gsub("Me","",as.character(data$date))
data$date<-gsub("Gi","",as.character(data$date))
data$date<-gsub("Ve","",as.character(data$date))
data$date<-gsub("Sa","",as.character(data$date))

#Trasformo la formattazione delle date
data$date <- lapply(data$date, function(x){
  str_replace(x,"gen","01")
  
})

data$date <- lapply(data$date, function(x){
  str_replace(x,"feb","02")
  
})

data$date <- lapply(data$date, function(x){
  str_replace(x,"mar","03")
  
})

data$date <- lapply(data$date, function(x){
  str_replace(x,"apr","04")
  
})

data$date <- lapply(data$date, function(x){
  str_replace(x,"mag","05")
  
})

data$date <- lapply(data$date, function(x){
  str_replace(x,"giu","06")
  
})

data$date <- lapply(data$date, function(x){
  str_replace(x,"lug","07")
  
})

data$date <- lapply(data$date, function(x){
  str_replace(x,"ago","08")
  
})

data$date <- lapply(data$date, function(x){
  str_replace(x,"set","09")
  
})

data$date <- lapply(data$date, function(x){
  str_replace(x,"ott","10")
  
})

data$date <- lapply(data$date, function(x){
  str_replace(x,"nov","11")
  
})

data$date <- lapply(data$date, function(x){
  str_replace(x,"dic","12")
  
})


#Trasformo in formato date
data$date <- as.Date.character(data$date, format="%d %m %Y")


###WEEKEND
#Creo una nuova colonna booleana che consideri se il giorno sia un weekend o meno
weekend <- c('Do', 'Sa')

data$is_weekend <- FALSE

data$is_weekend[which(data$weekday %in% weekend)] <- TRUE

###FESTIVITA'
holidays <- as.Date(c('2017-01-01','2018-01-01','2019-01-01','2020-01-01','2021-01-01', #1 gennaio
                      '2017-01-06','2018-01-06','2019-01-06','2020-01-06','2021-01-06', #epifania
                      '2017-02-14','2018-02-14','2019-02-14','2020-02-14','2021-02-14', #san valentino
                      '2017-04-09','2018-03-25','2019-04-14','2020-04-05','2021-03-28',  #domenica palme
                      '2017-04-16','2017-04-17','2018-04-01','2018-04-02','2019-04-21','2019-04-22', '2020-04-12','2020-04-13','2021-04-04','2021-04-05', #pasqua e pasquetta
                      '2017-04-25','2018-04-25','2019-04-25','2020-04-25', #25 aprile
                      '2017-05-01','2018-05-01','2019-05-01','2020-05-01', #primo maggio
                      '2017-06-02','2018-06-02','2019-06-02','2020-06-02', #2 giugno
                      '2017-08-15','2018-08-15','2019-08-15','2020-08-15', #ferragosto
                      '2017-11-01','2018-11-01','2019-11-01','2020-11-01', #1 novembre
                      '2017-12-08','2018-12-08','2019-12-08','2020-12-08', #8 dicembre
                      '2017-12-24','2018-12-24','2019-12-24','2020-12-24', #vigilia
                      '2017-12-25','2018-12-25','2019-12-25','2020-12-25', #natale
                      '2017-12-26','2018-12-26','2019-12-26','2020-12-26', #26 dicembre
                      '2017-12-31','2018-12-31','2019-12-31','2020-12-31' #capodanno
))

data$is_holiday <- FALSE

data$is_holiday[which(data$date %in% holidays)] <- TRUE


#Trasformo le variabili categoriche
data$is_weekend<-as.factor(data$is_weekend)
data$is_holiday<-as.factor(data$is_holiday)
data$season<-as.factor(data$season)

#Creo una nuova colonna: scontrino medio
data$scontr_medio1<-data$Vendite_1/data$Scontrini_1
data$scontr_medio2<-data$Vendite_2/data$Scontrini_2
data$scontr_medio3<-data$Vendite_3/data$Scontrini_3
data$scontr_medio4<-data$Vendite_4/data$Scontrini_4
data$scontr_medio5<-data$Vendite_5/data$Scontrini_5
data$scontr_medio6<-data$Vendite_6/data$Scontrini_6


#Salvo il nuovo dataset
write.xlsx(data, 'Ristorazione_pulito.xlsx')