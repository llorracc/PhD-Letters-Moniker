# JMFiles directory

Reference copies of **job-market materials** (CV, statements, transcripts, etc.) for you and your advisor. The letter PDF stays link-based (it does not embed `CV.pdf`), but **`./Letter-make.sh` can refresh `CV.pdf` from the web** when you set **` \CVUrl`** (see below).

---

## Curriculum vitae (read this first)

### Preferred: public URL (`\CVUrl` in `student-macros.ltx`)

Set **` \newcommand{\CVUrl}{...}`** in **`../student-macros.ltx`** to a **stable URL** that always returns your **latest** CV (for example a permalink on your website, a department profile PDF, or a **raw** GitHub link that you overwrite when you update the file). The Background section of the letter links to that URL, so readers see the up-to-date document when they click.

### Automatic refresh when you run `./Letter-make.sh`

If **` \CVUrl`** is non-empty, the first step of **`Letter-make.sh`** runs **`scripts/sync-cv-from-url.sh`**, which:

1. Downloads the PDF from **` \CVUrl`** and compares it to **`JMFiles/CV.pdf`** (if the file is missing, it saves the download as the initial `CV.pdf`).
2. If the PDF bytes are unchanged, it does nothing further.
3. If the bytes changed, it runs **`pdftotext`** on the old and new files and uses **`scripts/cv_trivial_diff.py`** to drop common metadata/timestamp-style lines. If the remaining text is unchanged, it **replaces `CV.pdf`** quietly (layout/metadata-only update).
4. If the text change looks **substantive**, it **renames** the previous file to **`CV_YYYYMMDD_HHMMSS.pdf`**, saves the new download as **`CV.pdf`**, writes text extracts under **`CV-sync-review/`** (with **`previous_for_ai_review.txt`** and **`current_for_ai_review.txt`** symlinks), and prints instructions to **compare them (or ask an AI)** whether **`student-macros.ltx`**, **`Subfiles/`**, **`email-templates/`**, or **`letter-opportunities/`** need edits.

Requirements: **`curl`**, **`pdftotext`** (Poppler), and **`python3`** (for the trivial-vs-substantive heuristic). To skip this step entirely: **`SKIP_CV_SYNC=1 ./Letter-make.sh`**.

### Designated local copy: `CV.pdf`

Keep your **current** CV in this directory under the **canonical name**:

**`JMFiles/CV.pdf`**

- Your advisor can open this file from the repo; **`sync-cv-from-url.sh`** keeps it aligned with **` \CVUrl`** whenever you build the letter (unless you set **`SKIP_CV_SYNC=1`**).
- You can still overwrite **`CV.pdf`** manually if you do not use **` \CVUrl`**.
- The letter PDF does **not** embed this file; it is for **human reference** only.

Optional: you may add other filenames (e.g. `ResearchStatement.pdf`) for your own organization; only **`CV.pdf`** is the shared convention for the CV.

---

## Job market paper

**Do not** put the JMP PDF here for the letter system. The JMP must be linked from **`../student-macros.ltx`** via **` \newcommand{\JMP}{...}`** (see below).

---

## Other files

Research statement, teaching statement, transcript, etc. may live here for reference and sharing with your advisor. They are **not** used automatically by the recommendation letter build.

Example for JMP URL in `student-macros.ltx`:

```latex
\newcommand{\JMP}{https://yourwebsite.edu/jmp.pdf}
```

> See also **[`../STUDENT-GUIDE.md`](../STUDENT-GUIDE.md)** and **`../student-macros.ltx`** for `\CVUrl` and `\Website`.
