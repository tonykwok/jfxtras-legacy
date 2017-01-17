class A {
  function f(i:Integer):Integer {
    println("A.f() is invoked with parameter i = {i}.");
    i + 3
  }
}

class B extends A {
  override function f(i:Integer):Integer {
    println("B.f() is invoked with parameter i = {i}.");
    i * 5;
  }
}

var a = A {};
var b = B {};
var ra = a.f(4);
var rb = b.f(7);
println("a.f(4) = {ra}.");
println("b.f(7) = {rb}.");
