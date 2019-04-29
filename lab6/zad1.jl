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

bisecti = zeros(0)
derivat = zeros(0)
aprDeri = zeros(0)
mathFun = ["sin(x)-x/2", "x*exp(-x)", "cos(x)-x", "x^3-2*x-5"]

tests = [
    ((x->sin(x)-x/2), -1, 1, mathFun[1]),
    ((x->x*exp(-x)), -3, 4, mathFun[2]),
    (x->cos(x)-x,-4, 3, mathFun[3]),
    (x->x^3-2*x-5, 0, 5, mathFun[4])
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



