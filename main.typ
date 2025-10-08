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

Il DVCS più usato al mondo, che utilizzeremo durante il corso, è *Git*.

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

== Before we start: Configurazione di Git

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

```shell-unix-generic
git config --global user.name "Mario Rossi"
git config --global user.email "mariorossi@email.com"
```

*Editor di default:*
Siccome alcune operazioni fanno apparire automaticamente un editor di testo, possiamo configurare l'editor da usare in questi casi:

```shell-unix-generic
git config --global core.editor nano
```

#pagebreak()

*Nome di default per il primo branch*
Solitamente il primo branch di una repository agisce anche da branch principale. Nomi convenzionalmente usati sono `main` o `master`

```shell-unix-generic
git config --global init.defaultbranch main
```

#pagebreak()

== DVCS e Git: concetti base
=== Repository
Contiene tutti i *metadata* del progetto, ovvero:
- le informazioni necessarie al rollback dei cambiamenti
- info su chi ha eseguito i cambiamenti e quando
- date
- le *differenze* tra una versione e l'altra

Solitamente la repository è una directory nascosta all'interno della radice del progetto (non interagiremo direttamente con essa).

#pagebreak()

In git, per creare una repository si usa il comando `git init`:

```shell
cd                  #mi sposto nella home directory
mkdir pmo-lab-git   #creo una cartella per il progetto
cd pmo-lab-git      #mi sposto dentro la cartella
git init            #inizializzo una repository git
```

Si può ispezionare la repository con:

```shell-unix-generic
ls -a .git    #mostra anche i file nascosti
.  ..  branches  config  description  HEAD  hooks  info  objects  refs  
```

#pagebreak()

=== Working Tree 
(o *worktree* o *working directory*)
Contiene i file del progetto su cui lavoriamo, esclusi i metadata, che sono contenuti nella repository.

Creiamo un file nel nostro working tree:
```shell-unix-generic
echo "PMO Lab on Git" > README.md
```

#pagebreak()

=== Commit
Uno stato salvato del progetto.
- colleziona i *cambiamenti* necessari per passare dallo stato precedente (*parent*) a quello corrente (tecnica chiamata *differential tracking*)
- contiene altri metadata (autore, data, messaggio descrittivo, id del commit, ...)

Di fatto, un commit costituisce una fotografia (o *snapshot*) del progetto.

#pagebreak()

=== Branch
Una sequenza di commit collegati tra loro, ai quali si può accedere tramite una *lable* (es. `main`, `feature-x`, ...)

#pagebreak()

=== Staging area
In git, esiste il concetto di *stage* (o staging area o index):
- i cambiamenti, per diventare commit, devono prima essere aggiunti allo stage
- un commit "prende" i cambiamenti dallo stage e li salva nella repository

Per creare il nostro primo snapshot (commit), dobbiamo prima aggiungere il file README.md allo stage e poi eseguire il commit:
```shell-unix-generic
git add README.md                   #aggiunge i cambiamenti fatti a README.md allo stage
git commit -m "My first commit!"    #crea un nuovo commit con i cambiamenti attualmente nello stage

[master (root-commit) d645f11] My first commit
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
```
Congratulazioni, avete appena creato il vostro primo commit con Git!
#pagebreak()

Andiamo avanti con lo sviluppo del progetto e creiamo la seguente classe `Main` all'interno di una cartella `opm/lab2/git`:

```java
package opm.lab2.git;

class Main {
    public static void main(String[] args) {
        System.out.println("Hello, PMO Lab!");
    }
}
```

#pagebreak()

=== Osservare lo stato della repository
A mano a mano che aggiungiamo files e modifiche, potremmo chiederci:
- quanti commit sono stati eseguiti?
- quali file sono stati modificati?
- quali file sono nello stage?
- in quale branch siamo?

Per farlo, si usa il comando *git status*:
```shell-unix-generic
git status
n branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	opm/

nothing added to commit but untracked files present (use "git add" to track)
```

In questo caso, git ci sta dicendo che siamo sul branch `master` e che c'è una cartella `opm/` non tracciata (untracked), ovvero non aggiunta allo stage.

Aggiungiamola con il comando `git add opm/` e rieseguiamo `git status`:

```shell-unix-generic
git add opm/
git status

On branch master
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   opm/lab2/git/Main.java
```

A questo punto, il file Main.java è stato aggiunto allo stage e sarà incluso nel prossimo commit:

```shell-unix-generic
git commit -m "feat: Add Main class"
```

#pagebreak()

=== Visualizzare la storia del progetto
Spesso può essere utile visualizzare lo storico dei commit. A tal fine si usa il comando *git log*:

```shell-unix-generic
git log
commit 05980e1cb5948ddb3ca2b6b07f8a40af34d545de (HEAD -> master)
Author: lm98 <leonardomicelli@gmail.com>
Date:   Tue Oct 7 16:21:48 2025 +0200

    feat: Add Main class

commit d645f119b121e7f44a472a1a023450c575c1c23f
Author: lm98 <leonardomicelli@gmail.com>
Date:   Tue Oct 7 15:55:54 2025 +0200

    My first commit
```

N.B. per uscire dalla visualizzazione della storia, premere `q` (quit).

#pagebreak()
Aggiungiamo altri files allo stesso package:

```java
package opm.lab2.git;

class Counter {
    private int count = 0;

    public void increment() {
        count++;
    }

    public int getCount() {
        count; // nota bene: manca il return, gestiremo in seguito l'errore
    }
}
```

#pagebreak()

E committiamo:
```shell-unix-generic
git add opm/lab2/git/Counter.java
git commit -m "feat: Add Counter class"
```

A questo punto utilizziamo il nostro Counter nella classe Main:

```java
package opm.lab2.git;

class Main {
    public static void main(String[] args) {
        Counter counter = new Counter();
        counter.increment();
        System.out.println("Counter value: " + counter.getCount());
    }
}
```

#pagebreak()

E committiamo nuovamente:
```shell-unix-generic
git add opm/lab2/git/Main.java
git commit -m "feat: Use Counter"
```

#pagebreak()

A questo punto abbiamo la seguente storia del progetto:
```shell-unix-generic
git log

commit aef71243d6ea94cee40ebf333f5daf4b5f006612 (HEAD -> master)
Author: lm98 <leonardomicelli@gmail.com>
Date:   Wed Oct 8 10:39:46 2025 +0200

    feat: Use Counter

commit 9c748c45efc6467a1f47bb85466864e334ce068c
Author: lm98 <leonardomicelli@gmail.com>
Date:   Wed Oct 8 10:39:26 2025 +0200

    feat: Add Counter class

commit 05980e1cb5948ddb3ca2b6b07f8a40af34d545de
Author: lm98 <leonardomicelli@gmail.com>
Date:   Tue Oct 7 16:21:48 2025 +0200

    feat: Add Main class
```

#pagebreak()

Adesso, compiliamo il progetto con `javac`:
```shell-unix-generic
javac -d out opm/lab2/git/*.java

opm/lab2/git/Counter.java:15: error: not a statement
        count;
        ^
1 error
```

Oh no! Ci siamo accorti solo ora che abbiamo "salvato" un errore nella storia del progetto! Dobbiamo tornare indietro e risolvere l'errore.

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

Torniamo allora indietro al commit che introduce la classe Counter, in modo da poter correggere l'errore:
```shell-unix-generic
git checkout HEAD~1

Note: switching to 'HEAD~1'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

...

HEAD is now at 9c748c4 feat: Add Counter class
```

#pagebreak()

=== Detached HEAD
Adesso siamo in uno stato chiamato *detached HEAD*, ovvero HEAD non punta più ad un branch, ma direttamente ad un commit. In questo stato possiamo comunque fare tutte le modifiche che vogliamo e farne un commit, ma sarà "perso". In git, perché un commit sia valido deve essere l'ultimo commit di un branch.

Creiamo dunque un nuovo branch con il comando *git switch*:

```shell-unix-generic
git switch -c fix/getcount
Switched to a new branch 'fix/getcount'
```

Correggiamo l'errore nella classe Counter, aggiungendo il return mancante e committiamo:

```shell-unix-generic
git add opm/lab2/git/Counter.java 
git commit -m "fix: Add return statement"
```

Adesso abbiamo corretto la classe Counter, ma le modifiche fatte a Main non sono più presenti, perché abbiamo fatto il checkout ad un commit precedente.

#pagebreak()

=== Riconciliare cambiamenti (merging)
Il comando *git merge* permette di unire due branch creando un *merge commit* in cui i cambiamenti apportati in un branch
vengono applicati al branch in cui ci si trova. 

```shell-unix-generic
git merge master # n.b questo comando aprirà un editor di testo dove scrivere il messaggio del merge commit.

Merge made by the 'ort' strategy.
 opm/lab2/git/Main.java | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
```

A questo punto il nostro branch `fix/getcount` contiene anche i cambiamenti fatti in `master`.

#pagebreak()

Come buona pratica, è consigliabile tenere la versione più aggiornata e corretta nel branch principale (es. `main` o `master`), pertanto, una volta completato il lavoro in un branch secondario (es. `fix/getcount`), è buona norma unire i cambiamenti fatti in quel branch nel branch principale:

```shell-unix-generic
git switch master          # spostiamoci sul branch principale
Switched to branch 'master'

git merge fix/getcount    # uniamo i cambiamenti fatti in fix/getcount
Updating aef7124..09ad913
Fast-forward
 opm/lab2/git/Counter.java | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```
Adesso, se ricompiliamo il progetto, non dovremmo più avere errori.

#pagebreak()

=== Ignorare files
Solitamente non si vuole tenere traccia di *tutti* i files del progetto:
- alcuni potrebbero essere files temporanei, generati automaticamente (es. file di log, file di build, ...)
- altri possono essere ri-generati facilmente (es. file di output, ...)
- altri ancora potrebbero contenere informazioni sensibili (es. file di configurazione con password, ...)

è possibile dire a git di ignorare automaticamente certi files, creando un file `.gitignore` nella root della repository, con dentro i nomi (o pattern) dei files da ignorare.

#pagebreak()

Se eseguiamo il comando `git status`, notiamo dei files `.class` generati dalla compilazione di Java:
```shell-unix-generic
git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        out/

nothing added to commit but untracked files present (use "git add" to track)
```

Questi files possono essere rigenerati facilmente compilando di nuovo il progetto, pertanto è buona norma ignorarli includendo la cartella `out/` nel file `.gitignore`:

```shell-unix-generic
echo "out/" > .gitignore
```

Adesso, se eseguiamo di nuovo `git status`, non vedremo più la cartella out:

```shell-unix-generic
git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        .gitignore

nothing added to commit but untracked files present (use "git add" to track)
```

Aggiungiamo il file `.gitignore` allo stage e facciamo un commit:
```shell-unix-generic
git add .gitignore
git commit -m "chore: Add .gitignore"
```

Ottimo! Abbiamo finito, ora possiamo fare logout dal pc del laboratorio e lasciare che lo script automatico cancelli tutto il nostro lavoro :(
#pagebreak()

== GitHub
GitHub è una piattaforma di hosting per progetti software che utilizzano Git come sistema di controllo versione.
- Permette di ospitare repository Git in remoto
- Fornisce strumenti per la collaborazione in team (issue tracking, pull request, code review, ...)
- Offre integrazioni con altri servizi (CI/CD, gestione progetti, ...)

La prima funzionalità è quella che ci interessa di più in questo momento.


== Creare una repository su GitHub
1. Andare su https://github.com e creare un account (se non lo si ha già)
2. Cliccare sul pulsante "New" in alto a sinistra per creare una nuova repository

#figure(image("images/github-new-repo.png"))

Apparirà una schermata come la seguente:

#figure(image("images/github-repo-info.png"))

== Scaricare una repository da GitHub
Per scaricare una repository da GitHub, si usa il comando `git clone` seguito dall'url della repository:

```shell-unix-generic
cd                 #mi sposto nella home directory
#N.B. sostituire yourUsername con il proprio username GitHub
git clone https://github.com/yourUsername/opm-lab-git-example.git
```
A questo punto possiamo copiare il nostro lavoro (README.md, .gitignore e `opm/`) all'interno della repo scaricata,
aggiungere tutto allo stage e fare il commit:

#pagebreak()

```shell-unix-generic
git add .                               #aggiungo tutto allo stage
git commit -m "feat: Initial commit"    #faccio il commit

[main (root-commit) 33cb514] feat: Initial commit
 4 files changed, 28 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 README.md
 create mode 100644 opm/lab2/git/Counter.java
 create mode 100644 opm/lab2/git/Main.java
```
N.B. questa nuova repository avrà un solo commit, quelli precedenti appartenevano alla vecchia repository.


== Recap: l'evoluzione di un progetto
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