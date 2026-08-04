import Mathlib

namespace LeanScratchpad.ExplodingDice

/-- A completed exploding-die chain. Faces use the usual numbers `1` through
`6`; every roll before the final roll is a `6`, and the final roll is not. -/
structure DieChain where
  rolls : List ℕ
  nonempty : rolls ≠ []
  faces : ∀ face ∈ rolls, 1 ≤ face ∧ face ≤ 6
  exploding : ∀ face ∈ rolls.dropLast, face = 6
  stopped : rolls.getLast? ≠ some 6

/-- The successes in one chain: every `5` and every `6` counts. -/
def DieChain.successes (chain : DieChain) : ℕ :=
  (chain.rolls.filter fun face => 5 ≤ face).length

/-- A completed play consists of one exploding chain for each initial die. -/
structure Outcome (a b : ℕ) where
  playerA : Fin a → DieChain
  playerB : Fin b → DieChain

/-- Total successes obtained by a family of initial dice. -/
def totalSuccesses {n : ℕ} (dice : Fin n → DieChain) : ℕ :=
  ∑ i, (dice i).successes

def Outcome.scoreA {a b : ℕ} (outcome : Outcome a b) : ℕ :=
  totalSuccesses outcome.playerA

def Outcome.scoreB {a b : ℕ} (outcome : Outcome a b) : ℕ :=
  totalSuccesses outcome.playerB

/-- Ties go to Player B. -/
def playerBWins {a b : ℕ} (outcome : Outcome a b) : Prop :=
  outcome.scoreA ≤ outcome.scoreB

/-- Giving B half a success implements precisely the stated tie-break rule.

The positivity assumptions record that both players start with at least one
die. The proof is intentionally deferred. -/
theorem playerB_half_success_theorem
    (a b : ℕ) (ha : 0 < a) (hb : 0 < b) (outcome : Outcome a b) :
    playerBWins outcome ↔
      (outcome.scoreA : ℚ) < (outcome.scoreB : ℚ) + 1 / 2 := by
  sorry

end LeanScratchpad.ExplodingDice
