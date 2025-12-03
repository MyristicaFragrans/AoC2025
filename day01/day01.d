import std;

void main() {
  const bool PART_TWO = true;
  const bool DEBUG = false;

  File input = File("input.txt", "r");
  scope(exit) input.close();

  int position = 50; // starting position
  int code = 0; // end result appears here

  static if (DEBUG) std.writeln(format("Starting at %s", position));

  while(!input.eof()) {
    string line = std.string.strip(input.readln());
    if(line.length == 0) break;

    // In this challenge, left and right are just fancy words for negative and positive
    int direction = line[0] == 'R' ? 1 : -1;
    int clicks = std.conv.to!int(line[1 .. $]);
    position += direction * clicks;

    static if (PART_TWO) {
      // Count every time we pass zero
      while(position > 99) {
        position -= 100;
        code++;
      }
      while(position < 0) {
        position += 100;
        code++;
      }
    } else {
      // Only count times we land on zero
      position = position % 100;
      if(position < 0) position += 100;
      if (position == 0) code++;
    }

    static if (DEBUG) {
      std.writeln(format("Rotate %s to %s", line, position));
    }
  }
  std.writeln(format("The code is %s", code));
}
