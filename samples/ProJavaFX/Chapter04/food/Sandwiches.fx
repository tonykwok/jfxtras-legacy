// Sandwiches.fx
package food;

public class Club {
  public-init var kind: String;
  public-read var price: Number;
}

public function calculatePrice(club: Club) {
  if (club.kind == "Roast Beef") {
    club.price = 7.99;
  } else if (club.kind == "Chicken") {
    club.price = 6.99;
  }
}
