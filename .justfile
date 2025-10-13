PRE_COMMIT_SCRIPT := "\
#!/bin/sh
set -eu
just check-missing-references
just check-package-links
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

# Fails if any package link is unused or defined multiple times.
check-package-links:
  sh ./scripts/check_unused_package_links.sh paper.typ
  sh ./scripts/check_duplicate_package_link_definitions.sh paper.typ

# Initialize the pre-commit Git hook, overriding (potentially) existing one.
pre-commit:
  printf '%s' '{{PRE_COMMIT_SCRIPT}}' > .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit

# Due to web app limiting files to 20 MiB, (unpublished) Matryoshka package
# cannot be used (only locally). Hence the embedded slide page must be compiled
# separately. The smallest paper's PDF increase is from compiling example to
# PDF. Not using the latest version saves ~43.89 KiB for final PDF.
alias s := slide
alias sw := slide-watch

slide:
  typst compile --ignore-system-fonts --font-path fonts ./examples/slide/slide.typ

slide-watch:
  typst watch --ignore-system-fonts --font-path fonts ./examples/slide/slide.typ

# Produce code to embed all the source code in the paper to make it reproducible.
# Requires fd, wl-clipboard packages.
pdf-attach:
  #!/bin/sh
  set -eu
  files=$(fd -e typ -e latex -e csv -e dot -e yaml -e toml -e jpg -e png)
  sorted=$(
    echo "$files" | grep / | sort -f
    echo "$files" | grep -v / | sort -f
  )
  lines=$(echo "$sorted" | sed 's/.*/  "&",/')
  cat << EOF | wl-copy -n
  #let files = (
  $lines
  )
  #files.map(pdf.attach).join()
  EOF

# Check for "'" contractions.
# Requires rg package.
check-contractions:
  rg -o "\\w+'[st]"
