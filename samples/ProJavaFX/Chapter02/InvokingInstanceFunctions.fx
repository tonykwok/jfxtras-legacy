import java.lang.Math.*;

class Point {
  var x: Number;
  var y: Number;
  function distanceFromOrigin(): Number {
    sqrt(x*x + y*y)
  }
  function translate(dx: Number, dy: Number) {
    x += dx;
    y += dy;
  }
  override function toString(): String {
    "Point({x}, {y})"
  }
}

var p = Point { x: 3.0, y: 4.0 };
println("p = {p}");
println("Distance between p and the origin = {p.distanceFromOrigin()}");

p.translate(2.0, 8.0);
println("p = {p}");
println("Distance between p and the origin = {p.distanceFromOrigin()}");

print("Distance between Point \{x: 8.0, y: 15.0\} and the origin = ");
println(Point {x: 8.0, y: 15.0}.distanceFromOrigin());
