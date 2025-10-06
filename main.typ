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

== La storia di un progetto software
La storia di un progetto software appare lineare:
#figure(image("images/linear.svg"))

#pagebreak()

Ma cosa succede quando le cose non funzionano al primo colpo?
#figure(image("images/errors.svg"))

#pagebreak()

Si torna indietro *(rollback)* ad una versione funzionante e si riparte da lì.
#figure(image("images/branch.svg"))

== Sviluppo parallelo
Alice e Bob lavorano insieme ad un progetto, dopodiché entrambi tornano a casa e decidono di continuare autonomamente il loro lavoro. Abbiamo una storia *divergente*:
#figure(image("images/collaboration.svg"))

#pagebreak()

Serve dunque un modo di *riunire* i loro contributi
#figure(image("images/merge.svg"))

== DVCS: concetti base
=== Repository
Contiene tutti i *metadata* del progetto, ovvero:
- le informazioni necessarie al rollback dei cambiamenti
- info su chi ha eseguito i cambiamenti e quando
- date
- le *differenze* tra una versione e l'altra

Solitamente la repository è una directory nascosta all'interno della radice del progetto (non interagiremo direttamente con essa)

#pagebreak()

=== Working Tree 
(o *worktree* o *working directory*)
Contiene i file del progetto su cui lavoriamo, esclusi i metadata, che sono contenuti nella repository

#pagebreak()

=== Commit
Uno stato salvato del progetto.
- colleziona i *cambiamenti* necessari per passare dallo stato precedente (*parent*) a quello corrente (tecnica chiamata *differential tracking*)
- contiene altri metadata (autore, data, messaggio descrittivo, id del commit, ...)

Di fatto, un commit costituisce uno *snapshot* del progetto.

#pagebreak()

=== Branch
Una sequenza di commit collegati tra loro, ai quali si può accedere tramite una *lable* (es. `main`, `feature-x`, ...)

#pagebreak()

=== Commit reference
Per essere in grado di tornare ad una versione specifica del progetto, bisogna fare *riferimento* ad uno specifico commit.

Esempi validi di commit reference:
- l'id del commit (es. `a1b2c3d4`)
- il branch (es. `main`)
- *HEAD*: si riferisce all'ultimo commit del branch corrente e viene automaticamente aggiornato ad ogni nuovo commit. Ci si può riferire anche a commit in relazione ad HEAD, ad esempio `HEAD~2` si riferisce al commit che è due posizioni prima di HEAD (più comodo che scrivere id tipo `"Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn"`)

Le commit reference vengono spesso chiamate *tree-ish*

#pagebreak()

=== Checkout
L'operazione che permette di spostare HEAD verso uno specifico tree-ish, ovvero:
- un commit preciso, spesso precedente ad HEAD (rollback)
- un branch

#pagebreak()

== L'evoluzione di un progetto
Nelle prossime slide vedremo cosa succede esattamente a mano a mano che un progetto software evolve nel tempo

#pagebreak()

#figure(image("images/project-evo-1.svg"))

#pagebreak()

Oh no! Abbiamo scoperto un bug `:((((`
#figure(image("images/project-evo-2.svg"))

#pagebreak()

Sappiamo che il progetto sicuramente funzionava al commit 3, possiamo quindi tornare a quel commit e ripartire da lì:
#figure(image("images/project-evo-3.5.svg"))

n.b. in questo modo stiamo solo spostando HEAD ad un commit precedente, i commit 4 e 5 sono ancora lì, non sono stati cancellati

#pagebreak()

Adesso, individuato il bug abbiamo nuovamente un progetto funzionante, possiamo quindi salvare il nostro lavoro con un nuovo commit, creando anche un nuovo branch:
#figure(image("images/project-evo-4.svg"))

#pagebreak()

Ora però ci rendiamo conto che nel commit 4 c'erano degli aggiornamenti interessanti, che vogliamo integrare nel nostro nuovo branch. Per farlo, dobbiamo *unire* (merge) i due branch:
#figure(image("images/project-evo-5.svg"))

== Git
Git è il DVCS più usato al mondo, creato da Linus Torvalds nel 2005 per supportare lo sviluppo del kernel Linux.
- Open source
- Più veloce di altri VCS (scritto in C)
- Distribuito


#pagebreak()

Git è un `tool da linea di comando(CLI)`, ed è così che verrà usato in questa lezione. Esistono anche interfacce grafiche, che sconsigliamo perché:
- sono soggette a cambiamenti più frequenti rispetto alla CLI (cosa succede se il bottone che usavo non c'è più?)
- possono esporre più complessità di quelle che affronteremo nel corso (cosa rispondo al pop-up "squash when merging"?)
- difatto si interpongono tra noi ed il tool
- una volta imparata la CLI, sarete talmente efficienti che un'interfaccia grafica vi rallenterà soltanto

== Operazioni base con Git: Configurazione

La configurazione di Git avviene a due livelli:
- *globale:* impostazioni valide per tutto il sistema
- *locale:* impostazioni valide solo per la repository corrente. Hanno precedenza rispetto alle globali
TL;DR: configurare globalmente in maniera sensata il tool e localmente solo quando serve.

*git config* è il comando utilizzato per configurare Git. 
- se eseguito con opzione --global, le impostazioni saranno globali, altrimenti locali
- usage: git config [--global] category.option value

#pagebreak()

=== Esempi

*Username ed email:*

```shell
git config --global user.name "Mario Rossi"
git config --global user.email "mariorossi@email.com"
```

*Editor di default:*
Siccome alcune operazioni fanno apparire automaticamente un editor di testo, possiamo configurare l'editor da usare in questi casi:

```shell
git config --global core.editor nano
```

#pagebreak()

*Nome di default per il primo branch*
Solitamente il primo branch di una repository agisce anche da branch principale. Nomi convenzionalmente usati sono `main` o `master`

```shell
git config --global init.defaultbranch main
```

== Inizializzare una repository
*git init*
- inizializza una nuova repository Git nella directory corrente
- crea una sottodirectory nascosta `.git` che conterrà tutti i metadata della repository
- la direcory contenente la cartella `.git` diventa la *root* della repository
  - fate attenzione ad eseguire il comando *dentro* la directory che sarà la root del vostro progetto
  - evitate di inizializzare repository dentro altre repository (per quello c'è il meccanismo dei *submodule*, che però non tratteremo)

Se vi rendete conto di aver inizializzato una repository nella directory sbagliata, potete semplicemente cancellare la cartella `.git` (attenzione: perderete tutta la storia del progetto)

== Staging
In git, esiste il concetto di *stage* (o staging area o index)
- i cambiamenti, per diventare commit, devono prima essere aggiunti allo stage
- un commit "prende" i cambiamenti dallo stage e li salva nella repository

```shell
git add <files>    #aggiunge i cambiamenti dei file specificati allo stage
git reset <files>  #rimuove i file specificati dallo stage
git commit         #crea un nuovo commit con i cambiamenti attualmente nello stage
```
== Osservare lo stato della repository
È fondamentale avere sempre sotto controllo lo stato della repository:
- in quale branch siamo?
- quali file sono stati modificati?
- quali file sono nello stage?

#pagebreak()

Per farlo, si usa il comando *git status*
```shell
git status
On branch master
Your branch is up to date with 'origin/master'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   content/_index.md
        new file:   content/dvcs-basics/_index.md
        new file:   content/dvcs-basics/staging.png

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   layouts/shortcodes/gravizo.html
        modified:   layouts/shortcodes/today.html
```

== Fare un commit
- Richiede un *autore* ed *email* configurati (globalmente o localmente)
- Richiede un *commit message*. È molto importante che il messaggio sia conciso ma descrittivo dei cambiamenti apportati (raccomandiamo il formato #link("https://www.conventionalcommits.org/en/v1.0.0/#summary", "Conventional Commits")).
- una *data*, ricavata automaticamente
- un *id (hash crittografico)*, calcolato automaticamente

```shell
git commit -m "feat: add initial project structure"   #il flag -m permette di specificare il commit message inline. Altrimenti il default editor apparirà per scriverlo
```

== Ignorare files
Solitamente non si vuole tenere traccia di *tutti* i files del progetto:
- alcuni potrebbero essere files temporanei, generati automaticamente (es. file di log, file di build, ...)
- altri possono essere ri-generati facilmente (es. file di output, ...)
- altri ancora potrebbero contenere informazioni sensibili (es. file di configurazione con password, ...)

è possibile dire a git di ignorare automaticamente certi files, creando un file `.gitignore` nella root della repository, con dentro i nomi (o pattern) dei files da ignorare.

#pagebreak()

Esempio di file `.gitignore`:
```
# ignore the bin folder and all its contents
bin/
# ignore every pdf file
*.pdf
# rule exception (beginning with a !): pdf files named 'myImportantFile.pdf' should be tracked
!myImportantFile.pdf
```