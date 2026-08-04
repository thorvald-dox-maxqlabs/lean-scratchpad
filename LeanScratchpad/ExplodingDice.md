# Exploding-dice game theorem

Let `a` and `b` be positive integers. Player A starts with `a` fair six-sided
dice and player B starts with `b` fair six-sided dice. For each initial die:

1. a result of 1, 2, 3, or 4 ends that die's chain and scores no success;
2. a result of 5 ends that die's chain and scores one success; and
3. a result of 6 scores one success and causes another die to be rolled, to
   which the same rules are applied recursively.

The score of a player is the total number of successes in all of that player's
chains. Almost surely every chain is finite. The Lean formulation describes a
completed chain as a nonempty finite list whose final roll is not 6 and whose
earlier rolls are all 6.

The probability that one initial die produces zero successes is `2/3`. For
`k > 0`, the probability of exactly `k` successes is

```text
10 / 6^(k + 1).
```

Indeed, the chain is either `k - 1` sixes followed by a 5, or `k` sixes
followed by one of 1, 2, 3, or 4. This formula is where the recursive explosion
rule enters the probability model. The distribution for several initial dice
is obtained by convolution, and the probability that B wins sums over all
score pairs for which B's score is at least A's score. Equality is included
because ties go to B.

## Theorem

For every pair of positive integers `a` and `b`, the probability that Player B
wins is not `1/2`. In other words, there is no configuration of positive
numbers of starting dice for which the game is fair.

The Lean file states this theorem but deliberately does not prove it yet.
