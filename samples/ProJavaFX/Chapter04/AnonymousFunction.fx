import java.lang.Math.*;

{
  var hypot: function(:Number, :Number):Number;

  hypot = function(x, y) {
    sqrt(x*x + y*y);
  };

  println("hypot(3, 4) = {hypot(3, 4)}");
}
