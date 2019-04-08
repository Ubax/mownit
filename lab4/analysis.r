library("ggplot2")
setwd("~/Documents/AGH/4-semestr/mownit/lab4/")
data = read.csv("result.csv")

avg_results=aggregate(cbind(Naive, Better, Blas) ~ Size, data=data, FUN=mean)

avg_results$Naive_sd = aggregate(Naive ~ Size, data = data, FUN = sd)$Naive
avg_results$Better_sd = aggregate(Better ~ Size, data = data, FUN = sd)$Better
avg_results$Blas_sd = aggregate(Blas ~ Size, data = data, FUN = sd)$Blas

fitNaive = lm(Naive ~ poly(as.vector(avg_results[["Size"]]), 3, raw = TRUE), data = avg_results)
fitBetter = lm(Better ~ poly(as.vector(avg_results[["Size"]]), 3, raw = TRUE), data = avg_results)
fitBlas = lm(Blas ~ poly(as.vector(avg_results[["Size"]]), 3, raw = TRUE), data = avg_results)

polyNaive = data.frame(x=avg_results["Size"])
polyBetter = data.frame(x=avg_results["Size"])
polyBlas = data.frame(x=avg_results["Size"])

polyNaive$y=predict(fitNaive, polyNaive)
polyBetter$y=predict(fitBetter, polyBetter)
polyBlas$y=predict(fitBlas, polyBlas)

ggplot()+
  geom_errorbar(data=avg_results, aes(x=Size, y=Naive, ymin=Naive-Naive_sd, ymax=Naive+Naive_sd))+
  geom_errorbar(data=avg_results, aes(x=Size, y=Better, ymin=Better-Better_sd, ymax=Better+Better_sd))+
  geom_errorbar(data=avg_results, aes(x=Size, y=Blas, ymin=Blas-Blas_sd, ymax=Blas+Blas_sd))+
  geom_point(data=avg_results, aes(Size, Naive), colour="red", label_value("Naive"))+
  geom_point(data=avg_results, aes(Size, Better), colour="blue")+
  geom_point(data=avg_results, aes(Size, Blas), colour="green")+
  geom_line(data=polyNaive, aes(Size, y), colour="red")+
  geom_line(data=polyBetter, aes(Size, y), colour="blue")+
  geom_line(data=polyBlas, aes(Size, y), colour="green")+
  ggtitle("Comparison of naive, better and blas matrix multiplication") +
  xlab("Size") +
  ylab("Time [s]")