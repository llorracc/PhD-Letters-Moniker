# Recommendation letters from CDC: the student's template

This repository is where you and CDC (Christopher Carroll) build his letters of recommendation for you.
You write the facts, in his voice; he adds his own judgments, which live in a separate folder you
never see; his build merges the two. Read [`STUDENT-GUIDE.md`](STUDENT-GUIDE.md) before writing anything.

Please leave the template better than you found it: anything that would improve the instructions or
the structure, send back as a pull request (see "Suggest improvements" below).

## What's where

| File or folder | What it is | Who edits it |
|---|---|---|
| `student-macros.ltx` | your facts in one place: name, field, year, degree date, job-market fields, links, JMP title, what you can teach, pronouns, visa, the letter's opening sentence | you |
| `Subfiles/*.tex` | the letter's sections (intro, background, jmp, other-papers, software (optional), policy (optional), future-research-agenda, other-activities, teaching, conclusion) | you |
| `Figures/` | the file for one optional figure from your job market paper (`\LetterFigure`, in `Subfiles/jmp.tex`) | you |
| `Letter-sections.tex` | which sections print, in order | you |
| `Letter.bib` | the references you cite | you |
| `letter-opportunities/` | one folder per application: posting, deadlines, how the letter is delivered | you |
| `email-templates/` | outreach email to people at the places you apply (optional) | you |
| `JMFiles/` | your CV and other job-market files | you |
| `NEWS.md` | news during the season (a revise-and-resubmit, a new draft, a prize), for an updated letter | you |
| `Letter.tex`, `Letter-make.sh` | the letter itself, and the script that builds it | nobody, except to fix the template |
| `.letter/` (hidden) | the machinery: layout, letterhead, bibliography style, CV sync, and default destination names that CDC's build replaces | nobody, except to fix the template |

## Building the letter

```bash
./Letter-make.sh
```

This writes `Letter.pdf`, plus a PDF of each section in `Subfiles/`. Two red `[CDC: ...]` markers show where
CDC's overall assessment and closing go; in his build they are replaced by his text, and he may add his
own passages elsewhere. The build stops with a message if a
citation is missing from `Letter.bib` or an entry is repeated. `SKIP_CV_SYNC=1 ./Letter-make.sh` skips
refreshing `JMFiles/CV.pdf` from your CV's URL. Built PDFs are never committed.

You need a TeX installation with `latexmk` (TeX Live or MacTeX). Without one, open the repository in
VS Code's dev container (`.devcontainer/README.md`).

## The workflow

Read it all before starting.

- **Fork and clone.** Fork this repository and clone your fork.
- **Draft on a local branch.** Create and switch to a branch called `personal-draft`. There, fill in
  `student-macros.ltx`, the sections in `Subfiles/`, `Letter-sections.tex` and `Letter.bib`, following
  [`STUDENT-GUIDE.md`](STUDENT-GUIDE.md). Build and check the PDF.
- **Commit locally only.** Do not push `personal-draft`: your fork is public, because this template is,
  and what you have filled in should not be.

  ```bash
  git status --short --branch
  git add student-macros.ltx Letter-sections.tex Letter.bib Subfiles/   # and anything else you edited
  git diff --cached
  git commit -m "Draft personal letter materials"
  ```
- **Suggest improvements (optional).** If you found ways to improve the instructions or the structure,
  put them on a branch made from `main`, never from `personal-draft`:

  ```bash
  git switch main
  git switch -c template-suggestions
  # make the general fixes, then
  git add README.md                     # and any other changed files
  git diff --cached
  git commit -m "Improve template instructions"
  git log -p main..template-suggestions # check that nothing personal is in it
  git push -u origin template-suggestions
  ```

  Open a pull request to `llorracc/PhD-Letters-Moniker` and wait for CDC to merge it. Then use
  **Sync fork** on GitHub and update your clone:

  ```bash
  git switch main
  git pull --ff-only origin main
  git switch personal-draft
  git merge main                        # resolve any conflict before continuing
  ```
- **Make it private and rename it.** On GitHub: Settings → General → Danger Zone → **Leave fork network**,
  then make the repository **Private**, then rename it `PhD-Letters-<MONIKER>`, where the moniker is your
  family name followed by your initials (Jane Q. Doe is `DoeJQ`). Confirm that GitHub shows
  **Private** before going on.
- **Push your draft.** Point your clone at the renamed repository, merge your draft and push:

  ```bash
  git remote set-url origin https://github.com/YOUR-USERNAME/PhD-Letters-<MONIKER>.git
  git switch main
  git merge personal-draft
  git push origin main
  ```
- **Invite CDC.** Add `llorracc` as a collaborator and tell CDC you have done so. **GitHub invitations
  expire after seven days**; if he has not accepted by then, send it again.

After that, keep the repository current: update your facts, sections and `letter-opportunities/` as
your applications go out. CDC builds each letter from what is in the repository when he builds it.
