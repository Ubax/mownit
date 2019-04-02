using DataFrames
using CSV
using Plots
using Statistics
using Polynomials

data=CSV.read("result.csv")
analisys  = by(data, :Size, :Naive => mean, :Naive => std, :Better => mean, :Better => std, :Blas => mean, :Blas => std)
dataPlot = plot(analisys[:Size], analisys[:Naive_mean], yerr=analisys[:Naive_std], label="Naive", title="Matrix multiplication methods comaprision", xlabel="size", ylabel="time")
plot!(dataPlot, analisys[:Size], analisys[:Better_mean], yerr=analisys[:Better_std], label="Better")
plot!(dataPlot, analisys[:Size], analisys[:Blas_mean], yerr=analisys[:Blas_std], label="Blas")
display(dataPlot)

naivePoly = polyfit(analisys[:Size], analisys[:Naive_mean], 3)
betterPoly = polyfit(analisys[:Size], analisys[:Better_mean], 3)
blasPoly = polyfit(analisys[:Size], analisys[:Blas_mean], 3)


naivePolyArray = zeros(0)
betterPolyArray = zeros(0)
blasPolyArray = zeros(0)
for i=analisys[:Size]
    append!(naivePolyArray, naivePoly(i))
    append!(betterPolyArray, betterPoly(i))
    append!(blasPolyArray, blasPoly(i))
end

plot!(dataPlot, analisys[:Size], naivePolyArray, label = "Poly naive")
plot!(dataPlot, analisys[:Size], betterPolyArray, label = "Poly better")
plot!(dataPlot, analisys[:Size], blasPolyArray, label = "Poly blas")