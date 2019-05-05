using Roots
using Plots
using ForwardDiff
using DataFrames

function getComparision(f, a, b)
    biIt=0
    deIt=0
    adIt=0
    function wrapperBi(x)
        biIt=biIt+1
        f(x)
    end
    function wrapperDe(x)
        deIt=deIt+1
        f(x)
    end
    function wrapperSD(x)
        adIt=adIt+1
        f(x)
    end

    D(f) = x->ForwardDiff.derivative(f, float(x))

    ((find_zero(wrapperBi, (a,b), Bisection()), biIt),(find_zero((wrapperDe, D(f)), a, Roots.Newton()), deIt),(find_zero(wrapperSD, a, Order2()), adIt))
end

function getVerbose(f, a, b)
    bx=zeros(0)
    by=zeros(0)

    dx=zeros(0)
    dy=zeros(0)

    dfx=zeros(0)
    dfy=zeros(0)

    ax=zeros(0)
    ay=zeros(0)
    function wrapperBi(x)
        append!(bx,x)
        append!(by,f(x))
        f(x)
    end
    function wrapperDe(x)
        append!(dx,x)
        append!(dy,f(x))
        f(x)
    end
    function wrapperAD(x)
        append!(ax,x)
        append!(ay,f(x))
        f(x)
    end

    function D(x)
        Dp(f) = xl->ForwardDiff.derivative(f, float(xl))
        append!(dfx,x)
        append!(dfy,Dp(f)(x))
        Dp(f)(x)
    end

    find_zero(wrapperBi, (a,b), Bisection())
    find_zero((wrapperDe, D), a, Roots.Newton())
    find_zero(wrapperAD, a, Order2())

    (bx,by,dx,dy,ax,ay)
end

bisecti = zeros(0)
derivat = zeros(0)
aprDeri = zeros(0)
mathFun = ["sin(x)-x/2", "2*x-exp(-x)", "x*exp(x)", "x^3-2*x-5", "exp(x)-2-1/(10*x)^2+2/(100*x)^3", "cos(x)-x"]

tests = [
    ((x->sin(x)-x/2), -1, 1, mathFun[1]),
    ((x->2*x-exp(-x)), -2, 4, mathFun[2]),
    ((x->x*exp(-x)), -3, 4, mathFun[3]),
    (x->x^3-2*x-5, 0, 5, mathFun[4]),
    (x->exp(x)-2-1/(10*x)^2+2/(100*x)^3, 0.1, 2, mathFun[5]),
    ((x->cos(x)-x), -1, 1, mathFun[6])
]

for test in tests
    res = getComparision(test[1],test[2],test[3])

    for i=1:3
        if test[1](res[i][1]) * test[1](prevfloat(res[i][1])) < 0.0 || test[1](res[i][1]) * test[1](nextfloat(res[i][1])) < 0.0#!iszero(test[1](res[i][1]))
            print("Is not zero (",i,"): ")
            print(test[4])
            println(" = ", test[1](res[i][1]))
        end
    end
    append!(bisecti, res[1][2])
    append!(derivat, res[2][2])
    append!(aprDeri, res[3][2])
end

data = DataFrame(Function = mathFun, Bisection = bisecti, Derivative = derivat, ApproxDerivative = aprDeri)

f=x->2*x-exp(-x)

(bx,by,dx,dy,ax,ay) = getVerbose(f, -2, 4)

function animatePlot(data_x, data_y, f, file_name, fps)
    iter = 0
    fx=zeros(0)
    fy=zeros(0)
    yLim = max(abs(minimum(data_y)), maximum(data_y))
    yLim = yLim + yLim/10
    funX=zeros(0)
    funY=zeros(0)
    for i=minimum(data_x):0.1:maximum(data_x)
        append!(funX,i)
        append!(funY,f(i))
    end
    anim = @animate for i=1:size(data_x, 1)
        iter+=1
        append!(fx,data_x[i])
        append!(fy,data_y[i])
        animPlot = plot(funX, funY, ylim=(-yLim, yLim), title="$(iter)")
        plot!(animPlot, fx, fy, ylim=(-yLim, yLim), seriestype=:scatter, legend=false)
    end
    gif(anim, file_name, fps = fps)
end

fx=zeros(0)
fy=zeros(0)
for i=-2:0.1:4
    append!(fx,i)
    append!(fy,f(i))
end

animatePlot(bx, by, "img/Bisection.gif", 5)
animatePlot(dx, dy, "img/Derivative.gif", 5)
animatePlot(ax, ay, "img/ApproxDerivative.gif", 5)

fullPlot = plot(fx,fy,label="Function", title="Roots finding methodes", xlabel="x", ylabel="y")
plot!(verbosePlot, bx, by, seriestype=:scatter, label = "Bisection")
plot!(verbosePlot, dx, dy, seriestype=:scatter, label = "Newton")
plot!(verbosePlot, ax, ay, seriestype=:scatter, label = "Order2")
