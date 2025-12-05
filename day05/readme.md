# Advent of Code 2025 Day 5 Parts 1 & 2

https://adventofcode.com/2025/day/5

This one didn't require any build changes between parts 1 and 2, that is both
solutions can co-exist without interference.

Part 1 just consisted of checking if a number was in any one of several ranges.
The comparison function returns a signed integer so it could be used with a
binary search, though my attempt at a binary search did not go well.

Part 2 was trickier in that it wanted the number of *unique* valid ids a fresh
ingredient could possibly have. Many of the ranges overlap, by design of the
challenge. Luckily, sorting the ranges and moving `lo` up to the highest `hi`,
if able, solves this quickly.
