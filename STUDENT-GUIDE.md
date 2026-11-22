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
work is, how you compare with others, what it says about you. His overall assessment and his closing go
where the two red `[CDC: ...]` markers are, and you will not see them. He may also add a passage where
nothing is marked: a comment in any section, news since his first letter, a comparison with other
students, his own account of work you did with him, a paragraph on why you suit a particular destination,
and an offer to discuss you.

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
- `\ExpectedDegree` (when you expect the PhD, e.g. "May 2027"), `\PrimaryField` and `\SecondaryField`
  (your job-market fields, as your job-market profile lists them). Whatever you fill in prints in
  Background.
- `\ReadyToTeach`: the courses you are prepared to teach, as one phrase ("undergraduate macroeconomics
  and graduate computational methods"). It prints in Teaching. Committees hiring for teaching read it
  closely.
- Visa: `\Nationality` and `\VisaType` with their articles ("a German national", "an F-1 visa"), and
  `\STEMOPTYears`; or leave them empty. Set `\OmitBackgroundVisaParagraph` to `yes` where a portal
  collects visa status separately.
- The pronoun macros.

## The sections: `Subfiles/`

`Letter-sections.tex` lists which sections print. Comment one out with `%` if it does not apply to you.
A short letter (a summer or dissertation internship) usually needs only intro, jmp and conclusion; CDC
can also use a different list for one destination.

- **intro**: how CDC knows you, with dates: his courses you took, advising, research assistance,
  coauthorship, projects (Econ-ARK, for example), reading groups. A timeline of interactions, not an
  evaluation.
- **background**: undergraduate and master's education, predoctoral work (employer, title, dates, what
  you did, linked), and what it brought to your PhD. If your path was unusual (a career before the PhD,
  a move between programs or advisors, circumstances that shaped your interests), you may add the facts,
  but only what you want mentioned; CDC decides whether it prints. Tell CDC about anything a committee
  might misread (a sixth or later year, a leave, a change of advisor or field): he decides whether and
  how the letter explains it. The degree date, fields and visa sentences come from the macros.
- **jmp**: the question and why it matters, the data and methods, how you identify or estimate what you
  claim, the main findings with magnitudes, and what follows for the literature or for policy. Link the
  paper, its code and its data where public. Say whose project it is: when and how it began, what you
  designed yourself, and any data you collected or built; committees ask this most when the work grew
  out of your advisor's own projects. If it is joint work, one sentence on who did what.
  Optionally, one figure a reader from another field can follow: put the file in `Figures/` and use
  `\LetterFigure{file}{caption}` (the line is in `jmp.tex`, commented out). One figure at most.
- **other-papers**: each other paper or chapter: exact title, coauthors (linked), status, question,
  approach, main finding, and for joint work who did what (including work with CDC). Most advanced
  first.
- **software** (optional; uncomment it in `Letter-sections.tex`): when your software or open-source work
  is substantial enough to stand alone. Each project: what it does, what you built in it (link the
  merged pull requests or releases), and who uses it.
- **policy** (optional; uncomment it in `Letter-sections.tex`, and CDC may use it in place of teaching in
  a letter to a central bank or other policy institution): each internship, fellowship or job there:
  where and when, what you produced (memos, briefings, forecasts, models or code that staff went on to
  use) and who used it, and any time you presented your work to policymakers or other non-economists.
- **future-research-agenda**: two to four concrete projects, how they build on your work, and what is
  already in hand (data access, collaborators, pilot results, funding).
- **other-activities**: software and open-source contributions (unless they have their own section),
  presentations and invited seminars, internships and fellowships (unless they are in policy),
  refereeing, organizing, mentoring, awards.
- **teaching**: courses you assisted (with the instructor and semester), your responsibilities, sizes,
  anything you introduced, courses you taught yourself, workshops. Mention evaluations only if CDC asks.
  What you are prepared to teach comes from `\ReadyToTeach`.
- **conclusion**: usually CDC's alone. Add a factual closing sentence only if he asks for one.

## Citations: `Letter.bib`

Cite with `\citet{key}` or `\citep{key}` and put each entry in `Letter.bib`. The build stops if a cited
key is missing or an entry is repeated, and a References section prints only when the letter cites
something. Prefer a link to the paper over a citation where a link will do.

## Your applications: `letter-opportunities/`

Add a folder for each application with its `opportunity.md` (posting, deadlines, how the letter is
delivered, what it should mention), and a row in `INDEX.md`. See `letter-opportunities/README.md`. CDC
sets each letter's destination himself (the lines under its title, and its salutation). Where a paragraph
on why you suit the destination would help, give him the facts for it in `opportunity.md` (see the
example).

## News during the season: `NEWS.md`

When something happens that a committee should know (a revise-and-resubmit or acceptance, a new draft of
the job market paper, a new paper, a prize), add a dated line with a link to `NEWS.md` and tell CDC. He
decides whether an updated letter goes out, and writes the update himself.

## Outreach email: `email-templates/`

Optional: drafts of email to people at the places you apply, which CDC can send. Start with
`email-templates/README.md`.

## Before you hand it over

- [ ] Every placeholder in `student-macros.ltx` and the sections is replaced.
- [ ] Degree date, fields and what you can teach are filled in.
- [ ] The job market paper says when it began and what you designed; every joint paper says who did what.
- [ ] Every link is tested; papers link to the papers.
- [ ] No evaluative language, no comparisons, no fact told twice.
- [ ] No bracketed questions, notes or `TODO`s left in the sections.
- [ ] Names, dates, titles and statuses checked.
- [ ] `./Letter-make.sh` builds without errors.
