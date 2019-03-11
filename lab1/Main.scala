import scala.math.sqrt
import scala.math.pow

object Main extends App {
  def squareRootsUnstable(a:Double, b:Double, c:Double) = {
    val delta = b*b-4*a*c
    val res = new Array[Double](2)
    res(0)=(-b-sqrt(delta))/2/a
    res(1)=(-b+sqrt(delta))/2/a
    (res(0), res(1))
  }
  def squareRootsStable(a:Double, b:Double, c:Double) = {
    val delta = b*b-4*a*c
    val res = new Array[Double](2)

    if(b>0)res(0)=(-b-sqrt(delta))/2/a
    else res(0)=(-b+sqrt(delta))/2/a

    res(1)=c/a/res(0)

    (res(0), res(1))
  }
  for(i <- 1 to 12){
    println("Stable: "+squareRootsStable(1/pow(10,i), pow(10,i), 1/pow(10,i)))
    println("Unstable: "+squareRootsUnstable(1/pow(10,i), pow(10,i), 1/pow(10,i)))
  }
}