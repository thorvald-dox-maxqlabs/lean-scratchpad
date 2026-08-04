# Sudoku X green-area theorem

Number the rows, columns, and digits of a completed Sudoku grid from `0` to
`8`. A **Sudoku X** is a completed 9 × 9 grid such that every digit
occurs in each row, each column, each 3 × 3 block, and each of the two
main diagonals.

Define the green area to consist of the border of the centered 5 × 5
square, together with its center cell. In zero-based coordinates it is

```text
.........
.........
..#####..
..#...#..
..#.#.#..
..#...#..
..#####..
.........
.........
```

Equivalently, it contains:

* cells in rows `2` and `6` whose columns range from `2` through `6`;
* cells in columns `2` and `6` whose rows range from `2` through `6`; and
* the center cell `(4, 4)`.

## Theorem

In every Sudoku X, every digit occurs in the green area at least once. More
formally, for each digit `d`, there is a green cell `(row, column)` whose entry
is `d`.

The accompanying Lean file states this theorem but deliberately does not prove
it yet.
