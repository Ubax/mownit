using FFTW
using Plots

X=-20.0:0.001:20.0
Y=[cos(x) + rand() - 0.5 for x in X ]
plot(X,Y)

FFT = fft(Y)

sticks(abs.(FFT))

filteredFFt = Array{Complex{Float64},1}(map(x -> abs(x)<200 ? 0 : x, FFT))

sticks(abs.(filteredFFt))

filteredY = ifft(filteredFFt)

plot(X,real(filteredY))
