// Drinks.fx
package food;

public class Coffee {
  public var brand: String;
}

public class Tea {
  public var kind: String;
}
package var drinksOffered:Integer;

public function getCoffee():Coffee {
  drinksOffered++;
  Coffee { brand: "Folgers" }
}
public function getTea():Tea {
  drinksOffered++;
  Tea { kind: "Iced" }
}
public function numberOfDrinksOffered() {
  drinksOffered
}
