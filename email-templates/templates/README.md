# Optional email bodies (`templates/`)

These files are **alternate** full-message templates (headers + body + placeholders). They follow an older full-message layout and are useful when you want a different tone or paragraph order than the copies in `recipients/*.md`.

**Active templates for `./emails-make.sh`:** for each folder `recipients/<organization>/`, the script reads **`../recipients/<organization>.md`** (sibling of that folder). To switch to a variant here:

1. Back up `recipients/<organization>.md`.
2. Copy the desired file from `templates/` over `recipients/<organization>.md`.
3. Run `./emails-make.sh <organization>` and fix any placeholders your `student-info.md` does not define.

Placeholders in this directory are normalized to match the current script and `student-info.md` (e.g. `[CDC_LETTER_URL]` rather than older `[RECOMMENDATION_LETTER_URL]`, and `[OPTIONAL_INSTITUTION_FIT]` for institution-fit paragraphs filled from recipient files).
