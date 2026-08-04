import Mathlib

namespace LeanScratchpad.SudokuX

/-- A completed Sudoku grid. Rows, columns, and digits are numbered `0` to `8`. -/
abbrev Board := Fin 9 → Fin 9 → Fin 9

/-- Reflection about the center, used to index the anti-diagonal. -/
def reverseIndex (i : Fin 9) : Fin 9 :=
  ⟨8 - i.val, by omega⟩

/-- A Sudoku X: every digit occurs in every row, column, `3 × 3` block, and
both main diagonals. -/
structure CompletedSudokuX where
  board : Board
  rowComplete : ∀ row digit, ∃ column, board row column = digit
  columnComplete : ∀ column digit, ∃ row, board row column = digit
  blockComplete : ∀ blockRow blockColumn : Fin 3, ∀ digit,
    ∃ row column,
      row.val / 3 = blockRow.val ∧
      column.val / 3 = blockColumn.val ∧
      board row column = digit
  mainDiagonalComplete : ∀ digit, ∃ i, board i i = digit
  antiDiagonalComplete : ∀ digit, ∃ i, board i (reverseIndex i) = digit

/-- The border of the centered `5 × 5` square, together with the center cell. -/
def IsGreen (row column : Fin 9) : Prop :=
  ((row.val = 2 ∨ row.val = 6) ∧ 2 ≤ column.val ∧ column.val ≤ 6) ∨
  ((column.val = 2 ∨ column.val = 6) ∧ 2 ≤ row.val ∧ row.val ≤ 6) ∨
  (row.val = 4 ∧ column.val = 4)

/-- Every digit occurs at least once on the marked border or at its center.

The proof is intentionally deferred. -/
theorem green_area_contains_every_digit (sudoku : CompletedSudokuX) :
    ∀ digit : Fin 9, ∃ row column : Fin 9,
      IsGreen row column ∧ sudoku.board row column = digit := by
  sorry

end LeanScratchpad.SudokuX
