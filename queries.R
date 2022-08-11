# Reto 1
install.packages("dplyr")
install.packages("DBI")
install.packages("RMySQL")

library(dplyr)
library(DBI)
library(RMySQL)

MyDataBase <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest")

dbListTables(MyDataBase)
dbListFields(MyDataBase, 'City')
dbListFields(MyDataBase, 'CountryLanguage')
dbListFields(MyDataBase, 'Country')

## Consulta de países que hablan español
Esp <- dbGetQuery(MyDataBase, "
  select *
  FROM
    CountryLanguage
  WHERE
    Language = 'Spanish'
")

Esp

## Consulta de países que hablan español con Nombre, IsOfficial, Percentage
EspName <- dbGetQuery(MyDataBase, "
SELECT
Country.Name, CountryLanguage.IsOfficial, CountryLanguage.Percentage
FROM
CountryLanguage
LEFT JOIN
Country
ON
CountryLanguage.CountryCode = Country.Code
WHERE
CountryLanguage.Language = 'Spanish'
")

EspName
class(EspName)

install.packages("ggplot2") ## Instalar paquete ggplot2
library(ggplot2) ## Cargar la librería


EspName %>% ggplot(aes( x = Name, y=Percentage, fill = IsOfficial )) + 
  geom_bin2d() +
  coord_flip()

EspName %>% ggplot(aes( x = Percentage, y=Name, fill = IsOfficial )) + 
  geom_bin2d() 

EspName %>% ggplot(aes( x = Percentage, y=Name, colour = IsOfficial )) + 
  geom_point()
