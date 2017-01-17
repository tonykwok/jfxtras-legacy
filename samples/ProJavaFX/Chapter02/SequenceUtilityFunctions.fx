import javafx.util.Sequences.*;

var seq = [1, 4, 2, 8, 5, 7];
print("seq = "); println(seq);

println("The index of 4 in seq = {indexOf(seq, 4)}");
println("The max value of seq = {max(seq)}");
println("The min value of seq = {min(seq)}");

print("reverse(seq) = "); println(reverse(seq));
print("shuffle(seq) = "); println(shuffle(seq));

var sorted = sort(seq);
print("sortd = "); println(sorted);

var index = binarySearch(sorted, 4);
println("Found 4 in sorted at index {index}");

var integers = [1, 3, 5, 3, 1];
print("integers = "); println(integers);
println("indexOf(integers, 3) = {indexOf(integers, 3)}");
println("nextIndexOf(integers, 3, 2) = {nextIndexOf(integers, 3, 2)}");
