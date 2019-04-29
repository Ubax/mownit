library("ggplot2")
setwd("~/Documents/AGH/4-semestr/mownit/lab5/code")
dataNewton = read.csv("Newton.csv")
dataLagrange = read.csv("Lagrange.csv")
dataGSL = read.csv("gsl.csv")
points = read.csv("points.csv")
ggplot()+
     xlab("x") +
     geom_line(data=dataNewton, aes(x, y), colour="red", size=3)+
     geom_line(data=dataLagrange, aes(x, y), colour="green", size=2)+
     geom_line(data=dataGSL, aes(x, y), colour="black", size=1) +
     ylab("y") +
     geom_point(data=points, aes(x, y), colour="blue",size=4)

data = read.csv("times.csv")
analysis = data.frame(
  newton_mean = apply(data["newton"],2,mean),
  lagrange_mean = apply(data["lagrange"],2,mean),
  gsl_mean = apply(data["gsl"],2,mean),
  newton_std = apply(data["newton"],2,sd),
  lagrange_std = apply(data["lagrange"],2,sd),
  gsl_std = apply(data["gsl"],2,sd)
)

cubic = read.csv("cubic.csv")
linear = read.csv("linear.csv")

ggplot()+
  xlab("x") +
  geom_line(data=dataNewton, aes(x, y), colour="red", size=1)+
  geom_line(data=cubic, aes(x, y), colour="green", size=1)+
  geom_line(data=linear, aes(x, y), colour="black", size=1) +
  ylab("y") +
  geom_point(data=points, aes(x, y), colour="blue",size=2)