var seq = for (x in [1..4]) x*x;
print("seq = "); println(seq);

seq = for (x in [1..4] where x > 2) x*x;
print("seq = "); println(seq);

var rows = ["A", "B"];
var columns = [1, 2];
var matrix = for (row in rows, column in columns) "{row}{column}";
print("matrix = "); println(matrix);

var digits = [1, 2, 3];
var seq1 = for (x in digits, y in digits) "{x}{y}";
print("seq1 = "); println(seq1);

var seq2 = for (x in digits where x > 1, y in digits where y >= x) {
  "{x}{y}"
}
print("seq2 = "); println(seq2);
