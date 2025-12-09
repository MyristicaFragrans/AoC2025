module day08.day08;

import std;
import std.conv;
import std.algorithm: canFind;
import core.atomic;
import core.sync.mutex;
import std.datetime.stopwatch;

struct Box {
  ulong[3] coordinates;
  // -1 meaning "on it's own circuit with no connections"
  int circuitId = -1;
  string toString() {
    return format("%s on %s", this.coordinates, this.circuitId);
  }
}

struct Edge {
  size_t hi;
  size_t lo;
}

// from testing with doubles
alias Distance = ulong;

const bool USE_TEST_DATA = false;
void main() {
  File input = File(USE_TEST_DATA ? "test.txt" : "input.txt", "r");
  Box[] boxes;
  while(!input.eof()) {
    string line = std.string.strip(input.readln());
    if(line.length == 0) continue;
    auto coords = line.split(",").map!(a=>parse!ulong(a));
    boxes ~= Box([coords[0],coords[1],coords[2]], -1);
  }
  input.close();

  size_t len = boxes.length;

  StopWatch sw;
  sw.start();

  bool[][] edges = new bool[][](len, len);
  Distance[] distance = new Distance[](len * len);
  distance.fill(0);

  int nextCircuitId = 0;

  // Returns the two joined nodes
  size_t[2] iterateCircuits() {
    size_t bestIdx1;
    size_t bestIdx2;
    Distance bestDistance = Distance.max;
    shared Mutex mtx = new shared Mutex();
    foreach(idx1, box1; parallel(boxes)) {
      size_t tentativeIdx;
      Distance tentativeDistance = Distance.max;
      nextCandidate: foreach(idx2, box2; boxes) {
        if (idx1 == idx2) continue nextCandidate;
        if (edges[idx1][idx2] == true) continue nextCandidate;
        Distance tentative = max(distance[idx1*len+idx2],distance[idx2*len+idx1]);
        if(tentative == 0) {
          // We are only *comparing* values, so we don't need to take the root.
          tentative = distanceSquared(box1.coordinates, box2.coordinates);
          distance[idx1*len+idx2] = tentative;
          distance[idx2*len+idx1] = tentative;
        }
        if (tentative < tentativeDistance) {
          tentativeDistance = tentative;
          tentativeIdx = idx2;
        }
      }
      mtx.lock_nothrow();
      if(tentativeDistance < bestDistance) {
        bestDistance = tentativeDistance;
        bestIdx1 = idx1;
        bestIdx2 = tentativeIdx;
      }
      mtx.unlock_nothrow();
    }
    assert(bestIdx1 != bestIdx2, "This shouldn't occur");
    // Pick an appropriate circuit ID
    int circuitId = boxes[bestIdx1].circuitId;
    if(circuitId == -1) circuitId = boxes[bestIdx2].circuitId;
    if(circuitId == -1) circuitId = nextCircuitId++;
    mergeCircuits(&boxes, bestIdx1, circuitId);
    mergeCircuits(&boxes, bestIdx2, circuitId);
    edges[bestIdx1][bestIdx2] = true;
    edges[bestIdx2][bestIdx1] = true;
    return [bestIdx1, bestIdx2];
  }

  int getNumberOfCircuits() {
    int count = 0;
    for(int i = -1; i < nextCircuitId; i++) {
      if(boxes.filter!(a=>a.circuitId == i).array().length>0) count++;
    }
    return count;
  }

  // build circuits
  for(int n = 0; n < (USE_TEST_DATA ? 10 : 1000); n++) iterateCircuits();

  ulong[] numNodes = [];
  for(int i = -1; i < nextCircuitId; i++) {
    numNodes ~= boxes.filter!(a=>a.circuitId == i).array().length;
    if(numNodes[i+1] == 0) continue;
  }

  sw.stop();
  
  writefln("Final answer: %(%s * %) = %s", numNodes[1..$].sort!"a>b"().take(3), reduce!"a * b"(numNodes[1..$].sort!"a>b"().take(3)));
  writefln("Part 1 took %s microseconds", sw.peek.total!"usecs");

  // Keep going until there is only one circuit
  // I'm not even going to bother measuring the time of this one.
  ulong[2] idxs;
  while(getNumberOfCircuits() > 1) idxs = iterateCircuits();
  Box node1 = boxes[idxs[0]];
  Box node2 = boxes[idxs[1]];
  writefln("Part 2: %s * %s = %s", node1.coordinates[0], node2.coordinates[0], node1.coordinates[0] * node2.coordinates[0]);
}

void mergeCircuits(Box[]* arr, size_t idx, int circuitId) {
  // Because IDs are not re-used, we can safely reassign all instances of an ID,
  // save for the default -1 id, without much thought.
  int fromId = (*arr)[idx].circuitId;
  if (fromId == -1) {
    (*arr)[idx].circuitId = circuitId;
    return;
  }

  foreach (ref Box b; *arr) {
    if (b.circuitId == fromId) b.circuitId = circuitId;
  }
}

ulong distanceSquared(ulong[3] box1, ulong[3] box2) {
  return pow(box1[0] - box2[0], 2) + pow(box1[1] - box2[1], 2) + pow(box1[2] - box2[2], 2);
}