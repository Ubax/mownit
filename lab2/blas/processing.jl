using Pkg
Pkg.add("DataFrames")
using DataFrames
Pkg.add("CSV")
using CSV
Pkg.add("Statistics")
using Statistics
Pkg.add("Plots")
using Plots
data=CSV.read("result.csv")
analizys  = by(data, :ddot_size, :ddot_time => mean, :ddot_time => std, :dgemv_time => mean, :dgemv_time => std)
ddot_plot=plot(analizys[:ddot_size], [analizys[:ddot_time_mean]],yerr=analizys[:ddot_time_std], xlabel="size", ylabel="time[s]", title="DDOT")
dgemv_plot=plot(analizys[:ddot_size], [analizys[:dgemv_time_mean]],yerr=analizys[:dgemv_time_std], xlabel="size", ylabel="time[s]", title="DGEMV")
plot(ddot_plot, dgemv_plot)