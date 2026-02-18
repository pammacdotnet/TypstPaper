PRE_COMMIT_SCRIPT := "\
#!/bin/sh
set -eu
just format --check
just check-missing-references
just check-package-links
"

export TYPST_IGNORE_SYSTEM_FONTS := "true"
export TYPST_FONT_PATHS := "fonts"
export TYPST_FEATURES := "a11y-extras"

# Automatically use local (Git version) binary over global (release version)
# one, if present. Typst's version 0.14.0-rc1 or above is REQUIRED. The web app
# already has such version.
typst := shell("if [ -f typst ]; then echo ./typst; else echo typst; fi")

alias c := compile
compile *args: slide ieee mdpi
  {{typst}} compile {{args}} paper.typ

alias pdf := compile-from-pdf
compile-from-pdf paper="paper.pdf":
  pdfdetach -list '{{paper}}' | sed -E 's/^[0-9]+: //' | xargs -I{} dirname '{}' | grep -vxF . | sort | uniq | xargs -I{} mkdir -p '{}'
  pdfdetach -saveall '{{paper}}'
  just compile

alias w := watch
watch: slide ieee mdpi
  {{typst}} watch paper.typ

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

alias init := pre-commit
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

slide *args:
  {{typst}} compile {{args}} ./examples/slide/slide.typ

slide-watch:
  {{typst}} watch ./examples/slide/slide.typ

ieee *args:
  {{typst}} compile {{args}} ./examples/ieee/main.typ

mdpi *args:
  {{typst}} compile {{args}} ./examples/mdpi/main.typ

additional-files := "
.justfile
README.md
assets/vscodium_screenshot_source/pronunciation/main.typ
"

# Produce code to embed all the source code in the paper to make it reproducible.
# Requires: numfmt
pdf-attach:
  #!/bin/sh
  set -eu
  command -v numfmt > /dev/null
  get_size() { just compile && du -b paper.pdf | cut -f 1; }
  format() { numfmt --to=iec-i --suffix=B --format='%.2f' --unit-separator=' '; }
  printf '' > files.typ
  without_files=$(get_size)
  deps=$(for recipe in compile slide ieee mdpi; do just "$recipe" --deps -; done)
  files=$(echo "$deps" | grep -Eo '"[^"]+"' | grep -ve '\.pdf"$' -e '^"/' -e '"inputs"')
  additional_files=$(echo '{{additional-files}}' | sed '/^$/d;s/.*/"&"/')
  lines=$({ echo "$files" && echo "$additional_files"; } | sort | sed 's/.*/  &,/')
  cat << EOF > files.typ
  #let files = (
  $lines
  )
  #files.map(pdf.attach.with(description: "source file")).join()
  EOF
  with_files=$(get_size)
  diff=$(echo "$((with_files - without_files))" | format)
  line=$(sed -n '/#include "files.typ"/=' paper.typ)
  sed -i "$((line - 1))c// +$diff" paper.typ

# Check for "'" contractions.
# Requires rg package.
check-contractions:
  rg -o "\\w+'[st]"
