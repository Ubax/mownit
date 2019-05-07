using Roots
using Plots
using ForwardDiff
using DataFrames

function getComparision(f, Df, a, b)
    biIt=0
    deIt=0
    adIt=0
    fpIt=0
    function wrapperBi(x)
        biIt=biIt+1
        f(x)
    end
    function wrapperFP(x)
        fpIt+=1
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

    ((find_zero(wrapperBi, (a,b), Bisection()), biIt),(find_zero(wrapperFP, (a,b), FalsePosition(12)), fpIt),(find_zero((wrapperDe, Df), a, Roots.Newton()), deIt),(find_zero(wrapperSD, a, Order2()), adIt))
end

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

bisecti = zeros(0)
falspos = zeros(0)
derivat = zeros(0)
aprDeri = zeros(0)
mathFun = ["sin(x)-x/2 [-1,1]", "2*x-exp(-x)[-2,4]", "x*exp(x)", "x^3-2*x-5", "exp(x)-2-1/(10*x)^2+2/(100*x)^3", "cos(x)-x [-1,1]", "cos(x)-x [-101,100]", "cos(x)-x[-123, 3]","sin(x)-x/2 [-0.55,1]", "2*x-exp(-x) [-9,20]"]

tests = [
    ((x->sin(x)-x/2), -1, 1, mathFun[1], x->cos(x)-1/2),
    ((x->2*x-exp(-x)), -2, 4, mathFun[2]),
    ((x->x*exp(-x)), -3, 4, mathFun[3]),
    (x->x^3-2*x-5, 0, 5, mathFun[4]),
    (x->exp(x)-2-1/(10*x)^2+2/(100*x)^3, 0.1, 2, mathFun[5]),
    ((x->cos(x)-x), -1, 1, mathFun[6], x->-sin(x)-1),
    ((x->cos(x)-x), -101, 100, mathFun[7], x->-sin(x)-1),
    ((x->cos(x)-x), -123, 3, mathFun[8], x->-sin(x)-1),
    ((x->sin(x)-x/2), -0.55, 1, mathFun[9]),
    ((x->2*x-exp(-x)), -9, 20, mathFun[10]),
]

for test in tests
    D(f) = x->x
    if size(test, 1) == 5
        Df = test[5]
    else
        f = test[1]
        Df = x->ForwardDiff.derivative(f, float(x))
    end

    res = getComparision(test[1], Df, test[2],test[3])

    for i=1:4
        if test[1](res[i][1]) * test[1](prevfloat(res[i][1])) < 0.0 || test[1](res[i][1]) * test[1](nextfloat(res[i][1])) < 0.0#!iszero(test[1](res[i][1]))
            print("Is not zero (",i,"): ")
            print(test[4])
            println(" = ", test[1](res[i][1]))
        end
    end
    append!(bisecti, res[1][2])
    append!(falspos, res[2][2])
    append!(derivat, res[3][2])
    append!(aprDeri, res[4][2])
end

data = DataFrame(Function = mathFun, Bisection = bisecti, FalsePosition = falspos, Derivative = derivat, ApproxDerivative = aprDeri)

#Newton doesn't work for cos(x)-x, start in -100
