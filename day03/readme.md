# Advent of Code 2025 Day 3 Parts 1 & 2

https://adventofcode.com/2025/day/3

This solution works for both parts 1 & 2, just adjusting the number of batteries
searched for.

I tried to write this algorithm to avoid recalculating numbers that would never
change, though I probably missed a few spots.

Strangely enough, all my attempts at pruning the algorithm when its options are
limited have increased the run times (like if only one digit can be used, skip
the comparisons), perhaps the compiler is a step ahead of me. I added it as
something that can be enabled through conditional compilation.

(example number from `$ nix-shell -p sage --run "sage -c 'print(getrandbits(48))'"`)
```
Where ╰─╯ is range, ╨ is current index, ┸ is current best
With 12 batteries
191175121212306 (15 chars)
╙──╯            [100000000000]
┖╨─╯            [900000000000]
╰┸╨╯            [900000000000]
╰┸─╜            [900000000000]
191175121212306
  ╙─╯           [910000000000]
  ┖╨╯           [910000000000]
  ┖─╜           [970000000000]
191175121212306
     ╨          [975000000000]
191175121212306
      ╨         [975100000000]
191175121212306
       ╨        [975120000000]
191175121212306
        ╨       [975121000000]
191175121212306
         ╨      [975121200000]
191175121212306
          ╨     [975121210000]
191175121212306
           ╨    [975121212000]
191175121212306
            ╨   [975121212300]
191175121212306
             ╨  [975121212300]
191175121212306
              ╨ [975121212306] ← Answer
```
Here, we minimize the comparisons and checks done by only considering the range
of values that could affect the digit.