class A {
  function f() {
    println("A.f() called.");
  }
}

class B extends A {
  function g() {
    println("B.g() called.");
  }
}

var a: A;
a = B {};
a.f();
(a as B).g();

