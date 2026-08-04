# Exploding-dice game theorem

Let `a` and `b` be positive integers. Player A starts with `a` fair six-sided
dice and player B starts with `b` fair six-sided dice. For each initial die:

1. a result of 1, 2, 3, or 4 ends that die's chain and scores no success;
2. a result of 5 ends that die's chain and scores one success; and
3. a result of 6 scores one success and causes another die to be rolled, to
   which the same rules are applied recursively.

The score of a player is the total number of successes in all of that player's
chains. Almost surely every chain is finite; the Lean formulation represents
such a completed play directly as a nonempty finite list whose final roll is
not 6 and whose earlier rolls are all 6.

Player B wins exactly when Player A's score is less than Player B's score plus
one half. Since both actual scores are natural numbers, this is equivalent to
Player A's score being less than or equal to Player B's score. Thus ties are
awarded to Player B.

The statement deliberately does not yet assert or prove a formula for either
player's winning probability. It formalizes the game outcome and the
tie-breaking theorem; fairness becomes relevant when a probability law is put
on the valid finite outcomes.
