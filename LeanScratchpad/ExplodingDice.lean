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

/-- The probability that one initial die-chain produces exactly `successes`
successes.  Zero successes means rolling `1`--`4`.  For a positive number `k`,
the chain is either `k - 1` sixes followed by a five, or `k` sixes followed by
`1`--`4`.  Thus exploding sixes are encoded by the powers of six here. -/
def singleChainProbability (successes : ℕ) : ℝ :=
  if successes = 0 then 2 / 3 else 10 / 6 ^ (successes + 1)

/-- The probability of a given total score from `dice` independent initial
dice.  This is the convolution of the exploding-chain distribution. -/
def scoreProbability : ℕ → ℕ → ℝ
  | 0, score => if score = 0 then 1 else 0
  | dice + 1, score =>
      ∑ chainScore ∈ Finset.range (score + 1),
        singleChainProbability chainScore *
          scoreProbability dice (score - chainScore)

/-- The probability that B wins.  The inner sum includes scores equal to A's,
so it implements the rule that B wins ties. -/
noncomputable def playerBWinProbability (a b : ℕ) : ℝ :=
  ∑' scoreA : ℕ, scoreProbability a scoreA *
    ∑' scoreB : ℕ,
      if scoreA ≤ scoreB then scoreProbability b scoreB else 0

/-- No positive choices of initial dice make the game fair: B's probability of
winning is never exactly one half.

The proof is intentionally deferred. -/
theorem no_fair_positive_configuration :
    ∀ a b : ℕ, 0 < a → 0 < b →
      playerBWinProbability a b ≠ (1 : ℝ) / 2 := by
  sorry

end LeanScratchpad.ExplodingDice
