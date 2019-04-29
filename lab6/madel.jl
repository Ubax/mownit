function z(n, p)
    n==0 ? 0 : (z(n-1, p)^2+p)
end

function test(x,y)
    abs(z(20, complex(x,y)))<2
end

x=zeros(0)
y=zeros(0)
for i=-3:0.01:1
    for j=-1:0.01:1
        if test(i,j)
            append!(x,i)
            append!(y,j)
        end
    end
end

plt = plot(x, y, seriestype=:scatter, title="Mandelbrot", width=0.1)