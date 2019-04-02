using Plots
using DataFrames
using Statistics
using Polynomials

function naive_multiplication(A,B)
    C=zeros(Float64, size(A,1), size(B,2))
    for i=1:size(A,1)
        for j=1:size(B,2)
            for k=1:size(A,2)
                C[i,j]=C[i,j]+A[i,k]*B[k,j]
            end
        end
    end
    C
end

function better_multiplication(A,B)
    C=zeros(Float64, size(A,1), size(B,2))
    for j=1:size(B,2)
        for k=1:size(A,2)
            for i=1:size(A,1)
                C[i,j]=C[i,j]+A[i,k]*B[k,j]
            end
        end
    end
    C
end

x = 50:50:500 

naive = zeros(0)
better = zeros(0)
blas = zeros(0)
matrixSize = zeros(0)

for i=x
    for j=1:10
        append!(matrixSize, i)
        matrix1 = [r^2*c for r in 1.0:Float64(i), c in 1.0:Float64(i)]
        matrix2 = [r*c^3 for r in 1.0:Float64(i), c in 1.0:Float64(i)]
        append!(naive, @elapsed naive_multiplication(matrix1, matrix2))
        append!(better, @elapsed better_multiplication(matrix1, matrix2))
        append!(blas, @elapsed matrix1*matrix2)
        print("#")
    end
end

data = DataFrame(Size = matrixSize, Naive = naive, Better = better, Blas = blas)
analysis = by(data, :Size, :Naive=>mean, :Better=>mean, :Blas=>mean, :Naive=>std, :Better=>std, :Blas=>std)

dataPlot = plot(analysis[:Size], analysis[:Naive_mean], yerror=analysis[:Naive_std], 
    label="Naive", title="Matrix multiplication methods comaprision", xlabel="size", ylabel="time")
plot!(dataPlot, analysis[:Size], analysis[:Better_mean], yerror=analysis[:Better_std], label = "Better")
plot!(dataPlot, analysis[:Size], analysis[:Blas_mean], yerror=analysis[:Blas_std], label = "Blas")

naivePoly = polyfit(analysis[:Size], analysis[:Naive_mean], 3)
betterPoly = polyfit(analysis[:Size], analysis[:Better_mean], 3)
blasPoly = polyfit(analysis[:Size], analysis[:Blas_mean], 3)


naivePolyArray = zeros(0)
betterPolyArray = zeros(0)
blasPolyArray = zeros(0)
for i=x
    append!(naivePolyArray, naivePoly(i))
    append!(betterPolyArray, betterPoly(i))
    append!(blasPolyArray, blasPoly(i))
end

plot!(dataPlot, analysis[:Size], naivePolyArray, label = "Poly naive")
plot!(dataPlot, analysis[:Size], betterPolyArray, label = "Poly better")
plot!(dataPlot, analysis[:Size], blasPolyArray, label = "Poly blas")