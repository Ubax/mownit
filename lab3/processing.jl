using DataFrames
using CSV
using Statistics
using Plots

data=CSV.read("result.csv")
analisys  = by(data, :Size, :Naive => mean, :Naive => std, :Better => mean, :Better => std, :Blas => mean, :Blas => std)
dataPlot = plot(analisys[:Size], analisys[:Naive_mean], yerr=analisys[:Naive_std], label="Naive", title="Matrix multiplication methods comaprision", xlabel="size", ylabel="time")
plot!(dataPlot, analisys[:Size], analisys[:Better_mean], yerr=analisys[:Better_std], label="Better")
plot!(dataPlot, analisys[:Size], analisys[:Blas_mean], yerr=analisys[:Blas_std], label="Blas")
display(dataPlot)