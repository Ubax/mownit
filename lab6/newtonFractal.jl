using Roots  
using Images
using ForwardDiff
using FileIO

@inline function hsv2rgb(h, s, v)
    c = v * s
    x = c * (1 - abs(((h/60) % 2) - 1))
    m = v - c
 
    r,g,b =
        if h < 60
            (c, x, 0)
        elseif h < 120
            (x, c, 0)
        elseif h < 180
            (0, c, x)
        elseif h < 240
            (0, x, c)
        elseif h < 300
            (x, 0, c)
        else
            (c, 0, x)
        end
 
    Float64(b + m), Float64(g + m), Float64(r + m)
end

f = x->x^3-1
df = x->3*x^2
ratio = 1000
w, h = 8*ratio, 6*ratio
img = Array{RGB{Float64}}(undef, h, w)

res = Array{Float64}(undef, h, w)

maxRes = 0

r1 = complex(1,0)
r2 = complex(-0.5,  sin(2*pi/3))
r3 = complex(-0.5, -sin(2*pi/3))
eps = 0.0001

for i=1:w
    for j=1:h
        res[j,i]=0
        z=complex((i-w/2)/ratio, (j-h/2)/ratio)
        while res[j,i]<360 && abs(z-r1)>=eps && abs(z-r2)>=eps && abs(z-r3)>=eps
            z=z-f(z)/df(z)
            res[j,i]+=1
        end
    end
end

for i=1:w
    for j=1:h
        r,g,b=hsv2rgb(res[j, i], 1, 1)
        img[j, i]=RGB{Float64}(r,g,b)
    end
end

save("NF.jpg", img)