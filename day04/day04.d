module day04.day04;

import std;
import std.datetime.stopwatch : StopWatch;
import core.atomic;

const bool PART_TWO = true;
void main() {
  
  int width;
  char[] data;
  {
    string[] lineData = std.file.readText("input.txt")
      .split("\n");
    width = to!int(lineData[0].length);
    data = lineData.map!(a=>a.split()).join().map!(to!(char[])).join();
  }
  writeln(format("%s with width %s",data.length,width));

  StopWatch sw;
  sw.start();

  shared(char[]) sData = cast(shared)(data);

  int runningCount = 0;
  static if(!PART_TWO) runningCount = removePaper(width, &sData);
  else {
    int runs;
    int thisRunCount = 0;
    do {
      runs++;
      thisRunCount = removePaper(width, &sData);
      runningCount += thisRunCount;
    } while(thisRunCount != 0);
    writeln(format("%s runs",runs));
  } 

  sw.stop();
  writeln(format("Multithreaded Reading took %s microseconds", sw.peek.total!"usecs"));
  writeln(format("%s accessible stacks", runningCount));
}

int removePaper(int width, shared(char[])* data) {
  const auto offsets = [
    [-1,-1],[ 0,-1],[ 1,-1],
    [-1, 0],        [ 1, 0],
    [-1, 1],[ 0, 1],[ 1, 1],
  ];
  shared int runningCount = 0;

  foreach (i; parallel(iota(0,data.length))) {
    const char c = (*data)[i];
    if(c != '@') continue;
    int x = to!int(i) % width;
    int y = to!int(i) / width;
    int neighbours = 0;
    nextOffset:
    foreach (offset; offsets) {
      int rx = x + offset[0];
      int ry = y + offset[1];
      if(!isCoordinateValid(width, to!int(data.length), rx, ry)) continue nextOffset;
      if((*data)[ctoi(rx,ry,width)] == '@') neighbours++;
    }
    if(neighbours < 4) {
      runningCount.atomicOp!"+="(1);
      static if (PART_TWO) {
        // we only need to edit in part 2
        synchronized {
          char[]* dataref = cast(char[]*)data;
          (*data)[i] = 'x';
        }
      }
    }
  }
  return runningCount;
}

nothrow @safe bool isCoordinateValid(int width, int length, int x, int y) {
  if(x < 0 || x >= width) return false;
  if(y < 0 || y >= length / width) return false;
  return true;
}

nothrow @safe int ctoi(int x, int y, int width) {
  return y * width + x;
}