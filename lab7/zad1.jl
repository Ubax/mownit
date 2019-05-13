using FFTW
using Plots


Fs = 1024;
t = 0:1/(Fs-1):1;
x = sin.(2*pi*t*200) + 2* sin.(2*pi*t*400)

y=fft(x)
sticks((abs.(y)))
