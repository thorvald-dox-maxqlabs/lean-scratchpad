import Mathlib.Data.List.Perm.Basic
import Mathlib.Logic.Relation

/-!
# The odd row of lamps

`true` means on. An effective button press replaces three consecutive lamps
`a, true, c` by `!a, true, !c`. Thus only interior lamps have buttons.
Presses at unlit lamps do nothing and may be omitted from a finite sequence.
-/

namespace LeanScratchpad.Lamps

/-- A single effective press, with arbitrary lamps before and after it. -/
inductive Step : List Bool → List Bool → Prop
  | press (pre post : List Bool) (a c : Bool) :
      Step (pre ++ a :: true :: c :: post)
        (pre ++ (!a) :: true :: (!c) :: post)

/-- Reachability by a finite, possibly empty sequence of effective presses. -/
abbrev Reachable := Relation.ReflTransGen Step

/-- Prefix parities, with incoming parity `b`. -/
def encode (b : Bool) : List Bool → List Bool
  | [] => []
  | x :: xs => (b ^^ x) :: encode (b ^^ x) xs

/-- Recover lamps from interior prefix parities; the final parity is true. -/
def decode (b : Bool) : List Bool → List Bool
  | [] => [b ^^ true]
  | a :: as => (b ^^ a) :: decode a as

lemma step_invariant {xs ys : List Bool} (h : Step xs ys) (b : Bool) :
    (encode b xs).count true = (encode b ys).count true := by
  cases h with
  | press pre post a c =>
    induction pre generalizing b with
    | nil => cases b <;> cases a <;> cases c <;> simp [encode]
    | cons x pre ih =>
      simp only [List.cons_append, encode, List.count_cons]
      rw [ih]

lemma reachable_invariant {xs ys : List Bool} (h : Reachable xs ys) :
    (encode false xs).count true = (encode false ys).count true := by
  induction h with
  | refl => rfl
  | tail h s ih => exact ih.trans (step_invariant s false)

lemma reachable_cons (x : Bool) {xs ys : List Bool} (h : Reachable xs ys) :
    Reachable (x :: xs) (x :: ys) := by
  induction h with
  | refl => exact .refl
  | tail h s ih =>
    apply ih.tail
    cases s with
    | press pre post a c => exact Step.press (x :: pre) post a c

lemma decode_swap (b a c : Bool) (tail : List Bool) :
    Reachable (decode b (a :: c :: tail)) (decode b (c :: a :: tail)) := by
  cases tail with
  | nil =>
    cases b <;> cases a <;> cases c <;> simp only [decode, Bool.xor_false,
      Bool.false_xor, Bool.xor_true, Bool.true_xor, Bool.not_false, Bool.not_true]
    all_goals first | exact .refl | exact .single (Step.press [] [] _ _)
  | cons d tail =>
    cases b <;> cases a <;> cases c <;> cases d <;>
      simp only [decode, Bool.xor_false, Bool.false_xor, Bool.xor_true,
        Bool.true_xor, Bool.not_false, Bool.not_true]
    all_goals first | exact .refl | exact .single (Step.press [] _ _ _)

/-- Adjacent swaps of prefix parities are realized by legal lamp presses. -/
lemma perm_reachable {p q : List Bool} (h : p.Perm q) (b : Bool) :
    Reachable (decode b p) (decode b q) := by
  induction h generalizing b with
  | nil => exact .refl
  | cons a h ih => exact reachable_cons (b ^^ a) (ih a)
  | swap a c tail => exact decode_swap b c a tail
  | trans h₁ h₂ ih₁ ih₂ => exact (ih₁ b).trans (ih₂ b)

/-- Interior prefix parities of the all-on row of length `2*m+1`. -/
def alternating : ℕ → List Bool
  | 0 => []
  | m + 1 => true :: false :: alternating m

lemma alternating_count (m : ℕ) (b : Bool) :
    (alternating m).count b = m := by
  induction m with
  | zero => simp [alternating]
  | succ m ih => cases b <;> simp [alternating, ih, Nat.add_comm]

lemma middle_parities_perm (m : ℕ) :
    (List.replicate m false ++ List.replicate m true).Perm (alternating m) := by
  apply List.perm_iff_count.mpr
  intro b
  cases b <;> simp [alternating_count, List.count_replicate]

lemma decode_true_replicate (r : ℕ) :
    decode true (List.replicate r true) = List.replicate (r + 1) false := by
  induction r with
  | zero => simp [decode]
  | succ r ih => simp [List.replicate_succ, decode, ih]

lemma decode_initial (l r : ℕ) :
    decode false (List.replicate l false ++ List.replicate r true) =
      List.replicate l false ++ true :: List.replicate r false := by
  induction l with
  | zero =>
    cases r with
    | zero => simp [decode]
    | succ r => simp [List.replicate_succ, decode, decode_true_replicate]
  | succ l ih => simp [List.replicate_succ, decode, ih]

lemma decode_alternating (m : ℕ) :
    decode false (alternating m) = List.replicate (2 * m + 1) true := by
  induction m with
  | zero => simp [alternating, decode]
  | succ m ih =>
    simpa [alternating, decode, Nat.mul_succ, Nat.add_assoc, List.replicate_succ]
      using congrArg (fun xs => true :: true :: xs) ih

lemma encode_false_replicate (b : Bool) (r : ℕ) :
    encode b (List.replicate r false) = List.replicate r b := by
  induction r with
  | zero => simp [encode]
  | succ r ih => simp [List.replicate_succ, encode, ih]

lemma initial_invariant (l r : ℕ) :
    (encode false (List.replicate l false ++ true :: List.replicate r false)).count
      true = r + 1 := by
  induction l with
  | zero => simp [encode, encode_false_replicate]
  | succ l ih => simp [List.replicate_succ, encode, ih]

lemma all_on_invariant (m : ℕ) :
    (encode false (List.replicate (2 * m + 1) true)).count true = m + 1 := by
  induction m with
  | zero => simp [encode]
  | succ m ih =>
    simpa [Nat.mul_succ, Nat.add_assoc, List.replicate_succ, encode]
      using ih

/-- An odd row can be fully lit from one lit lamp exactly when it is the
middle lamp. Positions are zero-based: `k` off lamps precede the lit lamp. -/
theorem lamps_theorem (m k : ℕ) (hk : k < 2 * m + 1) :
    Reachable (List.replicate k false ++ true :: List.replicate (2 * m - k) false)
      (List.replicate (2 * m + 1) true) ↔ k = m := by
  constructor
  · intro h
    have hi := reachable_invariant h
    rw [initial_invariant, all_on_invariant] at hi
    omega
  · intro h
    subst k
    have hm : 2 * m - m = m := by omega
    rw [hm]
    have h := perm_reachable (middle_parities_perm m) false
    simpa only [decode_initial, decode_alternating] using h

/-- The same result with lamps numbered from 1 to `2*m+1`. -/
theorem lamps_theorem_one_based (m k : ℕ) (hk₀ : 1 ≤ k) (hk₁ : k ≤ 2 * m + 1) :
    Reachable (List.replicate (k - 1) false ++
      true :: List.replicate (2 * m + 1 - k) false)
      (List.replicate (2 * m + 1) true) ↔ k = m + 1 := by
  have hk : k - 1 < 2 * m + 1 := by omega
  have hr : 2 * m - (k - 1) = 2 * m + 1 - k := by omega
  rw [← hr, lamps_theorem m (k - 1) hk]
  omega

end LeanScratchpad.Lamps
