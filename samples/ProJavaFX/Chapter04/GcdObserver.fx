class Gcd {
  var a: Integer;
  var b: Integer;
  function gcd(): Integer {
    if (b == 0) {
      return a;
    } else {
      var tmp = a mod b;
      a = b;
      b = tmp;
      return gcd();
    }
  }
}

var o = Gcd { a: 165, b: 105 };

var x = bind o.b on replace {
  println("Iterating: o.a={o.a}, o.b = {x}.");
}

var result = o.gcd();
println("The gcd of 106 and 105 is {result}.");
