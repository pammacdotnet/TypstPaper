PRE_COMMIT_SCRIPT := "\
#!/bin/sh
just check-missing-references\
"

alias c := compile
alias w := watch
alias init := pre-commit

# Automatically use local (Git version) binary over global (release version)
# one, if present. Typst's Git version (starting from af2253ba1) is REQUIRED
# for slide example that uses PDF image. The web app already has such version.
# Version used is 16758e7da, which should be near identical to web app's one.
typst := shell("if [ -f typst ]; then echo ./typst; else echo typst; fi")

compile: slide
  {{typst}} compile --ignore-system-fonts --font-path fonts paper.typ

watch: slide
  {{typst}} watch --ignore-system-fonts --font-path fonts paper.typ

# Fails if any figure or table is not referenced at least once.
# Requires poppler-utils package.
check-missing-references:
  pdftotext paper.pdf && sh ./scripts/check_missing_references.sh paper.txt

# Initialize the pre-commit Git hook, overriding (potentially) existing one.
pre-commit:
  echo '{{PRE_COMMIT_SCRIPT}}' > .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit

# Due to web app limiting files to 20 MiB, (unpublished) Matryoshka package
# cannot be used (only locally). Hence the embedded slide page must be compiled
# separately. The smallest paper's PDF increase is from compiling example to
# PDF. Not using the latest version saves ~43.89 KiB for final PDF.
alias s := slide
alias sw := slide-watch

slide:
  typst compile --ignore-system-fonts --font-path fonts "slide example/example.typ"

slide-watch:
  typst watch --ignore-system-fonts --font-path fonts "slide example/example.typ"
