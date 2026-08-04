#!/usr/bin/env bash
set -euo pipefail

# Install elan without editing shell startup files.  Keeping this script
# non-interactive makes it suitable for fresh development and agent containers.
if ! command -v elan >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1 && [[ $(id -u) -eq 0 ]]; then
    apt-get update
    apt-get install -y elan
  else
    curl --proto '=https' --tlsv1.2 -sSf \
      https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh \
      | sh -s -- -y --no-modify-path
  fi
fi

elan_bin_dir=$(dirname "$(command -v elan)")
export PATH="$elan_bin_dir:$PATH"

# Codex cloud runs setup in a separate shell and disables internet access
# afterwards.  CODEX_ENV_PERSIST is sourced for subsequent agent shells, so
# preserve elan's location there rather than relying on this process's export.
if [[ -n ${CODEX_ENV_PERSIST:-} ]]; then
  path_export="export PATH=$(printf '%q' "$elan_bin_dir"):\$PATH"
  if ! grep -Fqx "$path_export" "$CODEX_ENV_PERSIST" 2>/dev/null; then
    printf '%s\n' "$path_export" >> "$CODEX_ENV_PERSIST"
  fi
fi

# lean-toolchain pins Lean, while lake-manifest.json pins all dependencies.
lake update
lake exe cache get
