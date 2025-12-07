# Advent of Code 2025 Day 7 Parts 1 & 2

https://adventofcode.com/2025/day/7

I am pretty sure I solved this one in linear time, because each character in
the input is only iterated once, though it is split between line/column for my
own brain.

At first, I solved part 1 with just a boolean table, and that worked pretty
well.

With part 2, my first thought was "heck, this needs recursion". My second
thought was "wait, can I make this iterative?" and my third thought was "wait,
I don't need to do any of that" (these thoughts were about 20 minutes apart from
each other) and I could just keep track of how many timelines exist on any given
position, and split is just adding the possible timelines to either side of the
splitter!

Because both parts can be done at the same time, there is not a flag to switch
to part 2.
