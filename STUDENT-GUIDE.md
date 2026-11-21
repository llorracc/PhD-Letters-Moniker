# Writing your part of the letter

## You are ghostwriting for CDC

Everything you write is in **CDC's voice**, describing you. "I" is always CDC:

- Right: "I first met \PersonName{} in fall 2022, when \heOrshe{} took my first-year PhD macroeconomics course."
- Wrong: "I first met Professor Carroll when I took his course."
- Wrong: "I used difference-in-differences ..." Write "\PersonName{} used difference-in-differences ...".

Refer to yourself with the macros from `student-macros.ltx`: `\PersonName{}`, `\heOrshe{}`, `\hisOrHer{}`,
`\himOrHer{}` and their capitalized forms. Never "the student".

## Facts are yours; judgments are CDC's

Write what you did, specifically, and let the specifics speak. Leave every judgment to CDC: how good the
work is, how you compare with others, what it says about you. His passages go where the red
`[CDC: ...]` markers are, and you will not see them.

- Write: "\PersonName{}'s paper estimates a life-cycle model with administrative tax data covering ten
  million households." Not: "The paper makes an important contribution."
- Write: "\HeOrShe{} wrote the package's solver for portfolio choice (link)." Not: "\HeOrShe{} made valuable
  contributions to open-source economics."
- Don't tell the same fact twice. If CDC's passage already tells it, he will take your sentence out.

## CDC's rules for every letter

- **Link everything linkable**: papers, projects, software, data, people (coauthors, supervisors),
  conferences, programs, awards. Famous institutions need no link. Use `\href{URL}{text}`.
- **A paper is linked to the paper**, never to the journal's home page: the published version if it is
  public, otherwise the latest draft.
- **Check every link** in a browser before it goes in. Leave plain text where no page exists; never guess
  a URL.
- **Gloss what's what and who's who** for a reader from another field: a clause on what a method does,
  who a person is, what a venue or program is. Size it to the readers: heavier for a cross-disciplinary
  search, lighter for economists.
- **Write short, plain sentences.** Use simple verbs ("I write", "found"), the short familiar name of an
  institution once it has been introduced (Ohio State, the New York Fed), and no throat-clearing ("let me",
  "I should add that").
- **Settle every fact before you hand it over.** Leave no bracketed questions, notes to CDC or `TODO`s in
  the sections. Ask him questions separately.
- **Get names, dates, titles and statuses right**: people, institutions, journals, coauthors, semesters,
  the exact title of each paper, and whether it is published, under review, or a working paper.
- American English throughout.

## Your facts: `student-macros.ltx`

Fill in every placeholder ("Mr Spock" is the template's placeholder student). The letter uses these macros
everywhere, so each fact is changed in one place. Above all:

- `\LetterOpening`: the letter's first sentence, in CDC's voice: who you are and how he knows you. If he
  is not your main advisor, say so here.
- `\JMP` and `\JMPTitle`: your job market paper's link and exact title.
- `\CVUrl`: a stable URL that always returns your latest CV. When it is set, `./Letter-make.sh` refreshes
  `JMFiles/CV.pdf` from it (see `JMFiles/README.md`).
- Visa: `\Nationality`, `\VisaType`, `\STEMOPTYears`, or leave them empty. Set
  `\OmitBackgroundVisaParagraph` to `yes` where a portal collects visa status separately.
- The pronoun macros.

## The sections: `Subfiles/`

`Letter-sections.tex` lists which sections print. Comment one out with `%` if it does not apply to you.
A short letter (a summer or dissertation internship) usually needs only intro, jmp and conclusion; CDC
can also use a different list for one destination.

- **intro**: how CDC knows you, with dates: his courses you took, advising, research assistance,
  coauthorship, projects (Econ-ARK, for example), reading groups. A timeline of interactions, not an
  evaluation.
- **background**: undergraduate and master's education, predoctoral work (employer, title, dates, what
  you did, linked), and what it brought to your PhD. The visa sentence comes from the macros.
- **jmp**: the question and why it matters, the data and methods, how you identify or estimate what you
  claim, the main findings with magnitudes, and what follows for the literature or for policy. Link the
  paper, its code and its data where public.
- **other-papers**: each other paper or chapter: exact title, coauthors (linked), status, question,
  approach, main finding. Most advanced first.
- **future-research-agenda**: two to four concrete projects, how they build on your work, and what is
  already in hand (data access, collaborators, pilot results, funding).
- **other-activities**: software and open-source contributions (linked), presentations and invited
  seminars, internships and fellowships, refereeing, organizing, mentoring, awards.
- **teaching**: courses you assisted (with the instructor and semester), your responsibilities, sizes,
  anything you introduced, courses you taught yourself, workshops. Mention evaluations only if CDC asks.
- **conclusion**: usually CDC's alone. Add a factual closing sentence only if he asks for one.

## Citations: `Letter.bib`

Cite with `\citet{key}` or `\citep{key}` and put each entry in `Letter.bib`. The build stops if a cited
key is missing or an entry is repeated, and a References section prints only when the letter cites
something. Prefer a link to the paper over a citation where a link will do.

## Your applications: `letter-opportunities/`

Add a folder for each application with its `opportunity.md` (posting, deadlines, how the letter is
delivered, what it should mention), and a row in `INDEX.md`. See `letter-opportunities/README.md`. CDC
sets each letter's destination himself; leave the `Name-Of-*.tex` files alone.

## Outreach email: `email-templates/`

Optional: drafts of email to people at the places you apply, which CDC can send. Start with
`email-templates/QUICK-START.md`.

## Before you hand it over

- [ ] Every placeholder in `student-macros.ltx` and the sections is replaced.
- [ ] Every link is tested; papers link to the papers.
- [ ] No evaluative language, no comparisons, no fact told twice.
- [ ] No bracketed questions, notes or `TODO`s left in the sections.
- [ ] Names, dates, titles and statuses checked.
- [ ] `./Letter-make.sh` builds without errors.
