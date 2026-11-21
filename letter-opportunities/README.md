# Letter opportunities (student-maintained)

Use this directory to **track each application or letter instance** in one place: posting links, deadlines, how the letter is delivered, and which email-recipient files you created.

You edit these files; your advisor reads them when he prepares each letter.

---

## Layout

```
letter-opportunities/
├── README.md                 ← This file (conventions + YAML field reference)
├── INDEX.md                  ← Optional dashboard table (you maintain)
└── <opportunity-id>/         ← One folder per role/posting (slug matches `id` in front matter)
    └── opportunity.md        ← YAML front matter + Markdown notes
```

**Naming:** Use a short, stable slug for `<opportunity-id>`, for example:

`example-dissertation-internship`

Match the folder name to the `id:` field in `opportunity.md`.

---

## Workflow

1. **Create a folder** under `letter-opportunities/` with a new slug.
2. **Copy** `example-dissertation-internship/opportunity.md` as a starting point, or create `opportunity.md` from scratch using the schema below. For Fed-style **PhD Dissertation Intern** outreach, point `related_recipient_files` at **`email-templates/recipients/internship-dissertation/…`** (see `recipients/README.md`).
3. **Fill YAML** (posting URL, deadlines, status, links to recipient files).
4. **Add narrative** under the front matter (why it fits, what the letter must mention, checklist).
5. When you need outreach email: **create or update** the file under `email-templates/recipients/<org>/email@domain.md` and list its path in `related_recipient_files`.
6. **Update `INDEX.md`** with a one-line row so you can scan everything quickly.

**Dissertation-internship letters:** those programs **do not require a teaching section**. Say so in the opportunity's checklist; your advisor's build for that destination uses a `Letter-sections.tex` that leaves Teaching out.

---

## YAML front matter (schema)

All keys are optional unless noted; use `""` or `[]` when unknown.

| Key | Meaning |
|-----|---------|
| `id` | **Required.** Stable slug; must match parent folder name. |
| `kind` | `internship` \| `faculty` \| `postdoc` \| `policy` \| `fellowship` \| `other` |
| `student_github` | Your GitHub username (e.g. `your-github-id`) for your own tracking. |
| `employer` | Institution or employer name. |
| `role_title` | Title as shown on the posting. |
| `term` | e.g. `Summer 2026`. |
| `location` | City, state/region, or `remote`. |
| `posting_url` | Canonical URL for the job or program posting. |
| `portal` | `workday` \| `interfolio` \| `email` \| `other` \| `unknown` |
| `requisition_id` | Employer’s requisition or job ID if listed. |
| `deadline_application` | Application deadline (ISO `YYYY-MM-DD` or free text). |
| `deadline_letters` | Recommendation deadline if different. |
| `letter_delivery` | `portal` \| `email` \| `interfolio` \| `hardcopy` \| `unknown` |
| `status` | `tracking` \| `student_ready` \| `advisor_draft` \| `submitted` \| `done` |
| `related_recipient_files` | List of paths **relative to repo root**, e.g. `email-templates/recipients/internship/foo@bar.org.md` |
| `letter_sent_date` | After the letter is submitted, ISO `YYYY-MM-DD` or short free text (student and/or advisor). |

**Private advisor notes** do not belong here (your advisor keeps those in the private repo). Put only facts and your own planning text in `opportunity.md`.

---

## Related documentation

- **[`../email-templates/README.md`](../email-templates/README.md)** — recipient files and `./emails-make.sh`
- **[`../email-templates/recipients/README.md`](../email-templates/recipients/README.md)** — naming rules for `email@domain.md`
- **[`../email-templates/target-jobs.md`](../email-templates/target-jobs.md)** — scratchpad (optional); link out from there to `letter-opportunities/` as you prefer
