package consumer;

import food.Sandwiches.*;

var club = Club { kind: "Roast Beef" };
calculatePrice(club);
println("The price of the {club.kind} club sandwich is {club.price}.");
