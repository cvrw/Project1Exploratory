file="./data/household_power_consumption.txt"
aux=read.table(file,sep=";",nrows=10,header=TRUE)
columnNames=colnames(aux)
readLines(file,2:10)
data=read.table(file,sep=";",skip=grep("31/1/2007;10:00:00", readLines(file)),nrows=10000)
colnames(data)=columnNames
data=data[rbind( grep("1/2/2007",data$Date) , grep("2/2/2007",data$Date) ),]
data$Date=as.character(data$Date)
data$Time=as.character(data$Time)
data=mutate(data,datetime=dmy_hms(paste(data$Date,data$Time)))
data=mutate(data,weekday=wday(datetime, label=TRUE))
data=arrange(data,datetime)
pdf(file="plot3.pdf")
plot(data$datetime,data$Sub_metering_1,type="l",ylab="Energy sub metering",xlab="")
lines(data$datetime,data$Sub_metering_2,col="red")
lines(data$datetime,data$Sub_metering_3,col="blue")
legend("topright",legend=cbind("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1),lwd=c(2.5,2.5,2.5),col=c("black","blue","red"))
dev.off()