# Email templates system

Tools for generating personalized recommendation-outreach emails. **Students:** start with [`QUICK-START.md`](QUICK-START.md) (or the one-page pointer [`START-HERE.md`](START-HERE.md)), then [`STUDENT-GUIDE.md`](STUDENT-GUIDE.md) and [`../docs/TODO-FOR-STUDENT.md`](../docs/TODO-FOR-STUDENT.md) as needed.

## Layout in this repository

`./emails-make.sh` expects:

- **`student-info.md`** — default values for placeholders (student fills; advisor-only fields stay empty).
- **`recipients/<organization>/`** — one subdirectory per organization type (e.g. `academic-position`, `policy-institution`, `internship`, **`internship-dissertation`** for PhD dissertation intern programs). Each recipient is `email@domain.md` with required **`PERSONAL_NAME:`** / **`FAMILY_NAME:`** (exact spelling; used by `emails-make.sh`) and optional **`NICKNAME:`**, `OPTIONAL_INSTITUTION_FIT`, etc.
- **`recipients/<organization>.md`** — the **body template** used for that folder (same basename as the directory).

**Letter opportunities (postings, deadlines, links):**

- **`../letter-opportunities/`** — one folder per application (`<id>/opportunity.md` with **YAML front matter**). You maintain this; it is **not** read by `emails-make.sh`. See [`../letter-opportunities/README.md`](../letter-opportunities/README.md) and [`../letter-opportunities/INDEX.md`](../letter-opportunities/INDEX.md).

Optional extras:

- **`templates/`** — alternate full templates; copy over `recipients/<organization>.md` if you want that wording (see [`templates/README.md`](templates/README.md)).
- **`target-jobs.md`** — scratchpad for exploring the market (not consumed by the script); link or duplicate pointers into `letter-opportunities/` when you commit to an application.

## Quick start

```bash
# Edit defaults first
#   vim student-info.md

# Add recipient files under recipients/academic-position/ (etc.)

./emails-make.sh --preview    # student-safe previews
./emails-make.sh              # full generation (still writes to preview-emails/ in shared repo)
```

Generated `.eml` files land under `preview-emails/<organization>/`. Private-repo steps (letter URL, advisor blocks, sending) follow your advisor’s private workflow.

## Variables and docs

- Full placeholder list: [`docs/TEMPLATE-VARIABLES-INVENTORY.md`](docs/TEMPLATE-VARIABLES-INVENTORY.md)
- Architecture: [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)
- Per-recipient file format: [`recipients/RECIPIENT-FILE-TEMPLATE.md`](recipients/RECIPIENT-FILE-TEMPLATE.md)
- **Advisor / faculty:** workflow and private-repo handoff — [`docs/ADVISOR-README.md`](docs/ADVISOR-README.md) (canonical advisor-oriented overview for this tree)

## Requirements

- `bash`, `sed`, and preferably `rpl` (`brew install rpl` on macOS).

## Nicknames

In a recipient file (UPPERCASE field names):

```text
NICKNAME: Alex
```

The salutation uses the nickname when present (see `STUDENT-GUIDE.md`).
