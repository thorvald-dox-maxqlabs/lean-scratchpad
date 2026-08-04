# Lean Scratchpad

A minimal Lean 4 project configured with [mathlib](https://github.com/leanprover-community/mathlib4).

## Prerequisites

Install Lean's version manager, `elan`, by following the
[Lean installation instructions](https://lean-lang.org/lean4/doc/quickstart.html).
The included `lean-toolchain` file makes `elan` select the correct Lean version
for this project automatically.

## Get started

Fetch mathlib and its precompiled cache, then build the project:

```sh
lake update
lake exe cache get
lake build
```

Add experiments to `LeanScratchpad/Basic.lean`, or create more modules beneath
`LeanScratchpad/` and import them from `LeanScratchpad.lean`.

The example theorem in `LeanScratchpad/Basic.lean` imports mathlib and uses its
`ring` tactic, so a successful build verifies that the dependency is available.
