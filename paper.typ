#import "@local/ijimai:0.0.4": *
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
      place(top, dx: 0.1em, dy: .02cm, text(size: 0.7em)[L])
      place(top, dx: 0.3em, text(size: 0.7em)[A])
      place(top, dx: 0.7em)[T]
      place(top, dx: 1.26em, dy: 0.22em)[E]
      place(top, dx: 1.8em)[X]
    },
  )
}

//#show "LaTeX": latex

#let code-example(typ-file, caption) = {
  let typ = read(typ-file)
  figure(
    placement: top,
    kind: image,
    caption: caption,
    grid(
      columns: (2.5fr, 1.5fr),
      rows: (auto, auto),
      gutter: 1pt,
      raw(typ, lang: "typst", block: true), text(size: 7.5pt)[#eval(typ, mode: "markup")],
    ),
  )
}

= Introduction
#first-paragraph(
  conf: conf,
  first-word: "Typst",
)[is a new markup-based typesetting language (and its associated tooling ecosystem) for technical and scientific documents. It is designed to be an alternative both to advanced tools like LaTeX and simpler tools like Word and Google Docs. The goal with Typst is to build a typesetting tool that is highly capable, extensible, reliable, fast and a pleasure to use. For instance, with Typst, it is possible to:]

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

The Typst ecosystem comprises a refined and simple to use/understand markup language for defining the content, structure and style of a document, a superfast (and community-driven) document renderer, and a companion web application tha enables real-time in-browser compilation. All these components will be explored in @sec:markup, @sec:compiler and @sec:typstapp, respectively.
Besides, the project also hosts a repository of extensions, packages and templates, Typst Universe, discussed in @sec:universe. However, given that Typst is often compared (and even set to rival) against the reputed and consolidated TeX/LaTeX systems, we will start with quick comparison of both environments.


#show raw.where(block: true): block.with(
  fill: luma(250),
  inset: 4pt,
  radius: 2pt,
)

#show raw: set text(size: 6.5pt, font: "Fira Code")



= Typst and LaTeX <sec:latex>
Typst and LaTeX @Knuth86@Lamport94 are both markup-based typesetting systems, but they differ in several key aspects. Regarding the language and its syntax, Typst employs more intuitive semantics, similar to those found in Markdown @Voegler14, making it cleaner and more accessible. Its commands are designed to work consistently, reducing the need to learn different conventions for each _package_ (tackled in @sec:package). Here it is a side-by-side example:
#let affine-typ = read("affine example.typ")
#let affine-tex = read("affine example.tex")

#figure(
  placement: none,
  kind: table,
  caption: "Quick Typst vs. LaTeX comparison.",
  grid(
    columns: (1fr, 1fr),
    rows: (auto, auto),
    gutter: 5pt,
    column-gutter: 3.0pt,
    align(center)[#text(font: "Buenard", fill: rgb("#229cac"), weight: "extrabold", "Typst")], align(center, latex),
    raw(affine-typ, lang: "typst", block: true), raw(affine-tex, lang: "latex", block: true),
  ),
)

Focusing on the renderer and local installs, Typst offers significantly faster and incremental compilation times, often completing in milliseconds, which allows for shockingly fast instant previews (under the so called _Doherty threshold_ @Doherty82). The compiler (tackled in @sec:compiler) is a single lightweight binary that, when necessary, downloads external packages on-demand, keeping installations minimal and secure. All operations take place in _userland_ (no need for admin priviledges).

Regarding the operating procedure, unlike LaTeX, Typst does not require boilerplate code/project to start a new document: simply creating an empty text file with a `.typ` extension suffices. To make things even simpler, the proyect hosts its own online editing service (discussed in @sec:typstapp). Currently, in the LaTeX world, this can only be achieved through external cloud solutions, such as Overleaf @Ewelina20.

#figure(
  align(center)[#table(
      columns: (1fr, 2.0fr, 2.0fr),
      align: (auto, left, left),
      table.header([Feature], [#latex], [#text(font: "Buenard", fill: rgb("#229cac"), weight: "extrabold", "Typst")]),
      table.hline(), stroke: .01cm,
      [Syntax], [Command-based
        (`\command{arg}`)], [Markdown-inspired (`= Heading`, `_italic_`) +
        code mode (`#func()`)],
      [Math Mode], [`$...$` or `\[...\]`, verbose
        (`\frac{}{}`)], [`$...$`, concise (`1/2` auto-fractions, `phi.alt`
        for variants)],
      [Headings], [`\section{}`, `\subsection{}`], [`= Heading`,
        `== Subheading` (no backslashes)],
      [Lists], [`itemize`/`enumerate` environments], [`-`
        (bullets), `+` (numbers), `/ Term:` (descriptions)],
      [Commands], [Macros
        (`\newcommand`)], [First-class functions (`#let f(x) = x + 1`),
        composable],
      [Compilation], [Slow (seconds), multi-pass], [Fast
        (milliseconds), incremental],
      [Packages], [Large TeX Live/MiKTeX
        distributions], [On-demand downloads, lean local cache],
      [Error Messages], [Cryptic], [User-friendly, detailed],
      [Graphics], [TikZ, PSTricks, etc.], [SVG-based (e.g.,
        CeTZ), no PDF/EPS support],
      [Team work], [Overleaf (third-party)], [Built-in web
        app (real-time collaboration)],
      [Code blocks], [Limited (e.g., `listings`
        package)], [Tight scripting integration (e.g.,
        `#for x in range(3)[...]`)],
      [Citations], [BibTeX/biblatex], [Built-in (`@citekey`), no
        external `.bib` required],
      [Deploy], [Heavy (GBs)], [Single binary (\~20MB)],
    )],
  kind: table,
  caption: [Main differences between LaTeX and Typst],
)

= State of the art

== Typesetting systems
Modern typesetting relies heavily on computers, with most printed materials now created digitally rather than through traditional methods like typewriters or movable type. Professional desktop publishing tools such as Adobe InDesign and QuarkXPress offer precise control over elements like kerning and ligatures, while more general-purpose tools like Microsoft Word have adopted some of these features @Chagnon02. Still, these general tools lack the full suite of typesetting capabilities, such as high-quality hyphenation or the ability to flow text across multiple custom regions. This gap has led to the use of text-based systems, especially in academia, where LaTeX dominates due to its powerful formula rendering and flexible layout control.

These systems rely on compiling source text into formatted outputs like PDFs, separating content from presentation to allow easy reuse and adaptation of document styles @Clark07. Typesetting systems are designed not only to produce high-quality visual documents but also to support the complex process of creating structured content. A well-designed system must consider numerous layout features such as line and page breaking, kerning, ligatures, contextual glyph positioning, and the treatment of languages with varied directionalities. Additionally, avoiding formatting issues like widows and orphans is part of achieving professional-quality results. However, this visual precision is only one side of the coin. These systems must also support complex content like sections, tables, and figures in a structured manner (@tab:typesetting). Markup-based systems excel here by explicitly encoding structural elements, thereby enabling automation and content abstraction. In contrast, WYSIWYG (_What you see is what you get_) systems lack this abstraction, limiting automation and making them less suitable for large-scale or highly structured documents.

#figure(
  caption: "Main challenges and their ad hoc algorithms and approaches related to markup-based typesetting systems",
  align(center)[#table(
      columns: (1fr, 2fr, 2fr),
      align: (auto, auto, auto), stroke: .01cm,
      table.header([#strong[Challenge];], [#strong[Description];], [#strong[Algorithm/Approach];]),
      table.hline(),
      "Paragraph breaking", [Breaking text into lines with
        aesthetically pleasing spacing/hyphenation], [Knuth-Plass line
        breaking algorithm @Hassan15.],
      [Justification], [Spacing so lines align evenly at margins without looking awkward], [Variable spacing adjustments using the Knuth-Plass model @Knuth81],
      [Column Balancing], [Ensuring multi-column layouts have
        equal or visually balanced content], [Multiple layout passes with
        measurement and balancing heuristics],
      [Grid Layout], [Pptimal space for
        rows/columns in grids], [Constraint-based layout calculation @Feiner98],
      [Footnote Placement], [Footnotes appear on the same page as references, adjusting breaks], [Intelligent page-breaking with constraints and fallback layout strategies],
      [Content Collision], [Text wrapping non-rectangular elements], [Line reshaping with contour-aware logic],
      [Page Breaking], [Page division while respecting layout], [Greedy +
        backtracking algorithms @Plass81],
      [Text Shaping (Glyph Selection)], [Selecting the correct
        glyphs depending on context], [Font shaping and
        context-sensitive glyph substitution @Rougier18],
      [Bidirectional Text], [Mixing LTR and
        RTL scripts], [Unicode
        Bidirectional Algorithm @Toledo01],
      [Incremental Layout Caching], [Reusing layout computations
        after small edits to avoid full re-layouts], [Constraint-based
        layout cache with region-based reuse],
      [Incremental Parsing], [Re-parsing only
        changed parts of the document], [Red-Green Tree structure with subtree reuse],
      [Styling and Theming], [Consistent styles across documents], [Style scope, cascades, and programmable layouts],
      [Dynamic Layout], [Layout based on runtime-determined values], [Cyclical re-evaluation with convergence],
      [Unicode], [Modern scripts, ligatures, and grapheme clusters], [Shaping and grapheme line breaking @Elkhayati2022],
    )],
  kind: table,
) <tab:typesetting>

Historically, the development of markup-based systems began in the 1960s with tools like Runoff and evolved significantly with systems like Troff @Barron87 and TeX. Troff brought enhanced typographic features to Unix environments, while TeX revolutionized typesetting with its advanced paragraph layout algorithms and extensible macro system. LaTeX, built on top of TeX, pushed the concept further by introducing descriptive markup, where authors focus on the logical structure of content rather than its appearance. Parallel to this, systems like GML, SGML, and eventually HTML and XML developed the idea of defining structure through custom tags @Derose97, with SGML forming the basis for later web standards. Over time, styling systems like CSS and XSL emerged to handle the transformation of structured content into presentational formats @Cole00. Yet, limitations persisted, such as verbosity in XML and complexity in LaTeX customization.


#figure(image("typesetting systems.svg", width: 98%), kind: image, caption: "Evolution of Typessetting technologies")


Recent efforts in the typesetting world have aimed at modernizing or replacing older systems. Lightweight languages like Markdown and AsciiDoc prioritize ease of use but sacrifice typesetting power. On the other hand, advanced systems like LuaTeX @Pegourie13 attempt to extend or replace TeX while maintaining its output quality. However, these often inherit TeX's core limitations, like performance or syntax issues. LaTeX has slowly evolved with modular improvements like the L3 programming layer and a new hook system @Mittelbach24. Nevertheless, many challenges remained unsolved, especially around usability, accessibility, automation and a significantly improved user experience. We believe that the arrival of Typst will mark a turning point in all of these issues.

== Computed documents
Modern document languages increasingly blend static content with dynamic computation, creating powerful tools for authoring rich, interactive documents. However, this combination often leads to subtle challenges in how content and code interact. For instance, template systems can behave unpredictably when computation and document structure are mixed, and reactivity features may not account for changes in document layout. These issues become especially noticeable in systems like PHP, React, and Scribble, where document behavior can be unintuitive or error-prone without careful design. To better understand and prevent these issues, a structured approach is needed to analyze and model the behavior of document languages @Crichton24.

One way to address this is by introducing a formal model that categorizes document languages according to their structure and computational features. This model is based on two key dimensions: the type of content being generated (plain strings or structured articles) and the level of expressiveness used to generate that content (ranging from simple literals to full programming constructs). Combining these dimensions produces a hierarchy of eight distinct language levels. Each level represents common features found in real-world systems, from basic string operations to sophisticated template logic that can interpolate variables, execute loops, and build hierarchical content. By modeling these levels carefully, it's possible to define clear semantics that make document behavior more predictable and composable.

Beyond this foundation, the model supports advanced document features like internal references, automatic structuring of content (such as grouping text into paragraphs or sections), and interactive behavior. These capabilities often require staged or global evaluation, meaning parts of a document must be processed multiple times or in relation to other parts. For example, generating section numbers or updating interactive components based on user actions involves runtime logic that must integrate smoothly with the document's structure. The formal approach enables precise reasoning about these behaviors, ensuring that features like templates and reactivity are both expressive and well-behaved. This leads to document languages that are not only more powerful but also more reliable and easier to use.


== Dynamic document generator

Typst is a powerful markup-based typesetting system designed to dynamically generate documents by seamlessly blending content and computation. Unlike static tools like LaTeX, Typst allows users to programmatically manipulate document elements through its built-in scripting capabilities. For instance, templates can be defined as functions that apply consistent styling across documents, while loops and conditionals enable dynamic content generation based on input data . The language's value semantics ensure predictable behavior, avoiding side effects and making it easier to reason about document transformations . Typst also supports reactive features, such as auto-updating references and bibliographies, which adjust dynamically as the document evolves .

For example, Typst can generate a conference paper template with dynamic author lists and abstracts. Using a function like `conf(title, authors, doc)`, users can pass structured data (e.g., author names and affiliations) to automatically format the document . Another example is programmatically embedding JSON data into a document: Python scripts can pass JSON strings to Typst, which decodes and iterates over the values to generate tables or lists. Additionally, the `tidy` package demonstrates dynamic documentation generation by parsing doc-comments and rendering them with live code examples . These features make Typst ideal for automating reports, academic papers, and other data-driven documents.


Knitr @Xie18, Sweave @Leisch02, and similar computational document systems, such as RMarkdown and Jupyter Notebooks, integrate code execution with document authoring, allowing authors to embed live code chunks that produce figures, tables, and statistical results within a narrative. These systems are particularly prevalent in data science and scientific writing, where reproducibility is crucial. Built on top of LaTeX or Markdown, they provide a powerful, albeit often complex, workflow that couples typesetting with dynamic content generation. In contrast, Typst offers a more unified and modern approach: rather than embedding a separate scripting language into markup, it merges typesetting and computation into a single, consistent language. This seamless integration allows Typst to support sophisticated layout logic and styling without the verbosity or complexity found in systems like Sweave or RMarkdown, while still maintaining programmability and automation. Additionally, Typst’s focus on user-friendly syntax and strong computational foundations makes it more accessible and ergonomic, especially for users outside of traditional data analysis workflows.

For instance, the package #link("https://typst.app/universe/package/pyrunner")[pyrunner] allows the execution of almost arbitrary chunks of Python code within a Typst document. Example:

#let pyrunner-typ = read("pyrunner example.typ")

#raw(pyrunner-typ, lang: "typ", block: true)


= The markup language <sec:markup>
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


== Unicode
Typst embraces Unicode as a first-class citizen, making it much more modern and intuitive than traditional typesetting systems like LaTeX.
- You can write math expressions using actual Unicode symbols, not just commands.
#code-example("unicode math example.typ", "unicode math example.typ")
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

No cryptic commands - Styles are defined logically.
Programmable - Use loops, conditions, and functions.
Scoped - Avoid global side effects.
Unified syntax - No separate "style files" (though you can modularize).

Styling in Typst is rule-based and cascades through the document structure.
Local Overrides with set and block

4. Reusable Styles with Functions (Let + Show)
5. Selectors & Queries

Target specific content using filters:

// https://chat.deepseek.com/a/chat/s/9d249fb7-2a5c-4399-84ed-4fe0b6909e8f

== Control structures
Control structures in Typst are familiar and intuitive, much like those in mainstream programming languages. It supports standard constructs like `if`, `for`, `while`, `break`, `continue`, and `return`, which behave in expected ways. These can be used not only for logic and mutation but also for composing content. For example, a `for` loop can dynamically generate repeated pieces of content, and if enclosed in square brackets `[ ... ]` instead of curly braces `{ ... }`, the loop body is treated as content and gets rendered directly in the output. Typst also supports destructuring and content joining within loops, making it powerful for building structured documents programmatically.

Additionally, Typst includes short-circuiting with `and` and `or`, which act as control structures by conditionally skipping the evaluation of the second operand based on the first. This allows patterns like `x or y` to avoid runtime errors—e.g., when `y` would raise an error if `x` isn’t false. Interestingly, these operators are expressive enough to replicate `if/else` behavior entirely. Overall, Typst's control flow is simple but flexible, and thoughtfully integrated with its content model, allowing for a seamless blend of logic and layout.

XXX Artículo de Typst as a Language

= The compiler and Command-Line interface <sec:compiler>
Typst's compiler operates differently from traditional compilers by using a reactive model that tracks dependencies and selectively re-evaluates only the modified parts of a document @Haug22. This enables instant previews during editing, as the system interprets layout instructions, styling rules, and content in real time @Madje22. A consistent styling system and an intelligent layout engine work together to resolve these elements efficiently, supporting complex features like math typesetting, dynamic templates, and figures while maintaining responsiveness.

== Rust
The compilation itself follows a structured yet flexible process. First, the input text is parsed into an abstract syntax tree (AST) using Typst's grammar rules, followed by static analysis to resolve imports, variables, and functions. After type checking and evaluating expressions, the AST is transformed into an intermediate representation (IR) containing layout directives. The compiler then computes the final document layout using a constraint-based algorithm to determine positioning, sizing, and breaks (such as pages or lines). Finally, it renders the output (e.g., PDF) based on the resolved layout. This incremental approach ensures that updates are processed efficiently, minimizing recomputation when changes occur.

Typst's choice of Rust @Klabnik23 as its underlying programming language provides several key benefits, including high performance, safety, and modern tooling. Rust's efficiency allows Typst to compile documents significantly faster than traditional LaTeX systems, with benchmarks showing near-instantaneous updates after initial compilation (e.g., 200ms for changes in a 77-page document). The language's memory safety guarantees prevent common bugs like data races, which is critical for a typesetting system handling complex document structures. Additionally, Rust's strong type system and zero-cost abstractions enable Typst to implement features like cross-platform development, including WebAssembly for browser-based tools.

== Abstraction and mutation
Abstractions in Typst enables users to manage
complexity by hiding irrelevant details through two primary mechanisms:

- Functions. Typst functions are defined using `let` syntax and support positional arguments, optional named arguments with defaults, and "argument sinks" for variadic inputs. A key convenience is the shorthand for passing content as the last argument using brackets (`[...]`). Functions implicitly join multiple content pieces and return them without requiring an explicit `return` statement, streamlining common use cases like document formatting. However, the section notes that functions in Typst lack explicit return types or visibility modifiers, which could aid in abstraction.

- Modules. Typst conflates modules with files, simplifying the language design. Modules can be imported (`#import`) or inlined (`#include`), but they lack privacy controls: every `let` binding in a module is public by default. This leaks implementation details, undermining abstraction. A workaround involves wrapping public exports in a `let` block, but the document suggests adding an `export` (or `pub`) keyword to explicitly mark public items, improving encapsulation.

Typst, highlights implicit copying to prevent side effects. This enables as a trade-off between predictability and performance.


== Value semantics
Typst employs value semantics, meaning values are treated as if they are copied whenever they are passed or modified. This approach prevents unintended side effects and simplifies reasoning about code. For instance, modifying a dictionary inside a function or during iteration does not affect the original structure because the function or loop receives a copy. This avoids common pitfalls such as cyclic data structures, iterator invalidation, and unintended global mutations. As a result, code becomes easier to test and debug, and features like multi-threading are safer and simpler to implement. In Typst, even function arguments and global variables behave as immutable within the scope of a function, reinforcing this isolation.

Although value semantics suggest potential performance costs due to frequent copying, Typst mitigates this with copy-on-write—data is only duplicated when it's modified and shared across references. This offers a practical balance between performance and clarity. Unlike some languages that explicitly distinguish between owned and shared data, Typst keeps its model simple and implicit, which aligns well with its role as a typesetting tool. Users can focus on layout and content without needing to understand or manage complex memory models. Overall, Typst’s use of value semantics contributes to a clean, reliable programming experience tailored to document creation.


== Modules
Typst's other form of abstraction is modules. It conflates modules with files, which I think is
reasonable for its aims. It's already dealing with all of typesetting, it should keep the language
simple. There are 2.5 ways to "import" a module:

- `#import "foo.typ"` --- puts `foo` in scope. Then you can write `foo.helper` to access what's
  defined with `let helper = ...` in "foo.typ".
- `#import "foo.typ": helper` --- puts `helper` directly in scope, so that you don't need to prefix
  it with `foo.helper` every time you use it.
- `#include "foo.typ"` --- inlines the _content_ from "foo.typ". Importantly, style settings that
  were set by "foo.typ" don't contaminate the current file; you _only_ get its content. (Much more
  on style settings later.)

This is _almost_ well done, except for the fact that modules don't give you any way to mark items as
public or private! Thus every `let` statement in the whole module is exported, even ones like
`let horrible-fiddly-details-no-one-needs-to-know`. There's an
#link("https://github.com/typst/typst/issues/4534")[open issue] with a good discussion of the
tradeoffs of different approaches, but no decision yet about how to move forward.

You can effectively make some items private if you're willing to wrap the whole module in a `let`
that defines the public items:

XXX Todo es público

Still, it's disappointing that every `let` in a module is public. This means modules aren't really an abstraction, since the implementation details leak out unless you go out of your way to use a pattern like the above to hide them.

== Packages <sec:package>
As with LaTeX, Typst also supports the addition of functionalities via packages. A Typst package is a self-contained collection of Typst source files and assets, structured around a mandatory `typst.toml` manifest file located at the package root. This manifest specifies essential metadata such as the package's `name`, `version`, and `entrypoint`, which points to the main `.typ` file to be evaluated upon import. Additional optional fields like `authors`, `license`, and `description` can also be included. The internal organization of the package is flexible, allowing authors to structure files and directories as they see fit, provided that the `entrypoint` path is correctly specified. All paths within the package are resolved relative to the package root, ensuring encapsulation and preventing access to files outside the package. Packages are typically stored in a directory hierarchy following the pattern `{namespace}/{name}/{version}` and can be imported into Typst documents using the syntax `#import "@{namespace}/{name}:{version}"`. For local development or experimentation, packages can be placed in designated local data directories, making them accessible without publishing to the shared repository.

== Web technologies <sec:wasm>
Typst leverages WebAssembly (WASM) to enable its core functionalities to run efficiently in web environments @Haas17. This approach allows Typst to execute its typesetting engine directly within web browsers, facilitating seamless integration into web-based applications and services. By compiling its Rust-based codebase to Wasm, Typst ensures consistent performance across different platforms without the need for native installations. This strategy not only enhances accessibility but also simplifies the deployment process, making Typst a versatile tool for developers and content creators alike.

The Neoplot package for Typst is a specialized tool designed to integrate Gnuplot @Janert16, a powerful open-source plotting engine, into Typst documents. It enables users to create high-quality graphs, charts, and mathematical visualizations directly within Typst by executing Gnuplot scripts or processing data files

#code-example("neoplot example.typ", "neoplot example")

// Hayagriva

// https://typst.app/docs/reference/model/
//https://yurichev.com/mirrors/knuth1989.pdf
//

== Security <sec:sec>
The Typst compiler ensures safety by implementing strict security measures that prevent potentially harmful operations during document compilation. It restricts file access to the project's root directory, disallowing reading or writing files outside this scope, thereby safeguarding against unauthorized data access. Additionally, Typst prohibits features like shell escapes and network requests, which could otherwise be exploited for arbitrary code execution or data exfiltration (that currently may take place in the TeX-sphere @Lacombe21 @Kim24). These design choices collectively create a secure environment, making Typst safe to use even with untrusted input.

= Math
Typst has robust support for mathematical expressions, allowing you to seamlessly integrate math into your documents. It's math mode is designed to be intuitive for LaTeX users while being more concise and integrated into the document syntax.
#code-example("physica example.typ", "Physica example")

= Web application <sec:typstapp>
XXX ,Overleaf or other alternatives like Papeeria and Authorea. These two offer similar collaborative LaTeX editing capabilities but have smaller user bases. PLMlatex, developed by the French National Centre for Scientific Research (CNRS), is a French-language LaTeX editor based on the open-source version of Overleaf. It provides a user interface and functionality closely resembling Overleaf, though it lacks certain premium features. CoCalc also supports LaTeX editing alongside tools for calculations, research, and collaboration. All these services may suffer from security vulnerabilities, as commented in @sec:sec.

The Typst.app (@fig:typstapp) online editor is a collaborative, web-based platform designed for creating and typesetting documents with Typst, a modern markup-based typesetting system. It offers a seamless writing experience with features like instant preview, syntax highlighting, and autocompletion, making it ideal for drafting academic papers, technical reports, and other long-form documents. The editor splits the interface into two panels: a source panel for writing Typst markup and a preview panel that renders the document in real time. Users can easily format text, insert images, equations, and bibliographies, and leverage Typst's scripting capabilities for advanced customization. The web app also supports collaboration through the WebSockets standard @Lombardi2015, allowing users to share projects, track changes, and integrate with tools like Zotero and Mendeley for reference management.

The development team is actively working on improvements, including better mobile usability and additional features like offline PWA support and private templates for teams. The editor is available for free with basic features, while a Pro subscription unlocks advanced capabilities like Git integration, presentation mode, and increased storage.

XXX uso como repositorio de papers como Arxiv o HAL

XXX todo se está yendo a la nube @Corbi23

​The `diagraph` package is a Typst extension that allows users to embed Graphviz diagrams directly within Typst documents.

#figure(
  image("typstapp.jpg", width: 100%),
  scope: "parent",
  placement: auto,
  caption: [A curious figure.],
) <fig:typstapp>

#code-example("diagraph example.typ", "diagraph example.typ")

#figure(image("universe.jpg"), placement: bottom, scope: "parent")
= Typst Universe <sec:universe>
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
  caption: "Una tabla",
  placement: top,
)



= IDEs

#figure(image("vscode.jpg"), kind: image, caption: "An IDE. ")


#code-example("cetz example.typ", "CetZ example.")

= Conclusions
Typst is a markup language for typesetting documents, combining ease of use, speed, and versatility. It transforms plain text files with markup into polished PDFs. Ideal for long-form writing, Typst excels at creating essays, articles, scientific papers, books, reports, and homework assignments. It also shines in technical fields, such as mathematics, physics, and engineering thanks to its robust support for mathematical notation. Additionally, its powerful styling and automation capabilities make it perfect for document sets with a consistent design, like a book series or branded publications.

= Declaration of conflicts of interest
We just want to declare our love to Typst and IJIMAI.
= Acknowledgment
Thanks, Typst!
