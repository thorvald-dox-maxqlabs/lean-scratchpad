# Lean Scratchpad

A minimal Lean 4 project configured with [mathlib](https://github.com/leanprover-community/mathlib4).

## Prerequisites

Install Lean's version manager, `elan`, by following the
[Lean installation instructions](https://lean-lang.org/lean4/doc/quickstart.html).
The included `lean-toolchain` file makes `elan` select the correct Lean version
for this project automatically.

## Get started

Run the setup script in a fresh checkout:

```sh
./scripts/setup-lean.sh
```

It installs `elan` when necessary, selects the Lean version pinned by
`lean-toolchain`, fetches mathlib and its precompiled cache, and builds every
project module. The script is non-interactive and idempotent, so it can also be
used to prepare an automated agent or development container.

For a Codex cloud environment, use `./scripts/setup-lean.sh` as the environment's
setup script. Codex provides `CODEX_ENV_PERSIST` during setup; the script records
elan's `PATH` entry there so `lean` and `lake` remain available after setup, when
internet access is disabled. All compiler, dependency, and cache downloads are
completed before the initial build finishes.

Add experiments to `LeanScratchpad/Basic.lean`, or create more modules beneath
`LeanScratchpad/` and import them from `LeanScratchpad.lean`.

The example theorem in `LeanScratchpad/Basic.lean` imports mathlib and uses its
`ring` tactic, so a successful build verifies that the dependency is available.

## Check proofs live

After setup, run Lean against an individual file for fast feedback:

```sh
lake env lean LeanScratchpad/Basic.lean
```

Use `lake build` to check all imported project modules. If `lake` is not found
in a newly opened shell, add elan to that shell's path with
`export PATH="$HOME/.elan/bin:$PATH"`.

## Build the LaTeX proofs

On a Debian- or Ubuntu-based system, install the TeX Live packages used by the
mathematical write-ups with the idempotent setup script:

```sh
./scripts/setup-tex.sh
```

Then compile a proof from the repository root. For example:

```sh
pdflatex -output-directory=/tmp LeanScratchpad/SimpleDice.tex
```

Writing the generated PDF and auxiliary files to `/tmp` keeps the source tree
clean; the resulting proof is `/tmp/SimpleDice.pdf`.
