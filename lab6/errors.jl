#f = x-> x==0 ? 1 : (1/x-0.1)
#x=find_zero(f, (0.001,20), Bisection())
#println("Bisection: x=", x, " f(x)=", f(x))

f = x-> 2x^3-4x^2+3x
x=find_zero(f, (-1,1), FalsePosition(12))
println("FalsePosition: x=", x, " f(x)=", f(x))

f = x->(1/(x^2-x^4+x^3)-2)
x=find_zero(f, 1, Order2())
println("Order2: x=", x, " f(x)=", f(x))

f = (x->cos(x)-x)
df = x->-sin(x)-1
x=find_zero((f,df), -7.86, Roots.Newton())
println("Newton: x=", x, " f(x)=", f(x))
