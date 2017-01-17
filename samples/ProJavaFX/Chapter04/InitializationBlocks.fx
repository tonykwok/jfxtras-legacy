var counter = 0;

class Base {
  var i: Integer;
  init {
    println("Step {counter}: Base init block.  i = {i}.");
    counter++;
  }
  postinit {
    println("Step {counter}: Base postinit block.  i = {i}.");
    counter++;
  }
}

class Derived extends Base {
  var str: String;
  init {
    println("Step {counter}: Derived init block.  i = {i}, str = {str}.");
    counter++;
  }
  postinit {
    println("Step {counter}: Derived postinit block.  i = {i}, str = {str}.");
    counter++;
  }
}

var o = Derived {
          i: { println("Step {counter}: i initialized to 1024.");
               counter++;
               1024 },
          str: { println('Step {counter}: str initialized to "Hello, World".');
                 counter++;
                 "Hello, World" }
        };

