# Ordinary-dice version

Let Player A roll `a` fair six-sided dice and Player B roll `b`. Dice do not
explode, and only a roll of 6 is a success. Each player's score is the number
of successes, and ties go to B, just as in the exploding-dice game.

For all positive `a` and `b`, the probability that B wins is not `1/2`.

The proof counts elementary die outcomes. Exactly `k` successes among `n` dice
occur in `choose(n, k) * 5^(n-k)` outcomes. Modulo 5, this count is zero unless
every die succeeds, when it is one. Consequently, the number of B-winning
outcomes is zero modulo 5 when `a > b`, and one modulo 5 when `a ≤ b`.

If the game were fair, its winning count would be half of `6^(a+b)`, namely
`3 * 6^(a+b-1)`. This is three modulo 5, contradicting either possible residue
of the actual winning count.
