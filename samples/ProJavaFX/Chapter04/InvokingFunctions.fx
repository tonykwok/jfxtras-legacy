// InvokingFunctions.fx
import javafx.reflect.*;

public class A {
  public function f(i:Integer):Integer {
    i * i
  }
}

public function g(str:String):String {
  "{str} {str}"
}

public function run() {
  var o = A {};

  var context = FXLocal.getContext();

  // Working with instance function f() of A
  var classType = context.findClass("InvokingFunctions.A");
  var fFunc = classType.getFunction("f", context.getIntegerType());
  var fVal = fFunc.invoke(context.mirrorOf(o), context.mirrorOf(4));
  println("o.f(4)={(fVal as FXPrimitiveValue).asObject()}.");

  // Working with script function g()
  var moduleClassType = context.findClass("InvokingFunctions");
  var gFunc = moduleClassType.getFunction("g", context.getStringType());
  var gVal = gFunc.invoke(null, context.mirrorOf("Hello"));
  println('g("Hello")={(gVal as FXLocal.ObjectValue).asObject()}.');
}
