module day05.day05;

import std;
import std.datetime.stopwatch;

struct RangePair {
  long lo;
  long hi;
  int compareRange(long value) {
    if (value < lo) return -1;
    if (value > hi) return 1;
    return 0;
  }
}

void main() {
  RangePair[] ranges = [];
  File input = File("input.txt", "r");
  scope (exit) input.close();

  string line;
  // Get ranges, ending with a blank line
  while((line = std.string.strip(input.readln())).length != 0) {
    auto nums = line.split("-").map!(a=>parse!long(a)).array().sort();
    ranges ~= RangePair(nums[0],nums[1]);
  }
  ranges.sort!((a,b)=>a.lo < b.lo);

  StopWatch p1;
  p1.start();

  // The rest of the rows are possible ingredient IDs
  int numFreshIngredients = 0;
  nextIngredient:
  while(!input.eof()) {
    line = std.string.strip(input.readln());
    if(line.length == 0) break;
    long value = parse!long(line);
    foreach(range; ranges) {
      if (range.compareRange(value) == 0) {
        numFreshIngredients++;
        continue nextIngredient;
      }
    }
  }

  p1.stop();
  writefln("Part 1 took %s microseconds", p1.peek.total!"usecs");
  writefln("Fresh ingredients: %s", numFreshIngredients);

  StopWatch p2;
  p2.start();

  long numIdsValid = 0;
  foreach(i, range; ranges) {
    long trueLo = range.lo;
    long trueHi = range.hi + 1;
    foreach (earlier; ranges[0..i]) {
      trueLo = max(trueLo, earlier.hi + 1);
    }
    if(trueLo > trueHi) continue;
    numIdsValid += trueHi - trueLo;
  }

  p2.stop();
  writefln("Part 2 took %s microseconds", p2.peek.total!"usecs");
  writefln("There are %s valid IDs", numIdsValid);
}