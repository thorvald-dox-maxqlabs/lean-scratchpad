# Odd row of lamps: proof sketch

Interpret the two lamps without buttons as the two endpoints of the row.
Let the number of lamps be `n = 2m + 1`, and number them from 1 to n.
Initially only lamp k is on. We prove that all lamps can be lit exactly when
`k = m + 1`.

## Key idea: prefix parities turn button presses into swaps

Write `x_i = 1` if lamp i is on and `x_i = 0` otherwise. Define

`p_0 = 0`, and `p_j = (x_1 + ... + x_j) mod 2` for `1 <= j <= n`.

These prefix parities determine the lamps uniquely:

`x_i = (p_{i-1} + p_i) mod 2`.

Consider an effective press at an interior lamp i, where `2 <= i <= n-1`.
It toggles `x_{i-1}` and `x_{i+1}`. Therefore:

- Prefixes ending before i-1 contain neither toggled lamp and do not change.
- The two parities `p_{i-1}` and `p_i` each toggle.
- Prefixes ending at or after i+1 contain both toggled lamps and do not change.

The press is effective precisely when `x_i = 1`, equivalently when
`p_{i-1} != p_i`. Toggling two unequal bits simply swaps them.

Thus the puzzle is exactly the problem of rearranging the binary word
`p_1, ..., p_{n-1}` by swapping adjacent unequal entries. Every such swap
is a legal effective button press. The boundary parities `p_0` and `p_n`
remain fixed.

## Necessity

The number of ones among `p_1, ..., p_{n-1}` is invariant.
Pressing an unlit lamp does nothing, so also preserves this number.

When only lamp k is on, the prefix parities are zero before k and one from
k onward. Hence the invariant initially equals `n-k`.

When every lamp is on, `p_j` is 1 for odd j and 0 for even j. Among the
`n-1 = 2m` interior prefix parities, exactly m are one.
Consequently, reaching this state requires

`n-k = m`, hence `k = m+1`.

## Sufficiency

Suppose `k = m+1`. The initial interior parity word consists of m zeros
followed by m ones. The desired word is `1, 0, 1, 0, ..., 1, 0`, which
has the same numbers of zeros and ones.

Any binary word can be transformed into any other with the same number of
ones by adjacent swaps of unequal bits. Constructively, fix the positions
from left to right. If the current position has the wrong bit, find the
nearest occurrence of the required bit to its right and move it left by
successive swaps. Such an occurrence exists because the remaining counts
match. By choosing the nearest occurrence, every bit it crosses is the
opposite bit, so each swap is legal. Earlier fixed positions stay fixed.

Apply this procedure to the two parity words above. Each swap corresponds
to pressing an interior lamp that is currently on. Moreover, `p_0 = 0`
and `p_n = 1` agree in the initial and desired states, since both states
have an odd number of lit lamps. Thus all prefix parities reach their
desired values, and the reconstruction formula shows that every lamp is on.

For `n = 1`, the sole lamp is the middle lamp and is already on, so the
claim also holds without any presses.

Therefore all lamps can be lit if and only if the initially lit lamp is
the middle lamp.

## Lean 4 formalization

The checked proof is in [LeanScratchpad/Lamps.lean](../LeanScratchpad/Lamps.lean).
Its main result, `LeanScratchpad.Lamps.lamps_theorem_one_based`, states that
for `1 <= k <= 2*m+1`, the row with only lamp k on can reach the all-on row
if and only if `k = m+1`.

`Step` models an actual effective button press on three consecutive lamps:
`a, true, c` becomes `!a, true, !c`, with arbitrary unchanged lamps before
and after. `Reachable` means a finite sequence of these presses, allowing
zero presses. Presses at off lamps can be omitted because they do nothing.

The formal proof follows the sketch. For convenience, its invariant counts
all prefix parities, including the final one, so the initial and final
counts are respectively `n-k+1` and `m+1`. The final parity stays true.
Sufficiency uses `List.Perm`, whose adjacent swaps are proved to correspond
to legal lamp presses. There are no `sorry` placeholders or added axioms.

Check the file with `lake env lean LeanScratchpad/Lamps.lean`, or check the
whole project with `lake build`.
