PRE_COMMIT_SCRIPT := "\
#!/bin/sh
set -eu
just format --check
just check-missing-references
just check-package-links
"

alias c := compile
alias pdf := compile-from-pdf
alias w := watch
alias init := pre-commit

# Automatically use local (Git version) binary over global (release version)
# one, if present. Typst's version 0.14.0-rc1 or above is REQUIRED. The web app
# already has such version.
typst := shell("if [ -f typst ]; then echo ./typst; else echo typst; fi")

compile: slide
  {{typst}} compile --ignore-system-fonts --font-path fonts paper.typ

compile-from-pdf paper="paper.pdf":
  pdfdetach -list '{{paper}}' | sed -E 's/^[0-9]+: //' | xargs -I{} dirname '{}' | grep -vxF . | sort | uniq | xargs -I{} mkdir -p '{}'
  pdfdetach -saveall '{{paper}}'
  just compile

watch: slide
  {{typst}} watch --ignore-system-fonts --font-path fonts paper.typ

# Spaces and quotes in file names are not supported.
# These files use special formatting to make examples shorter and more readable.
do-not-format := "
atom.typ
cetz-plot.typ
unicode_math.typ
"

alias f := format
format mode="--inplace":
  find examples \
    -name "*.typ" \
    $(printf "! -name %s " $(echo "{{do-not-format}}")) \
    -exec typstyle '{{mode}}' '{}' \;
  typstyle '{{mode}}' *.typ
  typstyle '{{mode}}' --wrap-text assets

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
  {{typst}} compile --ignore-system-fonts --font-path fonts ./examples/slide/slide.typ

slide-watch:
  {{typst}} watch --ignore-system-fonts --font-path fonts ./examples/slide/slide.typ

# Produce code to embed all the source code in the paper to make it reproducible.
# Requires fd, wl-clipboard packages.
pdf-attach:
  #!/bin/sh
  set -eu
  files=$(fd -e md -e typ -e latex -e csv -e dot -e yaml -e toml -e jpg -e png)
  sorted=$(
    echo "$files" | grep / | sort -f
    echo ".justfile"
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
