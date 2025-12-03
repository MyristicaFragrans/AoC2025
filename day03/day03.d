module day03.day03;

import std;
import std.datetime.stopwatch : benchmark, StopWatch;

const bool PART_TWO = true;
const bool DEBUG = false;
const bool PRUNE = false; // slows execution?
void main() {

  static if (PART_TWO) {
    const uint maxBatteries = 12;
  } else {
    const uint maxBatteries = 2;
  }

  File input = File("input.txt", "r");
  scope(exit) input.close();

  ulong runningTotal = 0;
  char[maxBatteries] bestNumbers = new char[maxBatteries];

  StopWatch sw;
  sw.start();

  while(!input.eof()) {
    string line = std.string.strip(input.readln());
    if(line.length == 0) break;
    // We don't need to convert characters to integers until later because they
    // are already sorted by the ASCII table and can be compared with charcodes.
    bestNumbers[0..maxBatteries] = 0;
    int currentIdx = 0;
    nextDigit:
    for(int i = 0; i < maxBatteries; i++) {
      // An index cannot start closer to the end than there are max batteries,
      // and this way we avoid recalculating numbers that have no chance of
      // changing
      int maxIdx = cast(int)(line.length - (maxBatteries - i) + 1);
      static if (PRUNE) if(currentIdx == maxIdx - 1) {
        // If there is only one digit to consider, don't bother with comparisons
        bestNumbers[i] = line[currentIdx++];
        continue nextDigit;
      }
      for(int j = currentIdx; j < maxIdx; j++) {
        if(line[j] > bestNumbers[i]) {
          currentIdx = j + 1;
          bestNumbers[i] = line[j];
          // If the digit is 9, there is not going to be a better one and we
          // can ignore the others
          static if (PRUNE)  if (line[j] == '9') continue nextDigit;
        }
      }
      static if (DEBUG) std.writeln(format("Found %c at %s/%s", bestNumbers[i], currentIdx,maxIdx));
    }
    // Convert to ulongs, add to running total
    for(ulong i = 0; i < maxBatteries; i++) {
      ulong num = cast(ulong)(bestNumbers[i]-'0') * pow(10,maxBatteries-1-i);
      runningTotal += num;
    }

    static if (DEBUG) std.writeln(format("%s", bestNumbers));
  }

  sw.stop();
	long execus = sw.peek.total!"usecs";
  std.writeln(format("%s, took %s microseconds", runningTotal, execus));
}
