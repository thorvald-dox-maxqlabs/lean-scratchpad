import Mathlib

namespace LeanScratchpad.SimpleDice

/-- The number of equally likely ways for `n` ordinary six-sided dice to have
exactly `k` successes, when only a six is a success. -/
def scoreCount (n k : ℕ) : ℕ :=
  n.choose k * 5 ^ (n - k)

/-- The number of outcomes in which B's score is at least A's score.  As in
the exploding-dice game, ties go to B. -/
def playerBWinningCount (a b : ℕ) : ℕ :=
  ∑ i ∈ Finset.range (a + 1), ∑ j ∈ Finset.Icc i b,
    scoreCount a i * scoreCount b j

/-- The probability that B wins in the non-exploding game. -/
def playerBWinProbability (a b : ℕ) : ℚ :=
  playerBWinningCount a b / 6 ^ (a + b)

private lemma scoreCount_mod_five (n k : ℕ) :
    (scoreCount n k : ZMod 5) = if k = n then 1 else 0 := by
  by_cases hkn : k = n
  · subst k
    simp [scoreCount]
  · simp only [scoreCount, Nat.cast_mul, Nat.cast_pow]
    by_cases hlt : k < n
    · have hpos : 0 < n - k := Nat.sub_pos_of_lt hlt
      simp [hkn, hpos]
    · have hnk : n < k := by omega
      simp [hkn, Nat.choose_eq_zero_of_lt hnk]

private lemma playerBWinningCount_mod_five (a b : ℕ) :
    (playerBWinningCount a b : ZMod 5) = if a ≤ b then 1 else 0 := by
  simp only [playerBWinningCount, Nat.cast_sum, Nat.cast_mul,
    scoreCount_mod_five]
  by_cases hab : a ≤ b
  · simp [hab]
  · simp [hab]

/-- With positive numbers of ordinary dice, and with only six counting as a
success, no choice of dice counts makes the game fair. -/
theorem no_fair_positive_configuration (a b : ℕ) (ha : 0 < a) (hb : 0 < b) :
    playerBWinProbability a b ≠ (1 : ℚ) / 2 := by
  intro hfair
  have hpow : (6 : ℚ) ^ (a + b) ≠ 0 := by positivity
  have hcount : (2 * playerBWinningCount a b : ℚ) = 6 ^ (a + b) := by
    rw [playerBWinProbability, div_eq_iff hpow] at hfair
    linarith
  have hnat : 2 * playerBWinningCount a b = 6 ^ (a + b) := by
    exact_mod_cast hcount
  have hsum : 0 < a + b := Nat.add_pos_left ha b
  have hexp : 6 ^ (a + b) = 6 * 6 ^ (a + b - 1) := by
    conv_lhs => rw [show a + b = (a + b - 1) + 1 by omega, pow_succ]
    omega
  have hhalf : playerBWinningCount a b = 3 * 6 ^ (a + b - 1) := by
    rw [hexp] at hnat
    omega
  have hmod := congrArg (fun n : ℕ => (n : ZMod 5)) hhalf
  rw [playerBWinningCount_mod_five] at hmod
  norm_num at hmod
  split at hmod <;> contradiction

end LeanScratchpad.SimpleDice
