dataset <- read.csv("/Users/freddyespinoza/Downloads/_r/csvfolder/heart_failure_clinical_records_dataset.csv", 
                   header = TRUE, sep = ",", dec = ".")

df <- data.frame(dataset)

print (df)

summary(df)

plot(df$time, df$age)

regresion <- lm(time ~anaemia + creatinine_phosphokinase + diabetes + ejection_fraction + 
                  high_blood_pressure + platelets + serum_creatinine + serum_sodium + sex +
                  smoking + age + DEATH_EVENT, df)
summary(regresion)

regresion <- lm(time ~anaemia + high_blood_pressure + ejection_fraction + DEATH_EVENT, df)
summary(regresion)

newdf <- data.frame(anaemia=1, high_blood_pressure=1, ejection_fraction=10, DEATH_EVENT=1)
predict(regresion, newdf)
