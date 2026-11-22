# Outreach email

Optional. This folder makes draft emails from your advisor to people at places where you apply. You
supply the facts: a short description of you and your work, and one file for each person. The
scripts merge them into your advisor's wording. Your advisor writes the recommendation itself and
sends the email; nothing in this folder sends anything.

For the letter itself, see [`../STUDENT-GUIDE.md`](../STUDENT-GUIDE.md).

## Steps

Run everything from this folder (`cd email-templates`).

1. Fill in `student-info.md` (see "Your details" below).
2. Add a recipient file for each person to be written to (see "Recipient files" below). Ten to
   fifteen priority contacts is plenty.
3. Preview: run `./emails-make.sh --preview`, then read each draft in
   `preview-emails/<folder>/<email address>.eml`. Check that your sentences read as finished text,
   that the greeting is right, and that no placeholder you meant to fill is still showing as
   `[NAME]`. If you chose "they", check the verbs: the templates say "[HE_SHE] is".
4. Check: run `./validate-recipients.sh` and fix every file it marks with ✗.
5. Commit `student-info.md` and your recipient files. Your advisor makes the emails from them, adds
   the recommendation and sends them.

Edit and rerun as often as you like. The scripts need only `bash` and standard Unix tools. If `rpl`
is installed (`brew install rpl`) they use it, and it copes better with unusual characters.

## Your details: `student-info.md`

Each line of the form `NAME: "value"` replaces every `[NAME]` in the templates.

- Keep each value on one line, inside double quotes, with no `"`, `$` or backtick inside it.
- Leave your advisor's values empty: `OPTIONAL_CDC_SAY_HI`, `CDC_NICE_THINGS`,
  `OPTIONAL_CDC_SAY_BYE` and `CDC_LETTER_URL`.
- Leave `OPTIONAL_PEOPLE_AT_THE_INSTITUTION` empty too, unless you want the same text in every
  email: a value here overrides the one in each recipient file.
- An empty value (`""`) leaves its `[NAME]` showing in the draft.

## Recipient files

Put one file for each person in the folder for that kind of job. Every file in
`recipients/<folder>/` is merged into the template `recipients/<folder>.md`.

| Folder in `recipients/` | Use it for |
|---|---|
| `academic-position/` | faculty positions |
| `policy-institution/` | central banks, government agencies, international organizations |
| `internship-dissertation/` | PhD dissertation intern programs, such as the Federal Reserve's summer programs |
| `internship/` | other dissertation or summer internships |
| `private-sector-consulting/` | consulting and other private-sector jobs |
| `base-recommendation/` | anything else: a general recommendation |

The `policy-institution/` and `base-recommendation/` folders do not exist yet: create one
(`mkdir recipients/policy-institution`) the first time you need it. The templates are your
advisor's wording, so leave them alone; for another kind of job, ask your advisor for a template.

**Name each file with the person's email address plus `.md`**, exactly:
`recipients/academic-position/jane.smith@university.edu.md`. The script takes the `To:` address
from the file name.

Start each file from the template:

```bash
cp recipients/RECIPIENT-FILE-TEMPLATE.md recipients/academic-position/jane.smith@university.edu.md
```

A filled-in file looks like this (`recipients/academic-position/example.search@university.edu.md`
is another example; delete it once you have your own):

```text
PERSONAL_NAME: Jane
FAMILY_NAME: Smith
OPTIONAL_INSTITUTION_FIT: Alex's work on household saving fits your department's strength in macroeconomics and household finance.
OPTIONAL_PERSON_FIT: Your recent work on precautionary saving is closely related to the mechanism in Alex's job market paper.
optional_private_comment_to_advisor: I think she was a colleague of yours at the Fed?
Alex tells me you were a mentor of his in the AEA mentoring program, and that your advice was very helpful to him.
```

| Line | Needed | What it does |
|---|---|---|
| `PERSONAL_NAME:` | yes | the greeting ("Jane,"), unless there is a nickname |
| `FAMILY_NAME:` | yes | required, though no template prints it |
| `NICKNAME:` | no | used in the greeting instead; for a committee, `NICKNAME: Members of the Search Committee` |
| `OPTIONAL_INSTITUTION_FIT:` | no | why this place suits your work |
| `OPTIONAL_PERSON_FIT:` | no | how your work connects to this person's |
| `OPTIONAL_PEOPLE_AT_THE_INSTITUTION:` | no | a sentence on others there who would be interested; it stands alone near the end |
| `optional_private_comment_to_advisor:` | no | a note for your advisor; never put in the email |
| a paragraph with no field name | no | a personal note, such as how you know the person; inserted next to your advisor's recommendation |
| a line starting with `%` | no | a comment; ignored |

- Put field names at the start of a line, spelled as above. Each field is one line: anything on the
  lines after it becomes part of the personal note.
- Write the fields as finished sentences in your advisor's voice ("Your recent work on..."), one or
  two each. They go into the email exactly as written.
- Keep the personal note to one paragraph: blank lines are dropped.
- There is no `CUSTOM_CONTENT:` field; a line starting with it is dropped. Write the note as a
  plain paragraph.
- The script drops text that looks like pasted terminal output. A note containing "error" (even in
  "standard errors") or a path such as `/Users/` is left out without a word; a field containing
  `$(`, a backtick, `&&` or `||` is left out with a warning.

## Placeholders

A template is plain email text with placeholders in square brackets. Where each value comes from:

| Placeholder | Value from | Templates that use it |
|---|---|---|
| `[recipient_personalname]` | recipient file: `NICKNAME`, else `PERSONAL_NAME` | all |
| `recipient@place.dom` | recipient file name | all |
| `[OPTIONAL_INSTITUTION_FIT]`, `[OPTIONAL_PEOPLE_AT_THE_INSTITUTION]` | recipient file | all |
| `[OPTIONAL_PERSON_FIT]` | recipient file | academic-position, base-recommendation, internship, internship-dissertation |
| `[STUDENT_NAME_FULL]`, `[STUDENT_NAME_PERSONAL]`, `[JOBMARKET_PAPER_ONE_PHRASE_DESCRIPTION]`, `[JOBMARKET_PAPER_URL]` | `student-info.md` | all |
| `[KIND_OF_ECONOMIST]`, `[RESEARCH_AGENDA_IN_ONE_SENTENCE]` | `student-info.md` | academic-position, internship, internship-dissertation |
| `[HE_SHE]` | `student-info.md` | academic-position, internship-dissertation, private-sector-consulting |
| `[RELEVANT_TOOLS]`, `[OPTIONAL_PARTICULARLY_HIGHLIGHT]` | `student-info.md` | policy-institution, private-sector-consulting, internship, internship-dissertation |
| `[OTHER_ACCOMPLISHMENTS]` | `student-info.md` | policy-institution, private-sector-consulting, base-recommendation |
| `[FIELD]`, `[JOBMARKET_PAPER_TITLE]`, `[HIS_HER]` | `student-info.md` | base-recommendation |
| `[THE_INSTITUTION]` | the address's domain: `frb.gov` gives "the Federal Reserve Board", and a few other central banks and agencies are known; any other domain appears as it is (`university.edu`) | base-recommendation |
| `[OPTIONAL_CDC_SAY_HI]`, `[CDC_NICE_THINGS]`, `[CDC_LETTER_URL]` | your advisor | all |
| `[OPTIONAL_CDC_SAY_BYE]` | your advisor | base-recommendation |

`HIM_HER` and `KEY_FINDING_WITH_POLICY_RELEVANCE_FOR_INSTITUTION` in `student-info.md` are not
used by any template at present.

## What the scripts write

- `./emails-make.sh --preview` writes one draft for each recipient file to
  `preview-emails/<folder>/<email address>.eml`, replacing any earlier draft of that name. To do
  only some folders, name them: `./emails-make.sh --preview academic-position`.
- It skips, and says so on screen, a folder with no recipient files, a folder with no template of
  the same name, and a recipient file without `PERSONAL_NAME:` or `FAMILY_NAME:`.
- Your advisor's parts stay in the draft as placeholders, such as `[CDC_NICE_THINGS]`, and so does
  any other placeholder that has no value.
- Drafts for recipient files you have deleted stay until you remove them; `rm -rf preview-emails`
  clears them all. `preview-emails/` is in `.gitignore`, so drafts are never committed.
- Without `--preview` the script runs as your advisor runs it: it looks for your advisor's private
  repository next to yours and prints an error when it is not there. Use `--preview`.
- `./validate-recipients.sh` (optionally followed by folder names) writes nothing. It marks each
  recipient file ✓ or ✗, with an error for a missing `PERSONAL_NAME:` or `FAMILY_NAME:` and a
  warning for an empty fit field. An empty folder shows `File not found: *.md`; ignore it. It does
  not look at the drafts, so read those yourself.

## Other files here

- `target-jobs.md`: an optional scratchpad for postings and contacts. The scripts do not read it.
- [`../letter-opportunities/`](../letter-opportunities/README.md): one record for each
  application; its `related_recipient_files` can list your recipient files. The scripts do not
  read it.
