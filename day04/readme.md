# Advent of Code 2025 Day 4 Parts 1 & 2

https://adventofcode.com/2025/day/4

Here I used DLang's parallel `foreach` loop feature to automatically parallelize
the code, allowing it to run much faster than single-threaded.

Today's puzzle was solved via cellular automata. It would be interesting to
revisit this problem with compute shaders, or some other way of offloading work
onto the GPU.

Part 2 was just removing each paper stack and re-running the algorithm until
no more paper was left. The biggest challenge was rewriting my parallel code to
modify a single variable (the compiler seemed to keep converting `char[]` to
`string`), but using a weird mix of pointers and `shared` variables, it now
works.
