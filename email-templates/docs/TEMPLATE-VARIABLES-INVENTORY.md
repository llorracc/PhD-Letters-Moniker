# Email Template Variables Inventory

This document catalogs all placeholders/variables used in the email templates.

**Last Updated:** Based on current templates and practice

## Where templates live

- **`recipients/<organization>.md`** — body template paired with folder `recipients/<organization>/`; this is what `./emails-make.sh` loads (e.g. `recipients/academic-position.md` + `recipients/academic-position/*.md`).
- **`recipients/internship-dissertation.md`** + **`recipients/internship-dissertation/`** — PhD dissertation intern programs (e.g. Fed summer dissertation placements); same placeholders as other bodies, but wording emphasizes dissertation progress and research staff interaction rather than full job-market placement.
- **`templates/*.md`** — optional alternate bodies; copy over a `recipients/<organization>.md` file if you want that wording (see `templates/README.md`).

## ⚠️ IMPORTANT: CDC_ Fields Are Advisor-Only ⚠️

**All fields beginning with `CDC_` are ADVISOR-ONLY fields.**

- These fields are filled in the **private repository** by your advisor during email generation
- **Students should NEVER populate or edit these fields**
- Leave them empty (default: `""`) in `student-info.md`
- They appear in templates as placeholders to show where advisor content will be inserted
- Examples: `[CDC_NICE_THINGS]`, `[OPTIONAL_CDC_SAY_HI]`, `[OPTIONAL_CDC_SAY_BYE]`

**Your role:** Provide content for student-controlled fields only (research descriptions, fit explanations, connections, etc.)

**Advisor's role:** Provides the CDC_ content in the private part of the process

## Complete Variable List

### Core Variables (All Templates)

1. **`[recipient_personalname]`** - Recipient's personal name
   - **Source:** From the **`PERSONAL_NAME:`** line in the recipient file (REQUIRED; see `emails-make.sh`)
   - **Override:** Optional **`NICKNAME:`** line (e.g. `NICKNAME: Alex` when `PERSONAL_NAME: Alexander`)
   - **Used in:** academic, base, policy

2. **`recipient@place.dom`** - Recipient's email address
   - **Source:** From `email` field in recipient file (REQUIRED), or extracted from filename if field not present
   - **Used in:** academic, base, policy

3. **`[STUDENT_NAME_FULL]`** - Student's full name
   - **Default:** `"Student Full Name"` (set in `student-info.md`)
   - **Used in:** academic, base, policy

4. **`[STUDENT_NAME_PERSONAL]`** - Student's personal name
   - **Default:** `"Student"` (set in `student-info.md`)
   - **Used in:** academic, base, policy

### Also used in shipped `recipients/*.md` bodies

These appear in the default `recipients/academic-position.md` (and related) files; define them in `student-info.md` like other placeholders:

- **`[KIND_OF_ECONOMIST]`** — e.g. `"macroeconomist"` (noun phrase: “is a …”).
- **`[HE_SHE]`** / **`[HIM_HER]`** — pronouns for third-person sentences in the template.
- **`[CDC_LETTER_URL]`** — link to the PDF letter; advisor often fills via private workflow; students leave default empty.
- **`[JOBMARKET_PAPER_URL]`** — link to the JMP.
- **`[CV_URL]`** — optional; stable public URL to the student’s latest CV (from `student-info.md`). Use only in templates or recipient text that reference it.

### Advisor Content Blocks

5. **`[OPTIONAL_CDC_SAY_HI]`** - Optional opening greeting from advisor **⚠️ ADVISOR-ONLY ⚠️**
   - **Default:** `""` (LEAVE EMPTY - advisor fills this in private repo)
   - **Student Action:** DO NOT EDIT - Never populate any CDC_ fields
   - **Example:** `"I wanted to reach out personally because Alex has spoken very highly of his experience working with you."`
   - **Used in:** academic, base, policy
   - **Note:** In preview mode (`--preview`), this placeholder is preserved so student can see where advisor content will go

6. **`[CDC_NICE_THINGS]`** - Main recommendation content from advisor **⚠️ ADVISOR-ONLY ⚠️**
   - **Default:** `""` (LEAVE EMPTY - advisor fills this in private repo)
   - **Student Action:** DO NOT EDIT - Never populate any CDC_ fields
   - **Example:** `"Alex is working at the cutting edge of heterogeneous-agent macro. His job-market paper shows that when an sS micro optimization problem is calibrated realistically, durable expenditure should optimally be highly sensitive to labor-income uncertainty."`
   - **Used in:** academic, base, policy
   - **Note:** In preview mode (`--preview`), this placeholder is preserved so student can see where advisor content will go

7. **`[OPTIONAL_CDC_SAY_BYE]`** - Optional closing note from advisor **⚠️ ADVISOR-ONLY ⚠️**
   - **Default:** `""` (LEAVE EMPTY - advisor fills this in private repo)
   - **Student Action:** DO NOT EDIT - Never populate any CDC_ fields
   - **Example:** `"I'd be happy to discuss Alex's work further if you'd like to schedule a Zoom call."`
   - **Used in:** academic, base, policy
   - **Note:** In preview mode (`--preview`), this placeholder is preserved so student can see where advisor content will go

### Research Description

8. **`[FIELD]`** - Research field
   - **Default:** `"economics"` (set in `student-info.md`)
   - **Example:** `"macroeconomics"` or `"applied microeconomics"`
   - **Used in:** academic, base (and optional `templates/` variants)

9. **`[RESEARCH_AGENDA_IN_ONE_SENTENCE]`** - Research agenda description
   - **Default:** short factual phrase (set in `student-info.md`)
   - **Used in:** academic

10. **`[JOBMARKET_PAPER_TITLE]`** - Job market paper title
    - **Default:** your paper title (set in `student-info.md`)
    - **Used in:** base

11. **`[JOBMARKET_PAPER_ONE_PHRASE_DESCRIPTION]`** - Brief JMP description
    - **Default:** one-sentence summary (set in `student-info.md`)
    - **Used in:** base, academic (opening line variants)

### Fit/Match with Institution

12. **`[OPTIONAL_INSTITUTION_FIT]`** - Institution-specific fit (usually **per recipient**)
    - **Source:** `OPTIONAL_INSTITUTION_FIT:` in each `recipients/<org>/email@domain.md` when non-empty; otherwise often removed in output
    - **Example:** `"Their work on X would complement your department's strengths in Y."`
    - **Used in:** academic, base, policy (depending on template)

13. **`[OPTIONAL_PEOPLE_AT_THE_INSTITUTION]`** - Optional people/divisions at institution
    - **Default:** `""` (empty - fill in when you know specific people/divisions)
    - **Example:** `"the Monetary Policy Division"` or `"your research team"` or `"I know [Name] is working on similar questions"`
    - **Used in:** academic, base, policy

### Policy-Specific Fields

14. **`[THE_INSTITUTION]`** - Institution name
    - **Default:** Organization-specific (FedBoard → `"the Federal Reserve Board"`, ECB → `"the ECB"`, etc.)
    - **Example:** `"the Federal Reserve Board"` or `"the ECB"` or `"the Bundesbank"`
    - **Used in:** base, policy
    - **Note:** For "Other" organizations, must be specified in each recipient file

15. **`[KEY_FINDING_WITH_POLICY_RELEVANCE_FOR_INSTITUTION]`** - Policy-relevant finding
    - **Default:** set in `student-info.md` (Section 4 for policy jobs)
    - **Used in:** policy

16. **`[RELEVANT_TOOLS]`** - Technical tools/skills relevant to institution
    - **Default:** set in `student-info.md`
    - **Used in:** policy

17. **`[OPTIONAL_PARTICULARLY_HIGHLIGHT]`** - Optional special highlight
    - **Default:** set in `student-info.md` (policy section)
    - **Used in:** policy

18. **`[OTHER_ACCOMPLISHMENTS]`** - Other accomplishments (beyond JMP)
    - **Default:** set in `student-info.md`
    - **Used in:** base, policy, private-sector templates

### Base Template Specific

19. **`[HIS_HER]`** - Possessive pronoun
    - **Default:** match student preference (set in `student-info.md`)
    - **Example:** `"his"` or `"her"` or `"their"`
    - **Used in:** base

## Variable Usage by Template

### `recipients/academic-position.md` (default shipped)
- `[recipient_personalname]`
- `recipient@place.dom`
- `[STUDENT_NAME_FULL]`, `[STUDENT_NAME_PERSONAL]`
- `[HE_SHE]` (twice in opening sentence)
- `[OPTIONAL_CDC_SAY_HI]`
- `[KIND_OF_ECONOMIST]`, `[RESEARCH_AGENDA_IN_ONE_SENTENCE]`
- `[JOBMARKET_PAPER_ONE_PHRASE_DESCRIPTION]`
- `[CDC_NICE_THINGS]`
- `[OPTIONAL_INSTITUTION_FIT]`, `[OPTIONAL_PERSON_FIT]`
- `[CDC_LETTER_URL]`
- `[OPTIONAL_PEOPLE_AT_THE_INSTITUTION]`
- `[JOBMARKET_PAPER_URL]`

The `templates/academic-position.md` variant uses `[FIELD]` instead of `[KIND_OF_ECONOMIST]` and a shorter opening.

### `templates/base-recommendation.md` (optional body)
- `[recipient_personalname]`
- `recipient@place.dom`
- `[STUDENT_NAME_FULL]`
- `[OPTIONAL_CDC_SAY_HI]`
- `[CDC_NICE_THINGS]`
- `[FIELD]`
- `[JOBMARKET_PAPER_TITLE]`
- `[JOBMARKET_PAPER_ONE_PHRASE_DESCRIPTION]`
- `[OPTIONAL_INSTITUTION_FIT]`
- `[OPTIONAL_PERSON_FIT]`
- `[OPTIONAL_PEOPLE_AT_THE_INSTITUTION]`
- `[OTHER_ACCOMPLISHMENTS]`
- `[HIS_HER]`
- `[THE_INSTITUTION]`
- `[STUDENT_NAME_PERSONAL]`
- `[CDC_LETTER_URL]`
- `[OPTIONAL_CDC_SAY_BYE]`

**Total: 18 variables (counts headers + body placeholders)**

### `recipients/policy-institution.md` (default shipped)
- `[recipient_personalname]`
- `recipient@place.dom`
- `[STUDENT_NAME_FULL]`
- `[OPTIONAL_CDC_SAY_HI]`
- `[CDC_NICE_THINGS]`
- `[STUDENT_NAME_PERSONAL]`
- `[JOBMARKET_PAPER_ONE_PHRASE_DESCRIPTION]`
- `[RELEVANT_TOOLS]`
- `[OTHER_ACCOMPLISHMENTS]`
- `[OPTIONAL_INSTITUTION_FIT]`
- `[OPTIONAL_PARTICULARLY_HIGHLIGHT]`
- `[CDC_LETTER_URL]`
- `[OPTIONAL_PEOPLE_AT_THE_INSTITUTION]`
- `[JOBMARKET_PAPER_URL]`

### `templates/policy-institution.md` (optional body)
- Adds opening line with `[THE_INSTITUTION]` and hiring-committee wording; otherwise overlaps the list above.

## Variables Used Across Multiple Templates

### Used in All 3 Templates
- `[recipient_personalname]` - Recipient personal name
- `recipient@place.dom` - Recipient email
- `[STUDENT_NAME_FULL]` - Student full name
- `[STUDENT_NAME_PERSONAL]` - Student personal name
- `[OPTIONAL_CDC_SAY_HI]` - Advisor opening
- `[CDC_NICE_THINGS]` - Main recommendation
- `[OPTIONAL_CDC_SAY_BYE]` - Advisor closing

### Used in multiple templates
- `[OPTIONAL_INSTITUTION_FIT]` — academic, base, policy (per-recipient where applicable)
- `[OPTIONAL_PERSON_FIT]` — academic (and similar in base variant)
- `[OPTIONAL_PEOPLE_AT_THE_INSTITUTION]` — academic, base, policy
- `[FIELD]` — `templates/` academic variant and base template; default shipped academic uses `[KIND_OF_ECONOMIST]` instead
- `[THE_INSTITUTION]` — base and `templates/policy-institution.md`
- `[CDC_LETTER_URL]` — all shipped bodies

## Special Features

### Nickname support

Recipient files can include **`NICKNAME:`** to override the salutation (still requires **`PERSONAL_NAME:`** and **`FAMILY_NAME:`**):

```markdown
NICKNAME: Alex
```

Example: `PERSONAL_NAME: Alexander` and `NICKNAME: Alex` → “Dear Alex”.

### Preview Mode

When generating preview emails with `--preview` flag:
- All student-provided placeholders are **substituted** with their values
- `[CDC_*]` placeholders (`[CDC_NICE_THINGS]`, `[OPTIONAL_CDC_SAY_HI]`, `[OPTIONAL_CDC_SAY_BYE]`) are **preserved** so students can see where advisor content will go
- Preview mode excludes private content

### Empty Field Handling

When a variable has an empty default value:
- The placeholder line is **removed** from the final email
- The blank line **following** the placeholder is also removed (to avoid extra blank lines)
- Exception: In preview mode, `[CDC_*]` placeholders are preserved even if empty

## Variable Naming Conventions

- `STUDENT_NAME_FULL` - Always use for full name references
- `STUDENT_NAME_PERSONAL` - Use when personal name is more appropriate
- `OPTIONAL_*` - Variables that are optional and may be omitted
- `CDC_*` - **Advisor-only** placeholders (legacy prefix “CDC”; filled in the private repo, not by students). Not tied to a specific person’s initials in code—treat as “advisor content blocks.”
- `*_INSTITUTION` - Institution-related variables
- `*_FIT` - Fit/match variables

## Summary Statistics

- **Total unique variables:** 20
- **Variables used in all templates:** 7
- **Variables used in 2 templates:** 4
- **Template-specific variables:** 9
- **Variables with OPTIONAL prefix:** 5
- **Variables with CDC prefix:** 3

## Additional Notes

### Preview Mode Behavior

When generating preview emails with `./emails-make.sh --preview`:
- All student-provided placeholders are **substituted** with their values from `student-info.md`
- `[CDC_*]` placeholders are **preserved** (not removed) so students can see where advisor content will go
- Preview mode excludes private content
- Output goes to `preview-emails/` directory instead of private directory

### Empty Field Handling

When a variable has an empty default value (`""`):
- The placeholder line is **removed** from the final email
- The blank line **following** the placeholder is also removed (to avoid extra blank lines)
- Exception: In preview mode, `[CDC_*]` placeholders are preserved even if empty

### Recipient names (reminder)

- **`NICKNAME:`** overrides the “Dear …” line.
- **`PERSONAL_NAME:`** / **`FAMILY_NAME:`** are required by `emails-make.sh`.
- These lines are stripped from the inserted email body text.
