class Point {
  var x: Number;
  var y: Number;
  override function toString(): String {
    "Point({x}, {y})"
  }
}

// reading member variables
var p = Point { x: 3.0, y: 4.0 };
println("p.x = {p.x}");
println("p.y = {p.y}");
println("p = {p}");

// writing to member variables
p.x = 5.0;
p.y = 12.0;
println("p = {p}");
