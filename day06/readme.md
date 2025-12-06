# Advent of Code 2025 Day 6 Parts 1 & 2

https://adventofcode.com/2025/day/6

I am very glad cephalopods learn cummutative operations before order-dependant
ones.

This one I really didn't want to merge the part 1 & 2 solutions, so they are
routed in the main function based on a bool.

For part 1, it was a matter of parsing the numbers into a 2 dimensional table,
and if it happened to be an operation, it would calculate that. This means, in
theory, you could have staggered input:

```
456 124
 79  35
  9   *
  +
```

and it would work, though the answers would be a little jumbled and you would
need some kind of no-op for blank cells.

Part 2, I calculate start & end indexes based on the distance between the
operators on the bottom-most line. I treat the input text as a flattened grid
(don't mess with the whitespace at all!) and then parsed top-to-bottom instead
of left-to-right.

Though I have not tested this, parts 1 and 2 could be combined into a single
function, just changing which direction numbers are parsed in.
