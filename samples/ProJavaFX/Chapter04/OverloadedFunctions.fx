function f(i:Integer):Void {
  println("Integer version of f is called with i = {i}.");
}

function f(n:Number):Void {
  println("Number version of f is called with n = {n}.");
}

function f(str:String):Void {
  println("String version of f is called with str = {str}.");
}

f(1024);
f(3.14);
f("Hello, World");
