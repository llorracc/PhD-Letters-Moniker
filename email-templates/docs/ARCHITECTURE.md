# Email Templates System Architecture

## Single Source of Truth (SST) Principles

This system follows strict SST principles to avoid duplication and ensure consistency.

## ⚠️ IMPORTANT: CDC_ Fields Are Advisor-Only ⚠️

**All fields beginning with `CDC_` are filled by the advisor in the private repository.**

- `CDC_NICE_THINGS` - Main recommendation content
- `OPTIONAL_CDC_SAY_HI` - Optional opening greeting
- `OPTIONAL_CDC_SAY_BYE` - Optional closing note

**Students must NEVER populate these fields.** They are left empty in `student-info.md` and filled by the advisor during the private email generation process.

## SST Assignments

### Student Information
**Location:** `student-info.md`
**Contains:**
- Student's full name
- Student's email addresses
- Student's title/affiliation
- Default JMP description
- Default research description

### Job postings (structured registry)

**Location:** `letter-opportunities/<id>/opportunity.md` (repository root, next to `Letter.tex`)

**Contains:** YAML front matter (posting URL, employer, deadlines, delivery method, status) plus Markdown notes and checklists. List related `email-templates/recipients/...` paths in `related_recipient_files`.

**Purpose:** Single student-edited record per application or letter instance. Not consumed by `emails-make.sh`.

### Job postings (informal scratchpad)

**Location:** `target-jobs.md`

**Contains:** Free-form exploration notes while you research the market.

**Purpose:** Draft ideas before you promote an entry to `letter-opportunities/`.

### Email Generation Fields
**Location:** `recipients/[Institution]/email@domain.ext.md`
**Contains:**
- Email address (copied from target-jobs.md)
- Personal and family names (copied from target-jobs.md)
- Email customization fields (fit explanations, connection messages)
- Custom content for emails

**Purpose:** Detailed customization for selected high-priority contacts (10-15)

### Email Templates
**Location:** `recipients/*.md`
**Contains:**
- Base email structure
- Advisor's standard language
- Placeholder locations

**Managed by:** Advisor only

### Progress Tracking
**Location:** `PhD-RecLetters-private/emails/` (private repository)
- `sent-emails.log` - Automatic log of all sent emails with timestamps
- `sent/` - Archived copies of sent emails
- `omitted/` - Emails that weren't sent

**Managed by:** Automated scripts (no manual updates needed)

## Information Flow

```
Job Market Research
    ↓
target-jobs.md (SST for job postings, names, connections)
    ↓
Select Priority Jobs (10-15)
    ↓
recipients/*.md (SST for email customization)
    ↓
emails-make.sh + recipients/*.md + student-info.md
    ↓
Generated Emails
    ↓
Automatic Tracking: sent-emails.log (private repo)
```

## Why Two Levels?

### Level 1: `target-jobs.md` - Job Postings Catalog
- Master catalog of attractive job postings (organized by institution)
- Why each job/institution is a good fit
- Complete contact information for all relevant people
- Personal connection history
- Institutional research notes
- Quick reference lookup

### Level 2: `recipients/` Directory - Email Customization
- Detailed files for top priority contacts (10-15 jobs)
- Organized by individual person (not institution)
- Email-ready customization
- Fields optimized for email generation
- More structured format

## What Goes Where?

| Information Type | SST Location | Also Appears In | Purpose |
|-----------------|--------------|-----------------|---------|
| Job postings | `target-jobs.md` | — | Master catalog |
| Why job/institution is attractive | `target-jobs.md` | `recipients/*.md` (as institution_fit) | Research notes → Email content |
| Full contact names | `target-jobs.md` | `recipients/*.md` (copied) | Master reference |
| Email addresses | `target-jobs.md` | `recipients/*.md` (copied) | Master reference |
| Personal connection notes | `target-jobs.md` | `recipients/*.md` (as connection_message) | Brief reference → Email content |
| Fit explanations | `recipients/*.md` | — | Email customization |
| Connection messages | `recipients/*.md` | — | Email customization |
| Custom content | `recipients/*.md` | — | Email customization |
| Student info | `student-info.md` | — | All emails |
| Email templates | `recipients/*.md` | — | All emails |
| Sent email tracking | `sent-emails.log` (private) | — | Automatic tracking |
| Email archives | `sent/` (private) | — | Automatic archiving |

## Key Principles

**Information flows one direction:**
- `target-jobs.md` → `recipients/*.md` (copy contact info, expand fit reasoning into email content)
- Never the reverse

**Each piece of information has ONE authoritative source:**
- Job postings and institutional research → `target-jobs.md`
- Contact names and emails → `target-jobs.md`
- Student information → `student-info.md`
- Email customization → `recipients/*.md`
- Sent email tracking → Automated in private repo

**No manual tracking:**
- Sent emails are logged automatically
- No need to update multiple files manually
- Single action (sending) triggers automatic recording

