#!/usr/bin/env bash
set -euo pipefail

# Install the small TeX Live distribution needed by the documents in this
# repository.  Avoid reinstalling it when a suitable LaTeX engine is already
# available, so the script is safe to run more than once.
if command -v pdflatex >/dev/null 2>&1; then
  printf 'pdflatex is already installed: %s\n' "$(command -v pdflatex)"
  exit 0
fi

if ! command -v apt-get >/dev/null 2>&1; then
  printf '%s\n' \
    'Unable to install TeX automatically: this script requires apt-get.' \
    'Install TeX Live with the latex-base and latex-recommended collections.' >&2
  exit 1
fi

if [[ $(id -u) -eq 0 ]]; then
  apt=(apt-get)
elif command -v sudo >/dev/null 2>&1; then
  apt=(sudo apt-get)
else
  printf '%s\n' \
    'Unable to install TeX automatically: root access or sudo is required.' >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive
"${apt[@]}" update
"${apt[@]}" install -y --no-install-recommends \
  texlive-latex-base \
  texlive-latex-recommended

pdflatex --version | head -n 1
