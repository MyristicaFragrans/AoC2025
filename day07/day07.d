module day07.day07.d.day07;

import std;
import std.datetime.stopwatch;

const bool DEBUG = false;
void main() {
  File input = File("input.txt", "r");
  scope (exit) input.close();
  
  string start = input.readln();
  int width = cast(int)(start.length);
  // Store active beams
  ulong[] rowBeams = new ulong[width];
  rowBeams[start.indexOf('S')] = 1;

  // For calculating new beams
  ulong[] nextBeams = new ulong[width];

  int timesSplit = 0;
  StopWatch sw;
  sw.start();

  while(!input.eof()) {
    string line = input.readln();
    foreach (size_t i, char c; line) {
      if(c == '.') nextBeams[i] += rowBeams[i];
      else if(c == '^' && rowBeams[i] > 0) {
        timesSplit++;
        nextBeams[i-1] += rowBeams[i];
        nextBeams[i+1] += rowBeams[i];
      }
    }
    static if (DEBUG) {
      foreach (size_t i, int b; nextBeams) {
        write(line[i] == '^' ? '^' : (b > 0 ? '|' : '.'));
      }
      writefln("s: %s t: %s", timesSplit, reduce!"a + b"(nextBeams));
    }
    rowBeams = nextBeams;
    nextBeams = new ulong[width];
  }
  sw.stop();
  writefln("Split %s times", timesSplit);
  writefln("Timelines: %s", reduce!"a + b"(rowBeams));
  writefln("Took %s microseconds", sw.peek.total!("usecs"));
}