#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "@preview/fontawesome:0.6.0": *
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly
#import "utils.typ": *

// Pdfpc configuration
// typst query --root . ./example.typ --field value --one "<pdfpc-file>" > ./example.pdfpc
#let pdfpc-config = pdfpc.config(
    duration-minutes: 30,
    start-time: datetime(hour: 14, minute: 10, second: 0),
    end-time: datetime(hour: 14, minute: 40, second: 0),
    last-minutes: 5,
    note-font-size: 12,
    disable-markdown: false,
    default-transition: (
      type: "push",
      duration-seconds: 2,
      angle: ltr,
      alignment: "vertical",
      direction: "inward",
    ),
  )

// Theorems configuration by ctheorems
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-common(
    // handout: true,
    preamble: pdfpc-config,
    show-bibliography-as-footnote: bibliography(title: none, "bibliography.bib"),
  ),
  config-info(
    title: [SISTEMI DI CONTROLLO VERSIONE],
    subtitle: [Laboratorio su Git e GitHub],
    author: author_list(
      (
        (first_author("Leonardo Micelli"), "leonardo.micelli@uniurb.it"),
      ), logo: "images/uniurb.svg"
    ),
    date: datetime(day: 31, month: 03, year: 2025).display("[day] [month repr:long] [year]"),
  ),
)

#set text(font: "Fira Sans", weight: "light", size: 20pt)
#show math.equation: set text(font: "Fira Math")

#set raw(tab-size: 4)
// #show raw: set text(size: 0.85em)
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: (x: 1em, y: 1em),
  radius: 0.7em,
  width: 100%,
)
#show raw.where(block: true): set text(size: 0.75em)

#show bibliography: set text(size: 0.75em)
#show footnote.entry: set text(size: 0.75em)

#set list(marker: box(height: 0.65em, align(horizon, text(size: 2em)[#sym.dot])))

#let emph(content) = text(weight: "bold", style: "italic", content)
#show link: set text(hyphenate: true)

// #set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

// == Outline <touying:hidden>

// #components.adaptive-columns(outline(title: none, indent: 1em))

== Tenere traccia delle modifiche
Vi è mai capitato, durante un progetto, di dover tornare indietro a una versione precedente del codice?
Come avete tenuto traccia della storia del progetto?
=== L'intuizione
- Copiare ed incollare il progetto in una nuova cartella
- Se va bene con una convenzione di nomi "decente" tipo `progetto_v1`, `progetto_v2`, ...

=== Tuttavia...
- Difficile tenere traccia esattamente di cosa è cambiato tra una versione e l'altra
- Difficile collaborare in team: come si fa a tenere traccia di chi ha fatto cosa?
- Come scelgo i singoli cambiamenti da includere in una versione?

== Collaborare in team
Avete mai dovuto sviluppare un progetto in un team? Come avete organizzato e suddiviso il lavoro? Come avete tenuto traccia di chi ha fatto cosa e come avete integrato i contributi di tutti?

=== Altre grandi intuizioni
- "Invio" il progetto al mio collega via email, lui lo modifica e me lo rimanda indietro
- Magari usiamo un servizio di condivisione file tipo Google Drive, Dropbox, OneDrive, ...

== Sistemi di controllo versione (aka Version Control System, VCS)
Sono sistemi che permettono di:
- *Tenere traccia* delle modifiche fatte nel tempo
- *Tornare indietro* a versioni precedenti
- Collezionare *metadati* su chi ha fatto cosa e quando
- *Riconciliare (merging)* i contributi di più persone, anche se fatti in parallelo sugli stessi file
- Sviluppare *parallelamente* e a distanza con altri membri del team

I VCS moderni sono spesso *distribuiti*, ovvero ogni collaboratore ha una copia completa del progetto, con tutta la sua storia, sul proprio computer (*Distributed Version Control System, DVCS*).

== Git
il più figo di tutti

== Git: concetti base
=== Repository
=== Staging area
=== Commit
=== Branch
=== Remote
=== Clone
=== Fetch
=== Merge
=== Rebase
=== Pull
=== Push

== GitHub
proprio lui

=== Fork

=== Pull request