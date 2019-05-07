
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

f=x->2*x-exp(-x)

(bx,by,dx,dy,ax,ay) = getVerbose(f, -2, 4)

animatePlot(bx, by, f, "img/Bisection.gif", 7)
animatePlot(dx, dy, f, "img/Derivative.gif", 3)
animatePlot(ax, ay, f, "img/ApproxDerivative.gif", 3)
function test()
    it=0
    function WB()
        println("test")
        Bisection()
    end
    function WF(x)
        it+=1
        x+1
    end
    find_zero(WF, (-6,8), WB(), verbose=true)
    println(it)
end
