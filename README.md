# Typst: a modern typesetting engine for science

## Compilation

- Minimal Typst version required: 0.14.0-rc1
- Typst version used: 0.14.2

### From repository

```sh
git clone https://github.com/pammacdotnet/TypstPaper
cd TypstPaper
just
```

### From PDF (Attached files)

You need to (ideally) copy the `fonts` directory from
https://github.com/pammacdotnet/TypstPaper. Technically, if all the listed
fonts are already installed on the machine, this is not required, but font
version and therefore output can differ.

To make it seamless, copy the `.justfile` from
https://github.com/pammacdotnet/TypstPaper as well.

```sh
# just pdf:
paper=paper.pdf
pdfdetach -list "$paper" | sed -E 's/^[0-9]+: //' | xargs -I{} dirname '{}' | grep -vxF . | sort | uniq | xargs -I{} mkdir -p '{}'
pdfdetach -saveall "$paper"
just compile
```

Use `just pdf` from the `.justfile`:

```sh
mkdir source
ln -sr fonts source # If required fonts are not installed globally.
ln -sr typst source # If required version is not installed globally.
cd source
just pdf # paper.pdf is the default file name.
```

Or its content directly:

```sh
mkdir source
ln -sr fonts source # If required fonts are not installed globally.
ln -sr typst source # If required version is not installed globally.
cd source
paper=paper.pdf
pdfdetach -list "$paper" | sed -E 's/^[0-9]+: //' | xargs -I{} dirname '{}' | grep -vxF . | sort | uniq | xargs -I{} mkdir -p '{}'
pdfdetach -saveall "$paper"
just compile
```
