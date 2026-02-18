# Typst: A Modern Typesetting Engine for Science

## Compilation

To reproduce the paper, follow the steps provided below. Before proceeding, you
should install [`just`] command, otherwise you would have to manually run all
commands, defined in the recipes (scripts).

> [!NOTE]
> While it is possible to visually reproducible the paper in the web app, the
> checksum will not much the one compiled locally. See
> https://github.com/typst/typst/issues/7683#issuecomment-3761695024 for more
> details.

- Minimal Typst version required: 0.14.2 (by the [`ijimai`] template)
- Typst version used: 0.14.2

Pinned versions available (tags):

- [`first-submission`] (when the paper was initially submitted to the journal)
- [`second-submission`] (version after the first peer)
- [`final-submission`] (published preprint version that has a DOI)

### From Repository

```sh
git clone --branch final-submission https://github.com/pammacdotnet/TypstPaper
cd TypstPaper
just
```

### From PDF (Attached Files)

You need to copy the [`fonts`] directory from
https://github.com/pammacdotnet/TypstPaper. Technically, if all the listed
fonts are already installed on the machine, this is not required. However, the
font versions can differ, and therefore the output document can differ as well.
Additionally, recipes in the [`.justfile`] ignore system fonts, which means you
will need to adjust the commands before running them (via `just` or manually).

To make it seamless, copy the [`.justfile`] from
https://github.com/pammacdotnet/TypstPaper as well. Then, simply run:

```sh
just pdf
```

Here is the equivalent set of commands, if you want to compile without
additional `.justfile`:

```sh
paper=paper.pdf
pdfdetach -list "$paper" | sed -E 's/^[0-9]+: //' | xargs -I{} dirname '{}' | grep -vxF . | sort | uniq | xargs -I{} mkdir -p '{}'
pdfdetach -saveall "$paper"
just
```

Note that the attached to the PDF file `.justfile` will overwrite any existing
`.justfile` upon completion of the `pdfdetach -saveall` command.

[`ijimai`]: https://typst.app/universe/package/ijimai
[`first-submission`]: https://github.com/pammacdotnet/TypstPaper/tree/first-submission
[`second-submission`]: https://github.com/pammacdotnet/TypstPaper/tree/second-submission
[`final-submission`]: https://github.com/pammacdotnet/TypstPaper/tree/final-submission
[`fonts`]: https://github.com/pammacdotnet/TypstPaper/blob/main/fonts
[`.justfile`]: https://github.com/pammacdotnet/TypstPaper/blob/main/.justfile
[`just`]: https://github.com/casey/just
