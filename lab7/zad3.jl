using WAV
using FFTW
using Plots


function filterSound(soundFFT, value)
    soundFilteredFFT = Array{Complex{Float64},1}(map(x -> abs(x)<value ? 0 : x, soundFFT))
    soundFiltered = ifft(soundFilteredFFT)
    wavwrite(real.(soundFiltered), string("filtered-", value, ".wav"), Fs=sampFreq)
end

sound, sampFreq = wavread("voice.wav")
t1=zeros(0)
t2=zeros(0)
l1=zeros(0)
l2=zeros(0)
println("Freq: ",(sampFreq))
println("Time: ",size(sound,1)/sampFreq)
for i = 0:1:size(sound,1)-1
    append!(t1,i/sampFreq)
    append!(l1,sound[i+1,1])
end
for i = 0:1:size(sound,2)-1
    append!(t2,i/sampFreq)
    append!(l2,sound[i+1,2])
end

sound = l1

rawSound = plot(t1, sound)

soundFFT = fft(sound)

sticks((abs.(soundFFT)))

filterSound(soundFFT, 5)
filterSound(soundFFT, 10)
filterSound(soundFFT, 20)
filterSound(soundFFT, 50)
filterSound(soundFFT, 100)
filterSound(soundFFT, 200)
filterSound(soundFFT, 300)
filterSound(soundFFT, 400)
