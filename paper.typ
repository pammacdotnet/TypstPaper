#import "@preview/ijimai:0.0.5": *
#import "@preview/metalogo:1.2.0"
#let conf = toml("paper.toml")
#let author-photos = conf.authors.map(author => read("photos/" + author.photo, encoding: none))
#import "@preview/grayness:0.3.0": image-blur, image-darken, image-grayscale, image-huerotate, image-show
#show: ijimai.with(
  conf: conf,
  photos: author-photos,
  logo: image("unir logo.svg", width: 17.5%),
  bib-data: read("bibliography.bib", encoding: none),
)
#set text(fallback: false, font: (
  "Libertinus Serif",
  "Noto Serif CJK SC",
  "Noto Naskh Arabic UI",
  "Noto Color Emoji",
))

// Both looks good/correct only with bold font.
// Buenard font for some reason makes text jump high, hence the `baseline` fix.
// See https://github.com/typst/typst/issues/6769.
#let LaTeX = text(font: "New Computer Modern")[*#metalogo.LaTeX*]
#let typst = text(font: "Buenard", baseline: -0.04em, rgb("#229cac"))[*typst*]

// https://github.com/typst/typst/blob/563c8d3659e80eff6ffbea5a5a4c75115cf733da/crates/typst-library/src/text/raw.rs#L964
#let typst-blue = rgb("#4b69c6")

/// Automatically detect language via the file extension.
#let code-block(file) = {
  raw(read(file), lang: file.split(".").last(), block: true)
}

#let code-grid(typ-file, gutter: 1pt, left-column: 1fr) = {
  let typ = read(typ-file)
  let columns = if left-column == none { () } else { (left-column, 1.0fr) }
  let align = if left-column == none { left } else { horizon }
  grid(
    columns: columns,
    align: align,
    gutter: gutter,
    raw(typ, lang: "typst", block: true), text(size: 7.5pt, include typ-file),
  )
}

#let package-link(name) = {
  box(link("https://typst.app/universe/package/" + lower(name), name))
}
#let github-link(user-repo, name) = {
  box(link("https://github.com/" + user-repo, name))
}
#let ctan-link(package-name) = {
  box(link("https://ctan.org/pkg/" + lower(package-name), package-name))
}

#set math.equation(numbering: none)
#let mathbf(input) = { $upright(bold(#input))$ }

= Introduction
#first-paragraph[Typst][is a new markup-based typesetting language (and its tooling ecosystem) for technical and scientific documents. It is designed to be an alternative both to advanced tools like LaTeX and simpler tools like Microsoft Word and Google Docs. The goal with Typst is to build a typesetting framework that is highly capable, extensible, reliable, fast and exceptionally easy to use. For instance, with Typst, it is possible to:]

- Create professional-quality documents with ease.
- Access extensive functionality, including mathematical typesetting, figure management, and an auto-generated table of contents.
- Utilize powerful templates that automatically apply consistent formatting during the writing process.
- Benefit from high-quality typographical output with uncompromising justification and overall layout.
- View changes instantly with real-time preview functionality.
- Make use of clear and understandable error messages for efficient corrections.
- Apply a consistent styling system to configure fonts, margins, headings, lists, and other elements uniformly.
- Work with familiar programming constructs (no complex macros).
- Collaborate seamlessly with team members.
- Modify document formatting at any time.

The Typst realm comprises a refined and easy-to-understand markup language for defining the content, structure and style of a document, a reasonably fast (and community-driven) document renderer, and a companion web application that enables real-time in-browser compilation. All these components will be explored in @sec:markup, @sec:compiler, and @sec:typstapp, respectively.

Additionally, the project hosts a repository of extensions (packages and templates) called Typst Universe, discussed in @sec:universe. However, given that Typst is becoming popular and its adoption is growing steadily over the years (as observed in @sec:adoption), it is now often compared against the well-established LaTeX system. For this reason, we will start with a quick analogy of both environments (@sec:latex).

For the sake of completeness, @sec:theophys, @sec:moremath, and @sec:cs will focus on the application of this new typesetting system in more specific science and engineering domains such as theoretical Physics, Cosmology, Chemistry, Mathematics, Algorithmics, Signal Processing, Computer Science and the composition of slides in technical realms (@sec:slides). Finally, some conclusions are presented in @sec:conclusions.

#show raw.where(block: true): block.with(
  fill: softblueunir,
  inset: 4pt,
  radius: 2pt,
)

// Add note about Noto Color Emoji being bad and glyphs not being centered,
// or use another one.
#show raw: set text(size: 6.5pt, font: (
  "Fira Code",
  "Noto Sans Mono CJK SC",
  "Kawkab Mono",
  "Noto Color Emoji",
))
#show math.equation: set text(font: (
  "New Computer Modern Math",
  "Noto Color Emoji",
))
#show raw: it => {
  show emph: set text(font: "Fira Mono")
  it
}

= Typst and LaTeX <sec:latex>
Typst and LaTeX @Knuth86@Lamport94 are both markup-based typesetting systems (whose foundations are analyzed in @sec:art), but they differ in several key aspects. Regarding the language and its syntax, Typst employs intuitive patterns, similar to those found in Markdown @Voegler14, making it more accessible. Its commands and language rules are designed to work consistently, reducing the need to learn different conventions for each new add-on (called _packages_ in the Typst _semantic field_, and reviewed later in @sec:package).

@tab:LaTeXvTypst demonstrates a side-by-side example of the equivalent LaTeX and Typst code.

#let affine-typst = "affine example/typst.typ"
#let affine-latex = "affine example/latex.tex"

#figure(
  placement: none,
  kind: table,
  caption: [Typst vs. LaTeX comparison example],
  grid(
    columns: (1fr, 1.25fr),
    align: (_, y) => if y == 0 { center + horizon } else { auto },
    row-gutter: 4pt,
    grid.header(..(typst, LaTeX).map(strong)),
    code-block(affine-typst), code-block(affine-latex),
  ),
) <tab:LaTeXvTypst>

The output of the Typst part of @tab:LaTeXvTypst is rendered in @fig:affine (although the LaTeX one would be very similar).
#figure(
  placement: none,
  {
    set text(9pt)
    show heading: set align(center)
    show heading: set text(9pt, weight: "bold")
    show heading: it => block(smallcaps(it.body))
    rect(stroke: 0.1mm, inset: (bottom: 1mm), context {
      eval(read(affine-typst), mode: "markup")
      counter(heading).update(counter(heading).get())
    })
  },
  caption: [Output generated by the Typst code from @tab:LaTeXvTypst],
) <fig:affine>

Focusing on the renderer and local installs, Typst offers very fast (milliseconds) and incremental compilations, which allows for document previews that are delivered almost right away (for the average human perception). These rendering operations often occur under the so-called Doherty threshold, i.e., below this point, users stay highly productive. However, above it (around 400 milliseconds, as evinced by @Doherty82), system delays quickly degrade performance and satisfaction.

The compiler (tackled in @sec:compiler) is a single lightweight binary (less than 50 MiB) that, when necessary, downloads external packages on-demand, ensuring minimal and secure installations. All operations take place in user space (no need for special admin privileges).


Regarding the operating procedure, unlike LaTeX, Typst does not require boilerplate code to start a new document: just by creating an empty text file with a `typ` extension suffices. To simplify further, the Typst project hosts its own online editing service (@sec:typstapp). Currently, in the LaTeX world, this can only be achieved through external cloud solutions, such as Overleaf @Ewelina20. A very short summary on the main differences between the two ecosystems is presented in @tab:diffs.

#let TikZ = link("https://tikz.dev/")[TikZ]
#let PSTricks = link("https://tug.org/PSTricks/main.cgi/")[PSTricks]
#let CeTZ = package-link("CeTZ")
#let Lilaq = package-link("Lilaq")
#let Fletcher = package-link("Fletcher")
#let Listings = ctan-link("Listings")
#let Minted = ctan-link("Minted")

#let raw-size(size, body) = {
  set text(size)
  show raw: set text(size)
  body
}
#let feature(table) = {
  show std.table.cell: it => {
    set raw(lang: "tex") if it.x == 1
    set raw(lang: "typ") if it.x == 2
    it
  }
  table
}
#figure(
  placement: none,
  caption: [Main differences between LaTeX and Typst],
  feature(table(
    columns: (1.01fr, 2fr, 2fr),
    align: (x, y) => {
      if y == 0 { center + horizon } else if x == 0 { auto } else { left }
    },
    inset: 4.8pt,
    table.header(..([Feature], LaTeX, typst).map(strong)),
    table.hline(stroke: 1pt),
    // ugly
    stroke: .01cm,
    [Syntax],
    [Command-based (`\command{arg}`)],
    [Markdown-inspired (#box[`= Heading`], `_italic_`) + code mode (`#func()`)],
    [Math Mode],
    [`$...$` or `\[...\]`, verbose (`\frac{}{}`)],
    [`$...$`, concise (auto-fractions, variants, etc.)],
    [Headings],
    raw-size(0.97em)[`\section{}`, `\subsection{}`],
    [`= Heading`, `== Subheading`],
    [Lists],
    [`itemize`/`enumerate` environments],
    [`-` (bullets), `+` (numbers), #box(`/ Term:`) (descriptions)],
    [Commands],
    [Macros (`\newcommand`)],
    [1st-class functions (`#let f(x) = x + 1`), composable],
    [Compiler],
    [Slow and multi-pass],
    [Fast (ms) and incremental],
    [Packages],
    [Large TeX distributions],
    [Cached downloads],
    [Errors], [Cryptic], [User-friendly, detailed],
    [Graphics],
    [#TikZ, #PSTricks, etc.],
    [#CeTZ, #Lilaq, #Fletcher, etc.],
    [Team work],
    [Overleaf (third-party)],
    [Own app (@sec:typstapp)],
    [Code blocks],
    [Very package-dependent (#Listings, #Minted, etc.)],
    [Own native support for code blocks (`#raw(code)`)],
    [Citations], [Managed externally], [Built-in (also Hayagriva)],
    [Deploy], [Can be initially heavy (\~5 GiB) for most distros], [Starts with a single binary (\~40 MiB)],
    // Current minimal Universe distribution is around 442 MiB.
    // While TeX Live distribution can take 7+ GiB (https://tug.org/texlive/quickinstall.html).
  )),
) <tab:diffs>

= State of the art <sec:art>
Markup languages and typesetting systems offer several key advantages, including the separation of content from presentation, which allows authors to focus on structure and semantics while ensuring consistent formatting. They also enable automation, such as dynamic content generation, cross-referencing, and bibliography management, reducing human error and improving efficiency.

== Typesetting systems and markup languages
Modern typesetting relies heavily on computers, with most printed materials now created digitally rather than through traditional methods like typewriters or movable type. Professional desktop publishing tools offer precise control over elements like kerning and ligatures, and more general-purpose tools like Microsoft Word have adopted some of these features @Chagnon02. Still, these general applications lack the full suite of typesetting capabilities, such as high-quality hyphenation or the ability to flow text across multiple custom regions. This gap has driven adoption of text-based systems, especially in academia, where LaTeX dominates due to its powerful formula rendering and flexible layout control.

These setups rely on compiling source text into formatted output like PDF, separating content from presentation to allow easy reuse and adaptation of document styles @Clark07. Typesetting systems are designed not only to produce high-quality visual documents but also to support the complex process of creating structured content. A well-designed system must consider numerous layout features such as _line_ and _page breaking_, _kerning_, _ligatures_, contextual _glyph positioning_, and the treatment of languages with varied directionalities.

Additionally, avoiding formatting issues like _widows_ (the last line of a paragraph stranded at the top of a page) and _orphans_ (the first line of a paragraph left alone at the bottom of a page) is part of achieving professional-quality results. However, this visual precision is only one side of the coin. These systems must also support complex content like sections, tables, and figures in a structured manner (@tab:typesetting).

#figure(placement: none, caption: [Most important typesetting algorithms], table(
  columns: (1fr, 2fr, 2fr),
  align: (auto, auto, auto),
  stroke: .01cm,
  table.header(..([Challenge], [Description], [Algorithm/Approach]).map(strong)),
  table.hline(stroke: 1pt),
  "Paragraph breaking",
  // Do table cells must be justified? The big spaces between words don't look good.
  [Breaking text into lines with aesthetically pleasing spacing/hyphenation],
  [Knuth-Plass line breaking algorithm @Hassan15.],
  [Justification],
  [Lines align evenly at margins],
  [Spacing adjustments with the Knuth-Plass @Knuth81],
  [Grid Layout],
  [Optimal space for rows/columns in grids],
  [Constraint-based layout calculation @Feiner98],
  [Page Breaking],
  [Page division while respecting layout],
  [Greedy + backtracking algorithms @Plass81],
  [Glyph Selection],
  [Correct glyphs depending on context],
  [Font shaping and context-sensitive glyphs @Rougier18],
  [Bidirectional Text],
  [Mixing LTR and RTL scripts],
  [Unicode Bidirectional Algorithm @Toledo01],
  [Incremental Layout],
  [Reusing layout computations after small edits],
  [Constraint-based layout cache/region reuse @Fisher91],
  [Styling], [Consistent styles], [Programmable layouts],
  [Unicode],
  [Modern scripts, ligatures, and grapheme clusters],
  [Shaping and grapheme line breaking @Elkhayati2022],
)) <tab:typesetting>

Historically, the development of markup-oriented systems began in the 1960s with tools like Runoff and evolved significantly with programs like Troff @Barron87 and TeX. Troff brought enhanced typographic features to Unix environments, while TeX revolutionized typesetting with its advanced paragraph layout algorithms and extensible macro system. LaTeX, built on top of TeX, pushed the concept further by introducing _descriptive markup_, where authors focus on the logical structure of content rather than its appearance. Parallel to this, systems like GML, SGML, and eventually HTML and XML developed the idea of defining structure through custom tags @Derose97, with SGML forming the basis for later web standards. Over time (@fig:mlevolution), styling systems like CSS and XSL emerged to handle the transformation of structured content into presentational formats @Cole00. Yet, limitations persisted, such as verbosity in XML and complexity in LaTeX customization.


#figure(
  placement: none,
  include "typesetting systems.typ",
  caption: [Evolution of some Typesetting technologies],
) <fig:mlevolution>

Recent efforts in the typesetting world have aimed at modernizing older systems. Lightweight languages like Markdown#footnote[https://daringfireball.net/projects/markdown] or AsciiDoc#footnote[https://asciidoc.org] prioritize ease of use but sacrifice power. For this reason, these tools usually team up with conversion solutions, such as Pandoc @Dominici14.

On the other hand, advanced software like LuaTeX @Pegourie13 or ConTeXt#footnote[http://wiki.contextgarden.net] attempt to replace TeX while maintaining its output quality. However, these often inherit TeX's core limitations, like performance or syntax issues. LaTeX has slowly evolved with modular improvements like the L3 layer and a new hook system @Mittelbach24. Nevertheless, many challenges remained unsolved around usability, accessibility, and automation. // "and a significantly improved user experience" sounds bad/backwards with the current phrasing.
#let Pyrunner = package-link("Pyrunner")
#let Diagraph = package-link("Diagraph")
#let Neoplot = package-link("Neoplot")
#let Jlyfish = package-link("Jlyfish")
#let Callisto = package-link("Callisto")
#let Nulite = package-link("Nulite")
#let Jogs = package-link("Jogs")

== Computed documents and dynamic content <sec:computed>
Dynamic content generation is a crucial feature of modern markup languages and typesetting systems, enabling documents to update automatically based on external data or user input. By integrating programming logic, such as loops, conditionals, and variables, these systems can produce data-driven outputs, from dynamically generated reports in LaTeX to interactive web pages in Markdown with embedded scripts. This capability reduces manual repetition, minimizes errors, and ensures consistency when dealing with large or evolving datasets. Furthermore, dynamic generation supports real-time updates in interactive documents, such as dashboards or educational materials, enhancing usability and engagement. By blending structured markup with computational power, these systems bridge the gap between static documents and flexible, automated publishing workflows, making them indispensable for technical, scientific, and web-based documentation.

Knitr @Xie18, Sweave @Leisch02, and similar computational document applications, such as RMarkdown @Baumer15 and Jupyter Notebooks, integrate code execution with document authoring, allowing authors to embed live code chunks that produce figures, tables, and statistical results within a narrative. These systems are particularly prevalent in data science and scientific writing, where reproducibility is crucial. Built on top of LaTeX or Markdown, they provide a powerful, albeit often complex, workflow that couples typesetting with dynamic content generation.

In contrast, Typst offers a more unified and modern approach: rather than embedding a separate scripting language into markup, it merges typesetting and computation into a single, consistent language. This seamless integration allows Typst to support sophisticated layout logic, styling, and even data-driven approaches without the verbosity or complexity found in the aforementioned tools. Besides, when teaming up with modern web technologies such as WebAssembly (or Wasm, discussed in @sec:wasm), the possibilities are almost endless.
For instance, the package #Pyrunner#footnote[https://typst.app/universe/package/pyrunner] allows the execution of arbitrary chunks of Python code within a Typst document (@fig:pyrunner).

#figure(
  placement: none,
  code-grid("pyrunner example.typ", gutter: 0.5em, left-column: none),
  caption: [Python code and its output produced by #Pyrunner],
  kind: image,
) <fig:pyrunner>

Other current WebAssembly-grounded integration solutions for computational documents in Typst are:
/ #Neoplot#footnote[https://github.com/KNnut/neoplot]: for generating plots with Gnuplot (see @fig:neoplot). // remove "see"?
/ #Jlyfish#footnote[https://github.com/andreasKroepelin/TypstJlyfish.jl]: for integrating Julia code.
/ #Callisto#footnote[https://github.com/knuesel/callisto]: for reading and rendering Jupyter notebooks.
/ #Diagraph#footnote[https://github.com/Robotechnic/diagraph]: for binding simple Graphviz-based diagrams (see @fig:dot).
/ #Nulite#footnote[https://github.com/j-mueller/typst-vegalite]: for plotting Vega-based charts.
/ #Jogs#footnote[https://github.com/Enter-tainer/jogs]: a native JavaScript runtime.

// This table doesn't show the transitions between modes, like in a matrix.

// Nested code block highlighting is not support:
// https://github.com/typst/typst/issues/2844
#figure(
  code-grid("diagraph example.typ", left-column: 1.6fr),
  caption: [Example of a Graphviz diagram, rendered natively with Wasm],
  kind: image,
  placement: none,
) <fig:dot>



= The markup language <sec:markup>
Typst employs straightforward markup syntax for standard formatting operations. For instance, headings can be created with the `=` symbol, while text can be italicized by enclosing it in `_underscores_`. // inconsistent example/description narrative.

Typst employs three distinct syntactical modes: markup, math, and code. By default, a `.typ` document operates in _markup mode_, which handles standard text formatting. _Math mode_ enables the composition of mathematical expressions, while _code mode_ provides access to Typst's scripting capabilities for dynamic content generation. Transitions between these modes are governed by specific markers (@tab:modes).

#figure(
  placement: none,
  table(
    columns: (0.55fr, 1.5fr, 1.7fr),
    inset: 5pt,
    align: left,
    stroke: .01cm,
    table.header([*Mode*], [*Syntax*], [*Example*]),

    [Code], [Prefix code with \#], raw("Number: #(1 + 2)", lang: "typ"),
    [Math], [Surround math with \$…\$], raw("$-x$ is the opposite of $x$", lang: "typ"),
    [Markup], [Put markup in \[…\]], raw("#let name = [*Typst!*]", lang: "typ"),
  ),
  caption: [Typst syntactical modes],
) <tab:modes>

All this content is written in Unicode @Bettels93. Typst has embraced this computing standard as a first-class citizen (@fig:mathunicode), making it much more modern and intuitive than traditional typesetting systems.
// First-class citizen, in my mind, is example where different Unicode characters are used as variable/function names, as it can be more practical sometimes to use native language to improve overall source readability.

#figure(
  raw-size(0.97em, code-grid("unicode math example.typ", left-column: 1.7fr)),
  caption: [Illustration of Unicode use in Typst for text and math.],
  kind: image,
  placement: none,
) <fig:mathunicode>








== Styling
Typst makes styling documents flexible, and consistent with a modern and declarative approach. In certain ways, it operates very similarly to CSS, but built for typesetting. With more detail, it uses a consistent and hierarchical styling model where styles can be defined globally, applied to specific elements, or inherited through logical relationships. Typst leverages a declarative syntax combined with programmatic features, allowing users to define reusable styles, functions, and templates. For example, document-wide settings like fonts, margins, and colors can be set at the beginning, while local overrides can be applied to headings, tables, or other elements using rules and selectors. This ensures clean separation of content and presentation with flexibility. Additionally, Typst's styling system supports dynamic adjustments, such as conditionally changing layouts or automating typographic refinements, thanks to its built-in scripting capabilities.

#set raw(lang: "typc")

Typst uses a two-pronged styling system to separate styling from content. First, `set` rules allow the declaration of global or local scoped defaults for elements (like text, page, par, heading), specifying parameters such as font, size, margins, justification, line spacing, numbering, and layout. Once set, these defaults apply automatically wherever that element appears. Second, `show` rules enable custom rendering logic for specific elements or selectors.

Normally, `show` and `set` statements are used combinedly to tweak the appearance of an element with code-based transformations (e.g., small caps, run-in headings, added logotypes, etc.). They can also be used for theming an entire document (templates) via an _everything_ `show`-`set` directive. By combining the rigor of traditional typesetting with modern programming paradigms, Typst provides a powerful yet intuitive way to manage document styling, whether for academic papers, technical reports, or dynamic publications. For instance, the style rules necessary to produce @fig:affine are presented in @fig:setshow.

#let show-set = `show` + raw(lang: none, "-") + `set`
#let Heading = text(typst-blue, `heading`)
#figure(
  placement: none,
  caption: [Example of a global `set` rule and #show-set & `show` rules (on the #Heading elements) necessary to render the content of @fig:affine],
  kind: image,
  grid(
    columns: (1fr, 3fr),
    gutter: 1pt,
    [Global `set` rule], [Show and show-set rules for heading styling],
    [#v(.1cm)], [],
    ```typ
    #set text(9pt)
    ```,
    ```typ
    #show heading: set align(center)
    #show heading: set text(9pt)
    #show heading: it => block(smallcaps(it.body))
    ```,
  ),
) <fig:setshow>



== Control structures
Typst incorporates several control structures that facilitate dynamic content generation and conditional logic within documents. The `if` statement enables conditional rendering, allowing content to be included or excluded based on specific conditions. For instance, `if dark { set page(fill: rgb("333333")) }` applies a dark theme when the `dark` variable is true. It is important to note that `set` rules are scoped, thus, applying them within an `if` block confines their effect to that block's scope. Additionally, Typst treats `if` as an expression, permitting concise inline conditionals like `if x > 10 { "High" } else { "Low" }`.

For iterative operations, Typst offers `for` and `while` loops. The `for` loop is versatile, capable of iterating over strings, arrays, dictionaries, and more. For example, `for letter in "abc" { letter }` processes each character in the string. Control statements like `break` and `continue` are available to manage loop execution, allowing for early exits or skipping iterations. The `while` loop continues execution as long as a specified condition remains true. These loops can be utilized within content blocks to dynamically generate document elements, such as populating tables or lists based on data structures. Finally, arrays and dictionaries can be iterated with object oriented-like methods present in modern programming languages (`.map`, `.filter`, `.enumerate`, etc.)

== Math
#let lagrangian = ```typ
$
  cal(L) = -1 / 4 B_(mu nu) B^(mu nu) - 1 / 8 tr(mathbf(W)_(mu nu) mathbf(W)^(mu nu)) - 1 / 2 tr(bold(G)_(mu nu) G^(mu nu)) \
  + (macron(nu)_L, macron(e)_L) tilde(sigma)^mu i D_mu vec(nu_L, e_L) + macron(e)_R sigma^mu i D_mu e_R + macron(nu)_R sigma^mu i D_mu nu_R + "h.c."\
  - sqrt(2) / mu [macron(nu)_L, macron(e)_L] phi M^e e_R + macron(e)_R macron(M)^e macron(phi) vec(nu_L, e_L) \
  - sqrt(2) / mu [(- macron(e)_L, macron(nu)_L) phi^* M^nu nu_R + macron(nu)_R macron(M)^nu phi^T vec(-e_L, nu_L)] \
  + (macron(u)_L, macron(d)_L) tilde(sigma)^mu i D_mu (u_L, d_L) + macron(u)_R σ^mu i D_mu u_R + macron(d)_R σ^mu i D_mu d_R + "h.c.   " \
  - sqrt(2) / mu [(macron(u)_L, macron(d)_L) phi M^d d_R + macron(d)_R macron(M)^d macron(phi) vec(u_L, d_L)] \
  - sqrt(2) / mu [(- macron(d)_L, macron(u)_L) phi^* M^u u_R + macron(u)_R macron(M)^u phi^tack.b vec(-d_L, u_L)] \
  + (D_mu phi)^dagger D^mu phi - m_h^2 [macron(phi) phi - nu^2 / 2]^2 / (2 nu^2)
$
```



#[
  #let left = ```tex \left```
  #let right = ```tex \right```
  Typst offers robust support for mathematical expressions, providing a syntax that is both intuitive and powerful. To enter math mode, it is only necessary to enclose mathematical expressions within dollar signs (`$...$`). For display-style equations, spaces or newlines can be added between the dollar signs and the content. Typst's math mode supports a wide range of symbols and functions, including Greek letters, operators, and more. Subscripts and superscripts are handled using the underscore (`_`) and caret (`^`) symbols, respectively. For example, `$x^2$` renders as $x^2$, and `$a_b$` renders as $a_b$.

  Additionally, Typst automatically scales delimiters like parentheses and brackets to fit their content, similar to LaTeX's #left and #right commands. This ensures that complex expressions are rendered clearly and accurately. For instance, the Typst math code in @fig:sm allows the typesetting of the Lagrangian of the Standard Model of Physics (@fig:rsm).
]

#figure(
  placement: none,
  kind: image,
  lagrangian,
  caption: [Typst code for the Lagrangian of the Standard Model],
) <fig:sm>

#figure(
  placement: none,
  caption: [Rendering of the code in @fig:sm],
  rect(stroke: 0.05mm, {
    set par(leading: 0pt)
    eval(lagrangian.text, scope: (mathbf: mathbf))
  }),
) <fig:rsm>


#let Quick-Maths = package-link("Quick-Maths")
#let Great-Theorems = package-link("Great-Theorems")
#let Game-Theoryst = package-link("Game-Theoryst")
#let Physica = package-link("Physica")
#let Equate = package-link("Equate")
#let MiTeX = package-link("MiTeX")

Beyond basic syntax, Typst allows for advanced customization of mathematical expressions. Matrices can be defined using the `mat` function, which accepts semicolon-separated rows and comma-separated columns, such as `$mat(1, 2; 3, 4)$` to render a $2 times 2$ matrix. Typst also supports piecewise functions through the `cases` function, enabling the definition of functions with multiple conditions in a clear format. Moreover, text can be incorporated within math expressions by enclosing it in double quotes, like `$x > 0 "if" y < 1$`. For users who prefer using Unicode symbols directly, Typst accommodates this as well, allowing for a more natural input of mathematical notation.
#figure(
  code-grid("physica example.typ", left-column: 1.5fr),
  caption: [Example of advanced math with the #Physica package#footnote[https://typst.app/universe/package/physica]],
  kind: image,
  placement: none,
) <fig:physica>

Besides, the Typst Universe (@sec:universe) site hosts a variety of math-related packages to enhance mathematical typesetting:
/ #Quick-Maths: package  allows users to define custom shorthands for complex expressions, streamlining the writing process.
/ #Great-Theorems: provides structured environments for theorems, lemmas, and proofs with customizable styling and numbering.
/ #Game-Theoryst: facilitates the typesetting of payoff matrices.
/ #Physica: package offers tools for scientific and engineering mathematics, including matrix operations and vector calculus (@fig:physica).
/ #Equate: enhances the formatting and numbering of mathematical equations, improving readability and reference.
/ #MiTeX: integrates LaTeX math syntax into Typst, allowing users to write equations using familiar LaTeX commands.

== Drawing capabilities
Typst's visualize module#footnote[https://typst.app/docs/reference/visualize] offers a comprehensive suite of tools for creating vector graphics and data visualizations directly within documents. It supports a variety of shapes and elements, including circles, ellipses, rectangles, squares, lines, polygons, and Bézier curves, each customizable with parameters like fill, stroke, and radius.

// Should be different to show the diversity.
#figure(
  placement: none,
  code-grid("gradient stack.typ", left-column: 2fr),
  caption: [Gradient stack example showing Typst drawing capabilities],
  kind: image,
) <fig:gradient>

The module also allows for the inclusion of images (both raster and vector) and supports advanced styling options such as gradients (@fig:gradient) and tiled patterns (@fig:chess).

#figure(
  placement: none,
  align(center)[#code-grid("chess example.typ", left-column: 1.6fr)],
  caption: [Chessboard tiled pattern (with the board-n-pieces package)],
  kind: image,
) <fig:chess>

#let CeTZ-Plot = package-link("CeTZ-Plot")

It is worth mentioning the Typst's #CeTZ library#footnote[http://cetz-package.github.io]. #CeTZ is a graphics package designed for the Typst typesetting system, aiming to provide capabilities similar to those of LaTeX's #TikZ for creating vector graphics @Kottwitz23. While TikZ is a mature and powerful tool within the LaTeX ecosystem, known for its extensive features, #CeTZ is tailored to integrate seamlessly with Typst's syntax and design philosophy.

Regarding data visualization, Typst also offers powerful capabilities through its extensible package ecosystem, enabling users to create high-quality plots and charts directly within their documents. Two prominent packages facilitating this are #Lilaq#footnote[https://lilaq.org] and #CeTZ-Plot#footnote[https://github.com/cetz-package/cetz-plot]. The first one provides a user-friendly interface for scientific data visualization, drawing inspiration from tools like Matplotlib @Tosi09 and PGFplots (@fig:lilaq). It emphasizes ease of use, allowing for quick creation of plots with minimal code, and supports features like customizable color cycles, axis configurations, and various plot types.

#figure(
  code-grid("lilaq example/example.typ", left-column: 1.1fr),
  caption: [Example of a plot made with the Lilaq plotting package],
  kind: image,
) <fig:lilaq>

On the other hand, #CeTZ-Plot extends the #CeTZ drawing library, offering functionalities for creating plots and charts within the #CeTZ canvas environment (@fig:cetz-plot). It supports various chart types, including pie charts, bar charts, and pyramids.

#figure(
  code-grid("cetz-plot example.typ", left-column: 1.55fr),
  caption: [Example of a cycle diagram created with #CeTZ-Plot],
  kind: image,
  placement: none,
) <fig:cetz-plot>



== Bibliographic references

Typst offers integrated support for bibliographic references, streamlining the citation process for users. It allows authors to include citations in their documents using the `cite` function or the `@key` syntax, referencing entries from bibliography files.

#figure(
  caption: [Sample of a BibTeX entry and its Hayagriva equivalent for @Corbi23],
  kind: image,
  placement: none,
  grid(
    columns: (4.5fr, 5.5fr),
    rows: (auto, auto),
    gutter: 5pt,
    ```bib
    @article{Corbi23,
      title     = {Cloud-Operated Open Literate Educational Resources: The Case of the MyBinder},
      author    = {Corbi, Alberto and Burgos, Daniel and Pérez, Antonio María},
      journal   = {IEEE Transactions on Learning Technologies},
      volume    = {17},
      pages     = {893--902},
      year      = {2023},
    }
    ```,
    ```yaml
    Corbi23:
      type: article
      title: "Cloud-Operated Open Literate Educational Resources: The Case of the MyBinder"
      author:
        - Corbi, Alberto
        - Burgos, Daniel
        - Pérez, Antonio María
      date: 2023
      page-range: 893-902
      parent:
        type: periodical
        title: IEEE Transactions on Learning Technologies
        volume: 17
    ```,
  ),
) <fig:haya>



Currently, both BibLaTeX `.bib` files @Datta17 and Hayagriva `.yaml` files are supported as sources for bibliographic data (@fig:haya). The system utilizes the Citation Style Language (CSL) to format citations and bibliographies @Fenner14, providing a wide range of built-in styles such as APA, MLA, IEEE, and Chicago. Users can also add custom CSL files to accommodate specific formatting requirements.

Hayagriva#footnote[https://github.com/typst/hayagriva] is a Rust-based bibliography management library developed side-by-side with Typst to work smoothly with it. Hayagriva introduces a YAML-backed format for bibliographic entries and incorporates a CSL processor to format both in-text citations and reference lists. This alternative to BibTeX supports all styles provided in the official CSL repository, offering users access to over 2,600 citation styles.




= The compiler and command-line interface <sec:compiler>
Typst's compiler operates differently from traditional ones by using a reactive model (@fig:compiler) that tracks dependencies and selectively re-evaluates only the modified parts of a document @Haug22. This enables instant previews during editing, as the system interprets layout instructions, styling rules, and content in real time @Madje22. A consistent styling system and an intelligent layout engine work together to resolve these elements efficiently, supporting complex features like math typesetting, dynamic templates, and figures while maintaining responsiveness.



== Typst abstract syntax tree and Rust
The compilation itself follows a structured yet flexible process. First, the input text is parsed into an _abstract syntax tree_ (AST) using Typst's grammar rules, followed by static analysis to resolve imports, variables, and functions. After type checking and evaluating expressions, the AST is transformed into an _intermediate representation_ containing layout directives. The compiler then computes the final document layout using a constraint-based algorithm to determine positioning, sizing, and breaks (such as pages). Finally, it renders the output based on the resolved layout. This incremental approach ensures that updates are processed efficiently, minimizing recomputation when changes occur.

Typst's choice of Rust @Klabnik23 as its underlying programming language provides several key benefits, including high performance, memory safety, and modern tooling. Rust's efficiency allows Typst to compile documents significantly faster than traditional LaTeX systems, with benchmarks showing near-instantaneous updates after initial compilation (e.g., 200~ms for changes in a 77-page document). The language's memory safety guarantees prevent common bugs like data races, which is critical for a typesetting system handling complex document structures. Additionally, Rust's strong type system and zero-cost abstractions enable Typst to implement features like cross-platform development, including WebAssembly for browser-based tools.

#import "@preview/pintorita:0.1.4"
#show raw.where(lang: "pintora"): it => pintorita.render(it.text)


#figure(
  placement: top,
  kind: image,
  scope: "parent",
  caption: [Typst compiling process, comprising four main phases: _parsing_, _evaluation_, _layout_, and _rendering_. HTML export is in an experimental stage],
  ```pintora
  mindmap
  @param layoutDirection LR
  + Source file
  ++ Parser
  +++ Syntax tree
  ++++ Interpreter
  +++++ Realization
  ++++++ Layout
  +++++++ Renderer
  ++++++++ Exporter
  +++++++++ PNG
  +++++++++ SVG
  +++++++++ PDF
  ```,
) <fig:compiler>
// Why not include HTML?


== Abstraction and mutation
Abstractions in Typst enables users to manage
complexity by hiding irrelevant details through two primary mechanisms:
/ Functions: are defined using `let` syntax and support required positional arguments, optional named arguments with defaults, and _argument sinks_ for variadic inputs. A key convenience is the shorthand for passing content as the last argument using brackets (`[...]`). Functions implicitly join multiple content pieces and return them without requiring an explicit `return` statement.
#set raw(lang: "typ")
/ Modules: simplify design. They can be imported (`#import`) for later use or included (`#include`) for immediate inlining of their content.

== Value semantics and coercion
Typst employs _value semantics_, meaning values are treated as if they are copied whenever they are passed or modified. This approach prevents unintended side effects and simplifies reasoning about code. For instance, modifying a dictionary inside a function or during iteration does not affect the original structure because the function or loop receives a copy. This avoids common pitfalls such as cyclic data structures, iterator invalidation, and unintended global mutations. As a result, code becomes easier to test and debug, and features like multi-threading are safer and simpler to implement. In Typst, even function arguments and global variables behave as immutable within the scope of a function, reinforcing this isolation.

Although value semantics suggest potential performance costs due to frequent copying, Typst mitigates this with a _copy-on-write_ strategy, i.e., data is only duplicated when it is modified and shared across references. This offers a practical balance between performance and clarity. Unlike some languages that explicitly distinguish between _owned_ and _shared_ data, Typst keeps its model implicit, which aligns well with its role as a typesetting tool. Users can focus on layout and content without needing to manage complex memory models. For example, mutating an array inside a function does not affect the original.

// ```typ
// #let modify(dict) = { dict.x = 100 }
// #let d = (x: 1); modify(d); d.x // Still 1
// ```

#let eval-func = link("https://typst.app/docs/reference/foundations/eval/")[`eval`]

A unique feature is _implicit coercion_: values like numbers or strings are automatically converted to content when used in markup. For instance, `#(1 + 2)` in markup becomes #(1 + 2), while `3.0` retains its fractional part in arrays for debugging clarity. Strings differ from content: even though they can be implicitly or explicitly coerced to content, special syntax for smart quotes, references, etc. will not be picked up, e.g., `#"'Hello'"` will produce #"'Hello'" and not #eval("'Hello'", mode: "markup") (#eval-func, introduced in @cs-other, can help with such issues).

== Modules
As mentioned, Typst's other form of abstraction is modules. There are three ways to _import_ a module:
/ `#import "mymodule.typ"`: makes `mymodule` _visible_. Then, it is possible to write `mymodule.functionality` to access what is defined with #box(`#let functionality = ...`) in `mymodule.typ`.
/ `#import "mymodule.typ": *`: functionality puts `functionality` directly in scope, so that the prefix is not needed anymore.
/ `#include "mymodule.typ"`: inlines the _content_ (and only the content) from `mymodule.typ`.
#set raw(lang: "typc")

Modules do not give the user/developer any way to mark items as _public_ or _private_. Thus, every `let` statement in the whole module is exported (public).

// Some users#footnote[https://justinpombrio.net/2024/11/30/typst.html] have suggested some _solutions_, such as extending `set/show` to user-defined functions (e.g., `set sequence(codon-sep: "-")`) and improving `show` to tweak elements without reimplementing them entirely, like adding decorations to headings robustly.


== Packages <sec:package>
As with LaTeX and as commented above, Typst also supports the addition of functionalities via _packages_. A Typst package is a self-contained collection of Typst source files and assets, structured around a mandatory `typst.toml` manifest file located at the package root (written in the _Tom's Obvious Minimal Language_#footnote("https://toml.io")). This manifest specifies essential metadata such as the package's `name`, `version`, and `entrypoint`, which points to the main `.typ` file to be evaluated upon import. Additional optional fields like `authors`, `license`, and `description` can also be included. The internal organization of the package is flexible, allowing authors to structure files and directories as they see fit, provided that the `entrypoint` path is correctly specified. All paths within the package are resolved relative to the package root, ensuring encapsulation and preventing access to files outside the package.

#set raw(lang: "typ")

Packages are typically stored in a directory hierarchy following the pattern `{namespace}/{name}/{version}` and can be imported into Typst documents using the syntax `#import "@{namespace}/{name}:{version}"`. For local development or experimentation, packages can be placed in designated local data directories, making them accessible without publishing to the shared repository. The `@preview` namespace in Typst serves as a dedicated space for community-contributed packages. These packages are hosted in the Typst package repository.

== Web technologies <sec:wasm>
As introduced in @sec:computed, Typst leverages WebAssembly (Wasm) to enable its core functionalities to run efficiently in web environments @Haas17. This approach allows Typst to execute its typesetting engine directly within web browsers, facilitating seamless integration into web-based applications and services. By compiling its Rust-based codebase to Wasm, Typst ensures consistent performance across different platforms without the need for native installations. This strategy not only enhances accessibility but also simplifies the deployment process, making Typst a versatile tool for developers and content creators alike.

As an example, the #Neoplot package is a specialized tool designed to integrate Gnuplot (a powerful open-source plotting engine @Janert16) into Typst documents (@fig:neoplot).

#figure(
  code-grid("neoplot example.typ", left-column: 1.7fr),
  caption: [Parabola plot with the #Neoplot Wasm-based package],
  kind: image,
  placement: none,
) <fig:neoplot>

#let Grayness = package-link("Grayness")

The #Grayness#footnote[https://github.com/nineff/grayness] package allows the application of complex image manipulation algorithms (@fig:mileva).

#let data = read("mileva.jpg", encoding: none)
#figure(
  placement: none,
  caption: [Complex image manipulation via the #Grayness Wasm plugin],
  grid(
    columns: 3,
    gutter: 2pt,
    image-show(data), image-blur(data, sigma: 20), image-darken(data, amount: 0.4),
  ),
) <fig:mileva>



== Security <sec:sec>
The Typst compiler ensures safety by implementing strict security measures that prevent potentially harmful operations during document compilation. It restricts file access to the project's root directory, disallowing reading or writing files outside this scope, thereby safeguarding against unauthorized data access. Additionally, Typst prohibits features like _shell escapes_ and network requests, which could otherwise be exploited for arbitrary code execution or data exfiltration (that currently may take place in the _TeX-sphere_ @Lacombe21 @Kim24). These design choices collectively create a secure environment, making Typst safe to use even with untrusted input.



#[
  #show raw: set text(typst-blue)
  == Introspection
  Typst's introspection system provides a suite of functions that enable dynamic interaction with a document's structure and content. Central to this system are functions like `counter` and `query`. The `counter` function allows for tracking and manipulating counts of elements such as pages, headings, figures, and equations. Users can access current counter values, display them in various formats, and even define custom counters for specific needs. For instance, it is possible to create a custom counter to number specific elements uniquely throughout the document. On the other hand, the `query` function facilitates searching the document for elements that match certain criteria, such as all headings of a specific level or elements with certain labels. This is particularly useful for generating dynamic content like tables of contents or table of figures, as it allows for real-time retrieval and display of relevant elements based on the document's current state.

  Complementing these are functions like `here`, `locate`, and `metadata`, which offer deeper insights into the document's structure:
  / `here`: retrieves the current location within the document, which can be used in conjunction with other functions to determine positional information. For example, combining `here` with `query` can yield the number of specific elements preceding the current point.
  / `locate`: identifies the position of a specific element, allowing for precise referencing or manipulation based on location.
  / `metadata`: function enables embedding arbitrary values without producing visible content, which can later be retrieved using `query`. This is particularly useful for storing and accessing auxiliary information that informs document behavior or content generation.
]

== Integrated development environments <sec:ide>
Typst integrates seamlessly with existing integrated development environments, such as Visual Studio Code (@fig:vscode). For instance, extensions like Tinymist#footnote[https://github.com/Myriad-Dreamin/tinymist], provide a comprehensive environment for Typst document creation. Tinymist offers features such as syntax highlighting, real-time previews, code completion, and error diagnostics, enhancing the editing experience. Users can initialize Typst projects using built-in templates, format documents with LSP-enhanced formatters, and manage local packages directly within VS Code. These tools collectively transform almost any code editor or development platform into a powerful solution for Typst-based typesetting. // Mention Neovim etc.

#figure(
  // Update image:
  // - use VSCodium (if UI is any different)
  // - hide copilot
  // - Use English (or create a i18n-like example, though one already exists)
  // - include code that is on the screenshot
  image("vscode.jpg"),
  kind: image,
  caption: [Typst can also be used in modern code editors and development environments, such as Visual Studio Code, Emacs or even Vim],
  placement: none,
) <fig:vscode>

#set raw(lang: none)
== Export options
As of mid 2025, Typst supports exporting documents in four formats: PDF, SVG, PNG, and HTML. PDF export is the most mature, offering high-quality, resolution-independent documents compliant with the PDF 1.7 standard. It also supports PDF/A-2b and PDF/A-3b formats for archival purposes, with options to specify page ranges and standards via the command-line interface or the web application (the web app). SVG export is well-supported, ideal for embedding vector graphics into web pages, and allows exporting each page as a separate SVG file with customizable naming templates and page range selection. PNG export has same feature set as SVG, except it's a raster graphics format instead of vector graphics. HTML export is currently experimental (@fig:compiler) and under active development. It requires enabling a feature flag (`--features html`) in the command line interface, supports basic markup elements, and is not yet available in the web app.

== Image formats
Having a big variety of image formats that can be included in a document is undeniably convenient. However, this comes at a cost of having more code that handles each separate image format, which in turn can greatly increase compiler program size. This matter is taken very seriously by the Typst maintainers, which resulted in a small set of supported image formats (but also the most popular). As such, PNG, JPEG, and SVG formats can be included as images in a Typst project. Beginning with version 0.14.0, a PDF image can embedded as is, providing a small file increase, sharp vector graphics, and selectable text. This feature is already available for testing in the web app, which will be our next topic.

#let Notion = link("https://www.notion.com")[Notion]

#set raw(lang: "typc")
= Web application <sec:typstapp>
The shift to cloud-based tools is revolutionizing content creation, academic work, and document editing, with platforms like Binder @Corbi23, and Overleaf being the two most currently known. These tools, alongside mainstream platforms like Google Docs and #Notion#footnote[https://www.notion.com], reflect a broader trend: cloud-based tools reduce access barriers, foster collaboration, and integrate advanced workflows that were once confined to local software. As a result, education, research, and professional documentation are becoming more dynamic, inclusive, and efficient.

#figure(
  image("typstapp2.jpg", width: 100%),
  placement: none,
  caption: [Screenshot of the typst.app web application (online editor)],
) <fig:typstapp>

Papeeria#footnote[https://papeeria.com] and Authorea#footnote[https://www.authorea.com] offer similar collaborative LaTeX editing capabilities but have smaller user bases. PLMLatex#footnote[https://plmlatex.math.cnrs.fr], developed by the _National Centre for Scientific Research_ (CNRS), is a French-language LaTeX editor based on the open-source version of Overleaf. It provides a user interface and functionality closely resembling Overleaf, though it lacks certain premium features. CoCalc also supports LaTeX editing alongside tools for calculations, research, and collaboration.

The Typst online editor (@fig:typstapp) is a collaborative, web-based platform designed for creating and typesetting documents with Typst. It offers a seamless writing experience with features like instant preview, syntax highlighting, and autocompletion, making it ideal for composing academic papers, technical reports, and other long-form documents. The editor splits the interface into two panels: a source panel for writing Typst markup and a preview panel that renders the document in real time. Users can easily format text, insert images (_drag and drop_ gestures can even be used), equations, and bibliographies, and leverage Typst's scripting capabilities for advanced customization. The web app also supports collaboration through the WebSocket standard @Lombardi2015, allowing users to share projects, track changes, and integrate with tools like Zotero and Mendeley for reference management.

The development team is actively working on improvements, including better mobile usability and additional features like offline PWA support and private templates for teams. The editor is available for free with basic features, while a _Pro_ subscription#footnote[https://typst.app/pricing] unlocks advanced aspects like Git integration, presentation mode, and increased storage.

#let Soviet-Matrix = package-link("Soviet-Matrix")

Because of Typst's high compilation speeds and instant preview, the web app can even support interactive games, such as a fully functional Tetris. It is published as the  #Soviet-Matrix package.



= Adoption of Typst <sec:adoption>

Typst has attracted significant interest since its public beta launch and the open-sourcing of its compiler in March 2023. The platform's user-friendly syntax and modern features have attracted a flourishing community, with its GitHub repository amassing over 45,000 stars, indicating strong developer engagement. Typst's open-source nature and active development suggest a promising future as it continues to evolve and address the needs of its users.

During the period 2020--2025, Typst evolved from a niche LaTeX alternative into a widely adopted document-formatting tool. Early development (2020--2022) focused on core features like a Rust-based compiler, attracting tech-savvy users. By 2023, public beta releases and improved documentation spurred initial growth, though gaps like CJK support persisted. In 2024, corporate adoption (e.g., in banking software) and features like #CeTZ for graphics expanded its reach. Projections for 2026 hinge on addressing accessibility and localization, while compiler optimizations (e.g., faster builds) and community tools (e.g., Tinymist, commented in @sec:ide) aim to solidify its position#footnote[https://github.com/qjcg/awesome-typst]. The Typst community is also providing templates for the most reputed journals, as evinced in @fig:papers for IEEE and MDPI.

// Certainly, as with every new disruptive technology and, as also happened with TeX @Knuth89 during the '80s, Typst still needs to mature and expand over the years.

Finally, although not its intention, the online service typst.app can also be used as a scientific preprint dissemination platform. Scientific preprint repositories like arXiv#footnote[https://arxiv.org] and HAL#footnote[https://hal.science] already play a crucial role in the rapid publication of research findings across various academic disciplines @Chaleplioglou23. These platforms allow researchers to share their work publicly before it undergoes formal peer review, enabling immediate access to new ideas and results.

#let image-width = 100%
#figure(
  placement: none,
  //caption: [Some journal Typst-based templates already qualified to be used for editorial pourposes: _Joint Accelerator Conferences Website_#footnote[https://jacow.org], _Journal of Machine Learning Research_#footnote[https://www.jmlr.org], _Institute of Electrical and Electronics Engineers_#footnote[https://ieee.org], and _Multidisciplinary Digital Publishing Institute_#footnote[https://mdpi.com]],
  caption: [Some Typst-based journal templates already qualified to be used for editorial purposes: _Institute of Electrical and Electronics Engineers_#footnote[https://ieee.org], and _Multidisciplinary Digital Publishing Institute_#footnote[https://mdpi.com]],
  grid(
    columns: (1fr, 1fr),
    column-gutter: 2pt,
    gutter: 5pt,
    image("ieee.jpg", width: image-width), image("mdpi.jpg", width: image-width),
  ),
) <fig:papers>

#let Touying = package-link("Touying")
#let Unify = package-link("Unify")
#let Finite = package-link("Finite")
#let Tiaoma = package-link("Tiaoma")
#let Problemst = package-link("Problemst")
#let Quill = package-link("Quill")
#let Siunitx = ctan-link("Siunitx")

= Typst Universe <sec:universe>
Typst Universe#footnote[http://typst.app/universe] is an online platform that offers a curated collection of templates and packages designed to automate Typst documents. Users can find resources ranging from thesis templates to visualization tools, all aimed at simplifying the document creation process. The platform allows users to search, browse categories, and submit their own contributions, fostering a collaborative environment. Some of the packages present in this site are briefly described in @tab:packages.
#figure(
  placement: none,
  caption: [Some of the most reputed packages in Typst Universe],
  table(
    columns: (0.9fr, 4fr),
    align: (right, left),
    stroke: 0.01cm,
    table.header([*Package*], [*Description*]),
    table.hline(),
    Touying,
    [A powerful package for creating presentation slides.],
    Unify,
    [Simplifies the typesetting of numbers, units, and ranges, similar to LaTeX's #Siunitx package @Wright11.],
    Finite,
    [Renders finite automata diagrams using #CeTZ.],
    Tiaoma,
    [A barcode generator that supports various barcode types by compiling Zint to WebAssembly.],
    Problemst,
    [Template for problem sets, homework, or assignments.],
    Quill,
    [#Quill is a package for quantum circuit diagrams#footnote[https://github.com/Mc-Zen/quill].],
  ),
) <tab:packages>






= Application of Typst for theoretical Physics <sec:theophys>
Typst's robustness, powerful features and intuitive syntax make it an all-in-one tool to create texts with publication-quality figures. For instance, Penrose-Carter diagrams (PCd) are a way of sketching the entire spacetime of a given spacetime manifold in general relativity on a single, finite sheet of paper. By applying a _conformal_ transformation (one that preserves angles but adjusts distances), these diagrams bring infinity to a finite boundary while preserving the light cone structure, so that the global causal layout is immediately visible. PCd simplify the understanding of black holes, cosmological models, and other relativistic effects. In Typst, it is possible to create them using the #CeTZ package. For instance, the PCd associated to the Kruskal extension of the Schwarzschild spacetime is displayed in @fig:penrose-carter.

#figure(
  include "penrose-carter diagram.typ",
  caption: [Penrose-Carter diagram of the Schwarzschild manifold
    //The $I$ region corresponds to the exterior (universe) region, the $I I$ region corresponds to the interior of the black hole, the $I I I$ corresponds to a parallel exterior region and the $I V$ region is the interior of a white hole. Moreover, $i^(plus.minus)$ denotes future/past temporal infinity, $scr(I)^(plus.minus)$ denotes future/past null infinity and $i^(0)$ denotes spatial infinity @Wald84.
  ],
)<fig:penrose-carter>

In addition to spacetime visualizations, Typst's #CeTZ package can be applied in particle physics through the creation of Feynman diagrams. Physicists relate the initial and final states of a physical system via the scattering matrix, or S-matrix @Peskin95. The S-matrix is a complex object that has to be perturbatively calculated as a sum of infinite terms. Feynman diagrams are pictorial representations of these terms, each depicting one of the potentially infinite interaction processes that lead to the same final state. A Feynman diagram for the $e^(+) e^(-) arrow.r e^(+) e^(-)$ scattering process at one-loop order in QED is depicted in @fig:feynman-diagram.

#figure(
  placement: none,
  include "feynman diagram.typ",
  caption: [A Feynman diagram for the $e^(+) e^(-) arrow.r e^(+) e^(-)$ at one loop order. The $e^(+)$ and $e^(-)$ annihilate, producing a photon ($gamma$). This photon then becomes a virtual electron-positron pair, which subsequently produces another photon. Finally, the photon becomes the scattered $e^(-)$ and $e^(+)$],
) <fig:feynman-diagram>

#let Commute = package-link("Commute")

Another common diagram type in math and present in some branches of theoretical physics, is the commutative one. For example, in @Giachetta09, when speaking of classical field theory on fiber bundles, the commutative diagram shown in @fig:commutative-diagram appears, and we can reproduce it using the #Commute package, a library designed to draw such diagrams.

#import "@preview/commute:0.3.0": *

#figure(
  placement: none,
  commutative-diagram(
    node-padding: (32pt, 30pt),
    node((0, -1), $dots$, "dots_upper"),
    node((0, 0), $cal(O)^(n-1)_infinity$, "n-1"),
    node((0, 1), $cal(O)^(n)_infinity$, "n"),
    node((0, 2), $cal(O)^(n+1)_infinity$, "n+1"),
    node((0, 3), $cal(O)^(n+2)_infinity$, "n+2"),
    node((0, 4), $dots$, "dots_upper_right"),
    node((1, -1), $dots$, "dots_lower"),
    node((1, 0), $cal(O)^(0, n-1)_infinity$, "0, n-1"),
    node((1, 1), $cal(O)^(0, n)_infinity$, "0, n"),
    node((1, 2), $bold(E)_(1)$, "E_1"),
    node((1, 3), $bold(E)_(2)$, "E_2"),
    node((1, 4), $dots$, "dots_lower_right"),
    arr("dots_upper", "n-1", ""),
    arr("n-1", "n", $d$),
    arr("n", "n+1", $d$),
    arr("n+1", "n+2", $d$),
    arr("n+2", "dots_upper_right", ""),
    arr("n-1", "0, n-1", $h_(0)$),
    arr("n", "0, n", $h_(0)$),
    arr("n+1", "E_1", $rho$),
    arr("n-1", "0, n-1", $h_(0)$),
    arr("n+2", "E_2", $h_(0)$),
    arr("dots_lower", "0, n-1", ""),
    arr("0, n-1", "0, n", $d_(H)$),
    arr("0, n", "E_1", $delta$),
    arr("E_1", "E_2", $delta$),
    arr("E_2", "dots_lower_right", ""),
  ),
  // Translate/rephrase?
  caption: [Cochain morphism of the de Rham complex of the differential graded algebra $cal(O)^(*)_infinity$ of all exterior forms on finite order jet manifolds (modulo pull-back identification) to its variational complex @Giachetta09],
) <fig:commutative-diagram>

The flexibility of the #CeTZ package enables the creation of a wide range of diagrams, while many other packages specialize in convenience and ease of use. Moreover, the near real-time output preview, intuitive syntax and possibility of collaboration enable Typst to be used as a tool to develop concepts in Physics and Math, not just communicate them via papers, books, etc.


#import "@preview/physica:0.9.5": *
#import "@preview/unify:0.7.1": add-prefix, add-unit, num, numrange, qty, qtyrange, unit
#import "@preview/mannot:0.3.0": *
// Wait for https://github.com/aargar1/atomic/pull/3 in Typst Universe.
#import "@preview/atomic:1.0.0": atom
#import "@preview/typsium:0.2.0": ce

#let Mannot = package-link("Mannot")

= More on mathematics and scientific notation <sec:moremath>
== Annotated Mathematics

The #Mannot#footnote[https://github.com/ryuryu-ymj/mannot] package stands out as a didactic enhancement for mathematical documents. It enables authors to label and annotate individual parts of equations (@fig:mannot), offering an effective means to clarify and explain their components step by step.

#figure(
  placement: none,
  caption: [#Mannot;-annotated math expression],
  v(3em) + $
    mark(V_g, tag: #<vg>, color: blueunir) eq.triple
    markrect(hat(k), tag: #<k>, color: #blue) crossproduct
    markhl(\(1/(rho f), tag: #<rhof>, color: blueunir) markul(grad P, tag: #<gradientp>, color: #black)
    #annot(<vg>, pos: left, dx: -2.0em)[Geostrophic wind])
    #annot(<k>, pos: top + left, dy: -1.0em, leader-connect: "elbow")[Vertical axis]
    #annot(<rhof>, pos: top + right, dy: -2.0em, leader-connect: "elbow")[Density and Coriolis force]
    #annot(<gradientp>, pos: top + right, dy: -1.0em)[Pressure gradient]#v(2em)
  $,
) <fig:mannot>


Using #Mannot, authors can insert visual callouts alongside concise textual explanations that are aligned with terms or sub-expressions within a formula. This approach transforms dense mathematical notation into explanatory material that is well-suited for textbooks, lectures, or tutorials. This can be taken even further when the same concept or equation is marked in the same color throughout the text. That way, the reader can connect the different parts and concepts much faster.

The annotations are customizable in terms of style and positioning, allowing authors to fine-tune the didactic layout. The result is a document that not only presents mathematical content but also actively facilitates learning and comprehension.

== Physics and Chemistry
Scientific typesetting can be cumbersome, but packages like the aforementioned #Physica make it much more straightforward. #Physica provides concise, compact and semantically meaningful commands for advanced mathematical notation, ranging from vector calculus to tensor and quantum-mechanical expressions. For vector calculus, `grad`, `curl` and `div` or `laplacian` can be used: $curl f$, $div arrow(v)$, $grad phi$, $laplacian u$. With specific commands for differentials and derivatives, first-order, mixed partials, and higher orders are automatically formatted. For instance, the code `$dd(x), dv(T, t), pdv(P, x), pdv(rho, y, 2)$` renders as: $ dd(x), dv(T, t), pdv(P, x), pdv(rho, y, 2). $
// If quad is added in the preview, it must be added in the code.

// #grid(
//   columns: (3.5fr, 1fr),
//   gutter: 1em,
//   [Regarding matrix and tensor operations, Hessian matrices can be written as easily as a single line: `$hmat(f; x, y)$`, which renders the matrix on the right.],
//   $hmat(f; x, y)$,
// )


Tensors are just as simple for abstract index notation: $tensor(h, +mu, +nu)$. For quantum mechanics, there is the bra-ket notation: $bra(u) "and" ket(u)$.

#let Typsium = package-link("Typsium")
#let Atomic = package-link("Atomic")

Isotopes can be easily typeset with the #Typsium package. Example: $isotope("Bi", a: 211, z: 83) -> isotope("Tl", a: 207, z: 81) + isotope("He", a: 4, z: 2)$. There's even a way to visualize digital signals with convenient built-in functions (@fig:signals).

#figure(
  placement: none,
  caption: [Signals rendered with the #Physica package],
  $
    "clk:" & signals("|1....|0....|1....|0....|1....|0....|1....|0..", step: #0.5em, color: blueunir) \
    "bus:" & signals(" #.... X=... ..... ..... X=... ..... ..... X#.", step: #0.5em, color: blueunir)
  $,
) <fig:signals>

For Chemistry, formulas and reactions can be easily written with #Typsium: #ce("[Co(H2O)6]^(2+) + 4Cl^- <-> [CoCl4]^(2-) + 6H2O"). And if drawing atoms is needed, the package #Atomic comes in handy (@fig:atom).

#figure(
  kind: image,
  placement: none,
  caption: [Atom shells rendered with the #Atomic package],
  grid(
    columns: (2.2fr, 1fr),
    gutter: 1em,
    ```typ
    #import "@preview/atomic:1.0.0": atom

    #atom(8, 16, "O", (2, 6)
    ```,
    atom(8, 16, "O", (2, 6), step: 0.34, center: 0.4, orbitals: .7, color: softblueunir),
  ),
) <fig:atom>


#import "kanban.typ": kanban, kanban-column, kanban-item
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.8": codly-languages
#import "@preview/chronos:0.2.1"
#import "@preview/suiji:0.4.0": gen-rng-f, random-f
#import "gantty.typ": gantt
#import "@preview/cetz:0.3.4"


#set scale(reflow: true)
#show: codly-init
#show raw: set text(font: "Fira Code")
#show raw.where(block: true): set par(justify: false, leading: 0.5em)
#codly(
  zebra-fill: softblueunir,
  number-align: right,
  stroke: stroke(blueunir),
  languages: codly-languages,
)





= Application of Typst for Computer Science <sec:cs>

Computer Science (CS) is a diverse field that covers algorithms and information
theory, as well as computer hardware and software. The Typst ecosystem can already accommodate it with many general-purpose packages and even more niche ones.

== Algorithms & hardware
#let Algorithmic = package-link("Algorithmic")
#let Matofletcher = package-link("Matofletcher")
#let Truthfy = package-link("Truthfy")

For example, to visualize algorithms, the #Algorithmic package can be used for creating pseudocode syntax. Also, the #Matofletcher package (an abstraction over the #Fletcher one) turns out very useful for creating flowcharts, as shown in @fig:flowchart.

#figure(
  {
    set text(font: "Liberation Sans")
    set par(justify: false, leading: 0.3em)
    show: raw-size.with(0.9em)
    scale(95%, include "flowchart diagram.typ")
  },
  caption: [Example of a flowchart created with #Matofletcher],
) <fig:flowchart>







#CeTZ package has a _built-in_ "tree" library that can be used, for example, to illustrate merge sort algorithm (@fig:tree).

#figure(
  scale(85%, include "tree example.typ"),
  caption: [Example of a tree diagram created with #CeTZ's _tree_ library],
  placement: none,
) <fig:tree>

The #Diagraph package enables the inclusion of DOT diagrams @Gansner09 directly inside any document by using Wasm to render them without the need for an external software like  Graphviz (@fig:cart-prod).
#import "@preview/diagraph:0.3.6": render
#figure(
  placement: none,
  kind: image,
  align(horizon, grid(
    columns: 2,
    table(
      columns: 2,
      table.header[$A$][$B$],
      [🛼], [💧],
      [🦋], [🪼],
      [🐬], [🪼],
      [🩵], [🪼],
      [], [🥶],
    ),
    render(read("cartesian product.dot"), width: 98%),
  )),
  caption: [Diagram of a Cartesian product of two emoji sets created with Wasm, Graphviz and the #Diagraph package],
) <fig:cart-prod>


#let Zap = package-link("Zap")
#let Circuiteria = package-link("Circuiteria")

For creating truth tables, there is #Truthfy package that can create a table from a logical expression. For hardware, there are several circuit diagram packages:
/ #Zap: draws electronic circuits that are aligned with IEC and IEEE/ANSI standards.
/ #Circuiteria: draws block circuit diagrams for a more abstract layer.
/ #Quill: draws quantum circuit diagrams with concise syntax.

== Software
#let Codly = package-link("Codly")
#let ReXLlenT = package-link("ReXLlenT")
#let Chronos = package-link("Chronos")
#let Pintorita = package-link("Pintorita")

A prominent part of Computer Science is software and software engineering. For that, Typst has:
/ Built-in listings: with automatic syntax highlighting (or custom
  parsers/themes), that can be further enhanced with #Codly (@fig:listing).
/ Built-in data loading: functions for JSON, CSV, XML, etc. (or XLSX with #ReXLlenT) for generating native tables or #Lilaq graphs.
/ Sequence diagrams: provided by #Chronos (@fig:sequence).
/ Activity, class, component, entity relationship: and other diagrams can be created with Pintora text-to-diagram JavaScript library bundled as a Typst #Pintorita package, however due to inherited Wasm limitations these diagrams can significantly increase compilation time, i.e., up to several seconds. As an example, @fig:compiler was also created with this package.

#let sequence-diagram = chronos.diagram(width: 70%, {
  import chronos: *
  _par("A", display-name: "Alice", show-bottom: false, color: softblueunir)
  _par("B", display-name: "Bob", show-bottom: false, color: softblueunir)
  _par("C", display-name: "Charlie", show-bottom: false, color: softblueunir)
  _par("D", display-name: "Derek", show-bottom: false, color: softblueunir)
  let style = (lifeline-style: (fill: blueunir))
  _seq("A", "B", comment: "hello", enable-dst: true)
  _seq("B", "B", comment: "self call", enable-dst: true)
  _seq("C", "B", comment: "hello from thread 2", enable-dst: true, ..style)
  _seq("B", "D", comment: "create", create-dst: true)
  _seq("B", "C", comment: "done in thread 2", disable-src: true, dashed: true)
  _seq("B", "B", comment: "rc", disable-src: true, dashed: true)
  _seq("B", "D", comment: "delete", destroy-dst: true)
  _seq("B", "A", comment: "success", disable-src: true, dashed: true)
})

#figure(
  text(font: "Liberation Sans", sequence-diagram),
  caption: [Example of a sequence diagram created with #Chronos],
) <fig:sequence>


Typst scripting language can tackle a lot of problems, such as preprocessing and visualizing data, implementing algorithms (sort, search, calendar-related, BNF-based recursive decent parser, Nassi–Shneiderman designs, etc.), generating raster images based on raw pixel data (supporting different pixel encodings), modifying SVG images with simple or regex-based substring replacement.

#let Matryoshka = github-link("freundTech/typst-matryoshka")[Matryoshka]

#let listing = ```rust
fn area_of_circle(radius: f64) -> f64 {
    std::f64::consts::PI * radius * radius
}

fn main() {
    let area = area_of_circle(3.0);
    println!("A is {}", area);
}
```

#let listing2 = ```javascript
function areaOfCircle(radius) {
  return Math.PI * radius * radius;
}

const area = areaOfCircle(3);
console.log(`Area is ${area}`);
```

#figure(
  placement: none,
  listing + v(-0.5em) + listing2,
  caption: [Styled sample codes in Rust and JavaScript (with #Codly)],
  kind: image,
) <fig:listing>

There are other several packages that ship with Wasm plugins for different language compilers and interpreters, such as:
/ #Pyrunner: for Python using RustPython,
/ #Jogs: (commented in @sec:computed) for JavaScript using QuickJS, or
/ #Matryoshka: for running Typst inside Typst.

Another notable limitation within Wasm-based packages is that network and input/output (I/O) operations do not work, but there is a possibility of passing project-local files to these add-ons. The second, and more impactful constraint, is their slower execution. With time, it can be worth porting some functions and algorithms to native Typst to significantly decrease compilation time.

#let Prequery = package-link("Prequery")

The #Prequery package provides the ability to specify metadata regarding extra information associated to a document. This metadata then can be extracted with `typst query` command to be used by, for instance, an external Python script. That way, the workflow requires one compilation without assets (to get the metadata), one run of the external preprocessor (i.e., the Python script) to gather the fetched metadata, and a second compilation with the necessary distilled data. This kind of preprocessing allows for fully automated creation of report-like documents.

#let Eqalc = package-link("Eqalc")
#let IDWTET = package-link("IDWTET")

Similarly, a LaTeX-based math expression can be directly used as-is through the #MiTeX package. Finally, with the #Eqalc package, it is possible to convert a math expression to a native Typst function that can be evaluated and whose result can be plotted or tabulated (@fig:eqalc).

#codly-disable()

#figure(
  code-grid("eqalc example.typ", left-column: 1.9fr),
  caption: [A math function $f(t)$ being translated/evaluated to/by Typst.],
  kind: image,
  placement: none,
) <fig:eqalc>



== Other use cases <cs-other>
#let Self-Example = package-link("Self-Example")
#let pdf-embed = link(
  "https://typst.app/docs/reference/pdf/embed/",
  `pdf.embed`,
)
#let Gantty = package-link("Gantty")
#let Timeliney = package-link("Timeliney")

The #eval-func function allows writing the code only once while showing both the result and its associated source. Packages like #Self-Example and #IDWTET provide useful abstractions. Reproducibility often requires saving full source code or images. Typst's #pdf-embed function allows embedding arbitrary byte sequences as files within a PDF, which can later be extracted if needed.


#let gantt_yaml = yaml("gantt.yaml")
// Change, for instance, the color of the milestones
#let gant_style = (
  gridlines: (
    table: (stroke: (paint: blueunir), thickness: 1pt),
  ),
)
#{ gantt_yaml.style = gant_style }
From a management perspective, creating Gantt charts is possible with packages like #Timeliney and #Gantty (@fig:gantt), while kanban board can be created with the Kantan package (@fig:kanban).
#figure(
  placement: none,
  scale(65%, gantt(gantt_yaml)),
  caption: [Example of a Gantt chart designed with the #Gantty package],
) <fig:gantt>

#figure(
  {
    set align(left)
    set par(justify: false)
    // @typstyle off
    kanban(
      font-size: 0.59em,
      font: "Liberation Sans",
      kanban-column("Backlog", color: red,
        kanban-item(stroke: rgb("#FF5733"))[41][high][Authorization and data validation],
        kanban-item(stroke: rgb("#33FF57"))[18][high][Cart API integration],
        kanban-item(stroke: rgb("#8D33FF"))[18][medium][City dropdown menu],
        kanban-item(stroke: rgb("#FF33A1"))[7][medium][Dynamic cart item count],
        kanban-item(stroke: rgb("#33C1FF"))[5][medium][Main page prototype],
        kanban-item(stroke: rgb("#8D33FF"))[1][low][Tests for cart API],
      ),
      kanban-column("Work in progress", color: yellow,
        kanban-item(stroke: rgb("#FF5733"))[7][medium][John][Checkout page],
        kanban-item(stroke: rgb("#FF0000"))[18][medium][John][Stock availability check],
        kanban-item(stroke: rgb("#33FF57"))[18][medium][Olivia][Add/remove book tests],
        kanban-item(stroke: rgb("#33C1FF"))[7][medium][Stephen]["About Us" page layout],
      ),
      kanban-column("Testing", color: aqua,
        kanban-item(stroke: rgb("#FF5733"))[18][high][John][Add-to-cart API],
        kanban-item(stroke: rgb("#33C1FF"))[5][medium][Emily]["Contact Us" page],
        kanban-item(stroke: rgb("#FFC300"))[5][medium][Alex]["News" page mockup],
      ),
      kanban-column("Done", color: green,
        kanban-item(stroke: rgb("#FFC300"))[50][high][Michael][Books database],
        kanban-item(stroke: rgb("#FF33A1"))[32][high][Stephen][Books catalog with filters],
        kanban-item(stroke: rgb("#33FF57"))[1][low][Arthur]["About Us" page mockup],
      ),
    )
  },
  kind: image,
  caption: [Example of a Kanban board made with the Kanban package],
  placement: none,
) <fig:kanban>



For sharing and distributing small amount of information, a QR code and other barcodes have proven helpful. They can be generated and customized via the #Tiaoma package, using a Wasm version of Zint.

= Slide composition <sec:slides>
Typst can be extended for slide creation through the #Touying package, which provides a flexible framework similar in spirit to LaTeX's Beamer @Hofert10. With #Touying, users can design presentation slides directly in Typst, benefiting from its concise syntax, powerful layout capabilities, and smooth PDF output. The package supports themes, overlays, and structured elements, making it easy to control the visual style while focusing on content. #Touying enables the creation of consistent, professional slides with minimal boilerplate. This makes it especially appealing for academic and technical presentations where precision, readability, and customization are key (@fig:slides).

#figure(
  image("./slide example/example.pdf", width: 98%),
  kind: image,
  caption: [A slide (with complex content) created with the #Touying package],
  placement: none,
) <fig:slides>

= Conclusions <sec:conclusions>
Typst is a markup language for typesetting documents, combining ease of use, speed, and versatility. It transforms plain text files with markup into polished PDFs. Ideal for long-form writing, Typst excels at creating essays, articles, scientific papers, books, reports, and homework assignments. It also shines in technical fields, such as Mathematics, Physics, and Engineering thanks to its robust support for mathematical notation. Additionally, its powerful styling and automation capabilities make it perfect for document sets with a consistent design, like a book series or branded publications.

= CRediT Authorship Contribution Statement
#format-credit-section()

= Data Statement
The research does not involve the use of external data. All figures and tables have been generated dinamically in Typst and associated packages.

= Declaration of Conflicts of Interest
We have no conflict of interest to declare.

= Acknowledgment
Authors would like to express their gratitude to the Typst community, with a special focus on their two creators and main developers, Martin Haug and Laurenz Mädje, for their invaluable contributions. They would also love to thank the Editorial Board of IJIMAI for taking a leap of faith regarding the inclusion of Typst as a default mechanism to submit scientific papers.

