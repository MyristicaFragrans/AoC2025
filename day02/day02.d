import std;

const bool PART_TWO = true;
const bool DEBUG = false;
void main() {
  File input = File("input.txt", "r");
  auto data = std.string.strip(input.readln())
    .split(",")
    .map!(a => a.split("-"));
  input.close();
  
  ulong runningCount = 0;

  static if (PART_TWO) auto repeating = &isRepeatingOverzealous;
  else auto repeating = &isRepeating;

  foreach(pair; data) {
    // No IDs start with a zero, not that our dataset has any
    if(pair[0].indexOf("0") == 0) continue;
    if(pair[1].indexOf("0") == 0) continue;
    
    ulong p1 = std.conv.to!ulong(pair[0]);
    ulong p2 = std.conv.to!ulong(pair[1]);
    
    for(long i = p1; i <= p2; i++) {
      string value = std.conv.to!string(i);
      if (repeating(value)) runningCount += i;
    }
  }

  std.writeln(format("Found %s", runningCount));
}

bool isRepeating(string victim) {
  // numbers with an odd number of digits seem immune?
  if (victim.length % 2 == 1) return false;

  int subLen = cast(int)(victim.length) / 2;
  for(int i = 0; i < subLen; i++) {
    if (victim[i] != victim[i+subLen]) return false;
  }
  return true;
}

bool isRepeatingOverzealous(string victim) {
  // 1212121212 - 10 chars (divisors: 2,5)
  // |    |     OK (5 div)
  // | | | | |  DUPE (2 div)
  //  | | | | | DUPE - return true

  nextDivisor:
  for(int divisor = cast(int)(victim.length) / 2; divisor >= 1; divisor--) {
    // it certainly won't be repeating if this is not a divisor
    if(victim.length % divisor != 0) continue;
    static if (DEBUG) std.writeln(format("%s - div. %s",victim, divisor));

    // For each character in the test repeat length, compare it against every
    // other in succeeding spans.
    int repeats = cast(int)(victim.length) / divisor;
    for(int idx = 0; idx < divisor; idx++) {
      char needle = victim[idx];
      static if (DEBUG) std.write(format("%s^%s"," ".repeat(i).join(),[" ".repeat(divisor-1).join(),"|"].join().repeat(repeats-1).join()));
      // Check each additional span...
      for(int span = 1; span < repeats; span++) {
        if(victim[divisor*span+idx] != needle) {
          static if(DEBUG) std.writeln("\tOK");
          continue nextDivisor;
        }
      }
      static if(DEBUG) std.writeln("\tDUPE");
    }
    static if(DEBUG) std.writeln("!! REPEATING !!");
    return true;
  }
  static if(DEBUG) std.writeln("\\o/ OK \\o/");
  return false;
}
