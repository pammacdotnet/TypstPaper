#import "@local/ijimai:0.0.3": *
#let conf = toml("paper.toml")
#let author-photos = conf.authors.map(author => read(author.name + ".jpg", encoding: none))
#show: ijimai.with(
  conf: conf,
  photos: author-photos,
  logo: image("unir logo.svg", width: 17.5%),
  bib-data: read("bibliography.bib", encoding: none),
)
#set text(lang: "en")

#let latex = {
  set text(font: "New Computer Modern")
  box(
    width: 2.55em,
    {
      place(top, dx: 0.3em, text(size: 0.7em)[L])
      place(top, dx: 0.3em, text(size: 0.7em)[A])
      place(top, dx: 0.7em)[T]
      place(top, dx: 1.26em, dy: 0.22em)[E]
      place(top, dx: 1.8em)[X]
    },
  )
}

//#show "LaTeX": latex

= Introduction
#first-paragraph(
  first-word: "Typst",
)[is a new markup-based typesetting language (and its associated tooling ecosystem) for technical and scientific documents. It is designed to be an alternative both to advanced tools like LaTeX and simpler tools like Word and Google Docs.
  Our goal with Typst is to build a typesetting tool that is highly capable and a pleasure to use @Madje2022 @Haug2022.
]
With Typst, it is possible to:

- Create professional-quality documents with ease.
- Access extensive functionality, including advanced mathematical typesetting, effective figure management, and an automatically generated table of contents.
- Utilize powerful templates that automatically apply consistent formatting during the writing process.
- Benefit from high-quality typographical output with improved justification and overall layout.
- View changes instantly with real-time preview functionality.
- Clear and understandable error messages for efficient corrections.
- Apply a consistent styling system to configure fonts, margins, headings, lists, and other elements uniformly.
- Work with familiar programming constructs (no complex macros).
- Collaborate seamlessly with team members.
- Modify document formatting at any time.

Let me know if you'd like this tailored to a specific audience (e.g., developers, academics, businesses).


#show raw.where(block: true): block.with(
  fill: luma(250),
  inset: 4pt,
  radius: 2pt,
)

#show raw: set text(size: 6.5pt, font: "Fira Code")

#let code-example(typ-file) = {
  let typ = read(typ-file)
  grid(
    columns: (2.5fr, 1.5fr),
    rows: (auto, auto),
    gutter: 1pt,
    raw(typ, lang: "typst", block: true), text(size: 7.5pt)[#eval(typ, mode: "markup")],
  )
}

#code-example("example1.typ")

= LaTeX and Typst
Typst and LaTeX are both markup-based typesetting systems, but they differ in several key aspects. Typst employs a more intuitive syntax, similar to Markdown, for common tasks, makisssssng it more accessible. Its commands are designed to work consistently, reducing the need to learn different conventions for each package. Additionally, Typst offers significantly faster compilation times, often completing in milliseconds, which allows for instant previews in its web app and compiler. Unlike LaTeX, Typst doesn't require boilerplate code to start a new document; simply creating an empty text file with a `.typ` extension suffices. Furthermore, Typst provides flexibility in usage, offering both a web-based editor and a lightweight local compiler that downloads packages on-demand, keeping installations minimal.


#figure(
  align(center)[#table(
      columns: (1fr, 2fr, 2fr),
      align: (auto, auto, auto),
      table.header([Feature], [LaTeX], [Typst]),
      table.hline(), stroke: .01cm,
      [#strong[Syntax];], [Command-based
        (`\command{arg}`)], [Markdown-inspired (`= Heading`, `_italic_`) +
        code mode (`#func()`)],
      [#strong[Math Mode];], [`$...$` or `\[...\]`, verbose
        (`\frac{}{}`)], [`$...$`, concise (`1/2` auto-fractions, `phi.alt`
        for variants)],
      [#strong[Headings];], [`\section{}`, `\subsection{}`], [`= Heading`,
        `== Subheading` (no backslashes)],
      [#strong[Lists];], [`itemize`/`enumerate` environments], [`-`
        (bullets), `+` (numbers), `/ Term:` (descriptions)],
      [#strong[Commands];], [Macros
        (`\newcommand`)], [First-class functions (`#let f(x) = x + 1`),
        composable],
      [#strong[Compilation];], [Slow (seconds), multi-pass], [Fast
        (milliseconds), incremental],
      [#strong[Packages];], [Large TeX Live/MiKTeX
        distributions], [On-demand downloads, lean local cache],
      [#strong[Error Messages];], [Cryptic], [User-friendly, detailed],
      [#strong[Graphics];], [TikZ, PSTricks, etc.], [SVG-based (e.g.,
        CeTZ), no PDF/EPS support],
      [#strong[Team work];], [Overleaf (third-party)], [Built-in web
        app (real-time collaboration)],
      [#strong[Code blocks];], [Limited (e.g., `listings`
        package)], [Tight scripting integration (e.g.,
        `#for x in range(3)[...]`)],
      [#strong[Citations];], [BibTeX/biblatex], [Built-in (`@citekey`), no
        external `.bib` required],
      [#strong[Deploy];], [Heavy (GBs)], [Single binary (\~20MB)],
    )],
  kind: table,
  caption: [Main differences between LaTeX and Typst],
)

= The markup language
Typst is a markup language for typesetting documents, combining ease of use, speed, and versatility. It transforms plain text files with markup into polished PDFs.
Ideal for long-form writing, Typst excels at creating essays, articles, scientific papers, books, reports, and homework assignments. It also shines in technical fields, such as mathematics, physics, and engineering thanks to its robust support for mathematical notation. Additionally, its powerful styling and automation capabilities make it perfect for document sets with a consistent design, like a book series or branded publications.

Typst employs straightforward markup syntax for standard formatting operations. For instance, headings can be created by prefixing a line with the `=` symbol, while text can be italicized by enclosing it in `_underscores_`.

Typst employs three distinct syntactical modes: Markup, Math, and Code. By default, a Typst document operates in Markup mode, which handles standard text formatting. Math mode enables the composition of mathematical expressions, while Code mode provides access to Typst's scripting capabilities for dynamic content generation.

Transitions between these modes are governed by specific syntactic markers, as outlined in @tab:modes:

/*
Hablar de Unicode
*/
#figure(
  table(
    columns: (0.55fr, 1.5fr, 1.7fr),
    inset: 5pt,
    align: left,
    stroke: .01cm,
    table.header(
      [*Mode*],
      [*Syntax*],
      [*Example*],
    ),

    [Code], [Prefix code with \#], raw("Number: #(1 + 2)", lang: "typ"),
    [Math], [Surround math with \$…\$], raw("$-x$ is the opposite of $x$", lang: "typ"),
    [Markup], [Put markup in \[…\]], raw("#let name = [*Typst!*]", lang: "typ"),
  ),
  caption: [Typst syntactical modes],
) <tab:modes>


= The compiler and Command-Line interface
Typst's compiler operates differently from traditional compilers by using a reactive model that tracks dependencies and selectively re-evaluates only the modified parts of a document. This enables instant previews during editing, as the system interprets layout instructions, styling rules, and content in real time. A consistent styling system and an intelligent layout engine work together to resolve these elements efficiently, supporting complex features like math typesetting, dynamic templates, and figures while maintaining responsiveness.

The compilation itself follows a structured yet flexible process. First, the input text is parsed into an abstract syntax tree (AST) using Typst's grammar rules, followed by static analysis to resolve imports, variables, and functions. After type checking and evaluating expressions, the AST is transformed into an intermediate representation (IR) containing layout directives. The compiler then computes the final document layout using a constraint-based algorithm to determine positioning, sizing, and breaks (such as pages or lines). Finally, it renders the output (e.g., PDF) based on the resolved layout. This incremental approach ensures that updates are processed efficiently, minimizing recomputation when changes occur.

== Unicode
Typst embraces Unicode as a first-class citizen, making it much more modern and intuitive than traditional typesetting systems like LaTeX.
- You can write math expressions using actual Unicode symbols, not just commands.
#code-example("unicode math example.typ")
Since Unicode is supported, you can copy and paste from websites, PDFs, or papers, and Typst will preserve the symbols.
It’s easier to type on modern keyboards or input editors, especially for Greek, arrows, mathematical operators, etc.
Typst's Unicode support makes it:

More user-friendly than LaTeX
Easier to read and write
Flexible for modern, international, and symbolic typesetting


== Styling
Typst makes styling documents easy, flexible, and consistent with a modern and declarative approach — kind of like CSS but built for typesetting.
- Markup-Based Styling
- Typst uses functions (called constructs) that take arguments or keyword parameters for styling.
- You can apply consistent styles across the whole document using set.
- You can define your own constructs:

Key Advantages Over LaTeX/CSS:

No cryptic commands – Styles are defined logically.
Programmable – Use loops, conditions, and functions.
Scoped – Avoid global side effects.
Unified syntax – No separate "style files" (though you can modularize).

Styling in Typst is rule-based and cascades through the document structure.
Local Overrides with set and block

4. Reusable Styles with Functions (Let + Show)
5. Selectors & Queries

Target specific content using filters:

// https://chat.deepseek.com/a/chat/s/9d249fb7-2a5c-4399-84ed-4fe0b6909e8f

== Web technologies
Typst leverages WebAssembly (WASM) to enable its core functionalities to run efficiently in web environments @Haas2017. This approach allows Typst to execute its typesetting engine directly within web browsers, facilitating seamless integration into web-based applications and services. By compiling its Rust-based codebase to Wasm, Typst ensures consistent performance across different platforms without the need for native installations. This strategy not only enhances accessibility but also simplifies the deployment process, making Typst a versatile tool for developers and content creators alike.

The Neoplot package for Typst is a specialized tool designed to integrate Gnuplot @Janert16, a powerful open-source plotting engine, into Typst documents. It enables users to create high-quality graphs, charts, and mathematical visualizations directly within Typst by executing Gnuplot scripts or processing data files

#code-example("neoplot example.typ")

// Hayagriva

// https://typst.app/docs/reference/model/


= Math
Typst has robust support for mathematical expressions, allowing you to seamlessly integrate math into your documents. It's math mode is designed to be intuitive for LaTeX users while being more concise and integrated into the document syntax.
#code-example("physica example.typ")

= Web application


​The `diagraph` package is a Typst extension that allows users to embed Graphviz diagrams directly within Typst documents.
#code-example("diagraph example.typ")

= Typst Universe
Typst Universe is an online platform that offers a curated collection of templates and packages designed to enhance and automate Typst documents. Users can find resources ranging from thesis templates to visualization tools, all aimed at simplifying the document creation process. The platform allows users to search, browse categories, and submit their own contributions, fostering a collaborative environment for Typst users.

#figure(
  align(center)[#table(
      columns: (1fr, 4fr),
      align: (right, left), stroke: 0.01cm,
      table.header([Package], [Description]),
      table.hline(),
      [#strong[touying];], [A powerful package for creating presentation
        slides in
        Typst.],
      [#strong[unify];], [Simplifies the typesetting of numbers, units,
        and ranges, similar to LaTeX's
        `siunitx`.],
      [#strong[finite];], [Renders finite automata diagrams using
        CeTZ.],
      [#strong[tiaoma];], [A barcode generator that supports various
        barcode types by compiling Zint to
        WebAssembly.],
      [#strong[problemst];], [Provides a simple template for problem sets,
        homeworks, or
        assignments.],
    )],
  kind: table,
)


#code-example("cetz example.typ")
= Declaration of conflicts of interest
We just want to declare our love to Typst and IJIMAI.
= Acknowledgment
Thanks, Typst!
