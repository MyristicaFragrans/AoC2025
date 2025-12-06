module day06.day06;

import std;
import std.algorithm: canFind;
import std.datetime.stopwatch;

const bool PART_TWO = true;
void main() {
  static if (PART_TWO) part2();
  else part1();
}

void part1() {
  long[][] nums = [];
  nums.reserve(6);
  File input = File("input.txt", "r");
  scope (exit) input.close();

  StopWatch sw;
  sw.start();
  
  while (!input.eof()) {
    string line = input.readln();
    if(line.length <= 1) continue;
    long[] row = [];
    string currentNumber = "";
    for(int i = 0; i < line.length; i++) {
      char c = line[i];
      if (c >= '0' && c <= '9') currentNumber ~= c;
      else if((c == ' ' || c == '\n') && currentNumber.length > 0) {
        row ~= parse!long(currentNumber);
        currentNumber = "";
      } else if(c == '+') {
        long currentIdx = row.length;
        long result = reduce!"a + b"(nums.map!(a=>a[currentIdx]));
        row ~= result;
      } else if(c == '*') {
        long currentIdx = row.length;
        long result = reduce!"a * b"(nums.map!(a=>a[currentIdx]));
        row ~= result;
      }
    }
    nums ~= row;
  }
  long grandTotal = reduce!"a + b"(nums[$-1]);
  sw.stop();
  std.writefln("Took %s microseconds", sw.peek.total!"usecs");
  std.writefln("Total: %s", grandTotal);
}

void part2() {
  string data = std.readText("input.txt");
  long width = data.indexOf('\n') + 1;
  long lines = data.length / width;
  long operatorLineIdx = width * (lines - 1);
  writefln("Lines: %s", lines);

  StopWatch sw;
  sw.start();

  long[] results = [];
  
  long startIdx = -1;
  long endIdx = -1;
  char op = '.';
  for(long i = 0; i < width; i++) {
    // Locate the start of a problem. The operator is always at the bottom left
    // of the problem.
    char c = data[operatorLineIdx + i];
    if (op == '.' && (c == '*' || c == '+')) {
      op = c;
      startIdx = i;
    } else if ((op != '.' && c != ' ') || i == width - 1) {
      endIdx = i - 1;
      if(i == width - 1) endIdx++; // fenceposting
      long numOperands = endIdx - startIdx;
      // uncomment to see slices found
      // for(long y = 0; y < lines; y++) writefln(" - %s", data[y*width+startIdx .. y*width+endIdx]);
      long[] operands = [];
      // work top to bottom, left to right
      for(long x = 0; x < numOperands; x++) {
        string num = "";
        for(long y = 0; y < lines - 1; y++) {
          char a = data[y*width+x+startIdx];
          if (a != ' ') num ~= a;
        }
        operands ~= parse!long(num);
      }
      if (op == '+') results ~= reduce!"a + b"(operands);
      if (op == '*') results ~= reduce!"a * b"(operands);
      op = c;
      startIdx = endIdx + 1;
      endIdx = -1;
    }
  }
  long total = reduce!"a + b"(results);
  sw.stop();
  std.writeln(total);
  std.writefln("Took %s microseconds", sw.peek.total!"usecs");
}