class Hamburger {
  function whatsInIt() {
    "Beef patties"
  }
}

class HamburgerWithCheese extends Hamburger {
  override function whatsInIt() {
    "{super.whatsInIt()} and cheese"
  }
}

var hamburger = Hamburger {};
var cheeseburger = HamburgerWithCheese {};
println("hamburger.whatsInIt() = {hamburger.whatsInIt()}.");
println("cheeseburger.whatsInit() = {cheeseburger.whatsInIt()}."); 
