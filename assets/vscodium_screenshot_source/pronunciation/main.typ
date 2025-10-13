#import "@preview/rubby:0.10.2": get-ruby
#import "@preview/ascii-ipa:2.0.0": branner

#set page(height: auto)
#set text(font: ("Libertinus Serif", "Noto Serif CJK JP"))
#set par(justify: true)

// Properly handle smartquote in get.text
// https://github.com/jneug/typst-tools4typst/pull/10
#let get-text(element, sep: "") = {
  if type(element) == content {
    if element.has("text") {
      element.text
    } else if element.has("children") {
      element.children.map(get-text).join(sep)
    } else if element.has("child") {
      text(element.child)
    } else if element.has("body") {
      text(element.body)
    } else if repr(element.func()) == "space" {
      " "
    } else if element.func() == smartquote {
      if element.double { "\"" } else { "'" }
    } else if element.func() == ref {
      if type(element.target) == label { "@" + str(element.target) }
    } else {
      ""
    }
  } else if type(element) in ("array", "dictionary") {
    return ""
  } else {
    str(element)
  }
}

#let ruby = get-ruby()
#let ipa(branner-notation) = [/#branner(get-text(branner-notation))/]

One potential problem when learning a new language can be pronunciation. For
example, for a native Russian speaker, it can be challenging to pronounce words
in English, Spanish, or Japanese.

In the case of English, the notorious "TH" sound (i.e., #ipa[d-] as in "this" or
#ipa[O-] as in "thing") makes it very difficult to sound fluent. A simple "the"
article comes out as "зэ" (#ipa['zE]) or "зе" (#ipa['zj^e]), simply because
Russian does not have an equivalent to the "TH" sound.

As for Spanish, the "G" sound in Russian, as in "аллигатор"
(#ipa[a&lj^I'gat@r]), is _harder_. For example, the word "juego" (#ipa['fweg"o])
has a distinctively _softer_ "G." The closest pronunciation would be "фуэго"
(#ipa[fu'Ego]) or "фуэхо" (#ipa[fu'Exo]).

And lastly, although some Japanese moras
#footnote[https://en.wikipedia.org/wiki/Mora_(linguistics)] have perfect matches
in Russian, there are still some hurdles to becoming fluent. For example,
#ruby[らくご][落語] (#ipa[r"a_km&+ᵝgo="]) has ら in the beginning, which is
represented as "ra" in rōmaji
#footnote[https://en.wikipedia.org/wiki/Romanization_of_Japanese], but it is
pronounced neither like "ра" ("ra") nor like "ла" ("la"), even though native
speakers would identify them as the same sound.

This is why understanding how sounds are created in the mouth is important. And,
of course, practice makes perfect.
