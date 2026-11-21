# Email Templates System

This directory contains tools for generating personalized recommendation emails for job market outreach.

> **👨‍🎓 Students**: See **[QUICK-START.md](../QUICK-START.md)** (1 page) or **[STUDENT-GUIDE.md](../STUDENT-GUIDE.md)** (detailed) for how to use this system.  
> **📖 Also see**: [`../../STUDENT-GUIDE.md`](../../STUDENT-GUIDE.md) for the letter itself  
> **👨‍🏫 Faculty**: Continue reading below for technical documentation.

**Also read:** [`../README.md`](../README.md) — how `emails-make.sh` expects `student-info.md`, `recipients/`, and `preview-emails/` to be laid out (student-facing index + script contract).

## Purpose

During the job market, you may want to send personalized emails to hiring committees or individual faculty members to highlight your student. This system:

1. Maintains base email templates for different contexts
2. Allows per-recipient customization
3. Automatically generates ready-to-send `.eml` files
4. Tracks who you've contacted

## Workflow Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                        STUDENT WORKFLOW                          │
│                   (the student's letters repo)                   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Fill student-info.md (one-time setup)                       │
│     • Name, field, research description                         │
│     • Job market paper info                                     │
│     • Leave CDC_* fields empty                                  │
│                                                                  │
│  2. Create recipients/*.md files (10-15 priority jobs)          │
│     • Copy RECIPIENT-FILE-TEMPLATE.md                           │
│     • Fill PERSONAL_NAME, FAMILY_NAME (required)                │
│     • Add at least ONE fit explanation                          │
│                                                                  │
│  3. Generate preview emails                                      │
│     ./emails-make.sh --preview                                  │
│                                                                  │
│  4. Validate                                                     │
│     ./validate-recipients.sh                                    │
│                                                                  │
│  5. Share preview-emails/ with advisor                          │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
                              │
                              │ Review preview-emails/
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                        ADVISOR WORKFLOW                          │
│                   (PhD-RecLetters-private repo)                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Review student's preview emails                             │
│     • Check fit explanations                                    │
│     • Review custom content                                     │
│     • See [CDC_*] placeholders showing where your content goes  │
│                                                                  │
│  2. Fill CDC_* fields (recommendation content)                  │
│     cd PhD-RecLetters-private/emails/scripts                    │
│     ./fill-email-fields.sh                                      │
│     • CDC_LETTER_URL (once, globally)                           │
│     • CDC_NICE_THINGS (per email, can reuse)                    │
│     • OPTIONAL_CDC_SAY_HI (optional greeting)                   │
│     • OPTIONAL_CDC_SAY_BYE (optional closing)                   │
│                                                                  │
│  3. Preview final emails                                         │
│     ./send-emails.sh --dry-run                                  │
│                                                                  │
│  4. Send emails (OAuth2 via Gmail API)                          │
│     ./send-emails.sh                                            │
│     • Emails appear in Gmail Sent folder                        │
│     • Automatically logged to sent-emails.log                   │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

## Quick Start

### 0. Set Default Values

Edit `student-info.md` with student information and default values for all template variables. These defaults will be used for all recipients unless overridden.

### 1. Create Base Template

Edit `recipients/base-recommendation.md` with your standard email text.

### 2. Add Recipients

Create files in `recipients/` subdirectories:

```bash
# For Federal Reserve Board position
echo "John is particularly interested in research on..." > recipients/policy-institution/john.doe@frb.gov.md
```

### 3. Generate Emails

**Generate emails (both modes output to preview-emails/):**
```bash
# Normal mode: full recommendation text included
./emails-make.sh

# Preview mode: recommendation text replaced with [saynicethings] placeholder
./emails-make.sh --preview
```
Both modes create `.eml` files in `preview-emails/` (shared repo). In preview mode:
- All student-provided placeholders are **substituted** with their values
- `[CDC_*]` placeholders (`[CDC_NICE_THINGS]`, `[OPTIONAL_CDC_SAY_HI]`, `[OPTIONAL_CDC_SAY_BYE]`) are **preserved** so students can see where advisor content will go
- Preview mode excludes private content

### 4. Using nicknames

If a recipient goes by a nickname, add **`NICKNAME:`** (still keep **`PERSONAL_NAME:`** / **`FAMILY_NAME:`**):

```markdown
NICKNAME: Alex
```

Examples:
- `PERSONAL_NAME: Alexander` and `NICKNAME: Alex` → "Dear Alex"
- `PERSONAL_NAME: Russell` and `NICKNAME: Russ` → "Dear Russ"

### 5. Review and Edit (Optional)

The generated `.eml` files are plain text files that you can edit in any text editor before sending. For example:
- Customize the subject line for specific positions
- Add or modify any content as needed
- Fix any template placeholders that weren't automatically filled

### 6. Send Emails

Open the `.eml` files in your mail client, review your edits, and send.

## Directory structure (`email-templates/`)

```
email-templates/
├── README.md
├── QUICK-START.md
├── STUDENT-GUIDE.md
├── docs/
│   ├── ARCHITECTURE.md
│   ├── TEMPLATE-VARIABLES-INVENTORY.md
│   ├── STUDENT-INFO-FULL-REFERENCE.md   # long-form student-info help
│   └── ADVISOR-README.md                # this file
├── emails-make.sh
├── validate-recipients.sh
├── student-info.md
├── recipients/
│   ├── RECIPIENT-FILE-TEMPLATE.md
│   ├── academic-position.md             # body template for folder academic-position/
│   ├── academic-position/
│   ├── policy-institution.md
│   ├── policy-institution/
│   └── ...
└── preview-emails/                      # generated output
```

**Note:** Template selection is automatic based on organization directory:
- `policy-institution/` → `recipients/policy-institution.md`
- `academic-position/` → `recipients/academic-position.md`
- `private-sector-consulting/` → `recipients/private-sector-consulting.md`

## How It Works

### Base Templates

Templates (in `recipients/`) contain:
- Standard email structure (From, To, Subject, etc.)
- Generic body text about the student
- Placeholders: `[recipient_personalname]` (from **`PERSONAL_NAME:`** in recipient file), `recipient@place.dom`

### Recipient Files

For each person you want to email, create `email@domain.ext.md`:

```bash
recipients/policy-institution/jane.smith@frb.gov.md
```

**Format (required field names for `emails-make.sh`):**

```markdown
PERSONAL_NAME: Alex
FAMILY_NAME: Smith
NICKNAME: Alex

OPTIONAL_INSTITUTION_FIT: ...
```

**File can include:**
- **Comment lines** (`%`): reference only, not inserted into emails
- **`PERSONAL_NAME:` / `FAMILY_NAME:`** (required)
- **`NICKNAME:`** (optional salutation override)
- **Fit / custom paragraphs** as in `RECIPIENT-FILE-TEMPLATE.md`

`PERSONAL_NAME`, `FAMILY_NAME`, and `NICKNAME` lines are stripped from the body text inserted into the `.eml`.

See **[STUDENT-GUIDE.md](STUDENT-GUIDE.md)** for complete documentation and **[recipients/RECIPIENT-FILE-TEMPLATE.md](recipients/RECIPIENT-FILE-TEMPLATE.md)** for a copy-paste template.

### Generation process

The script (`emails-make.sh`):
1. Reads base template for organization
2. For each recipient file:
   - Reads **`PERSONAL_NAME:`** and **`FAMILY_NAME:`** (REQUIRED)
   - Reads optional **`NICKNAME:`**
   - Applies default values from `student-info.md`
   - Replaces `[recipient_personalname]` with `NICKNAME` (if set) else `PERSONAL_NAME`
   - Replaces `recipient@place.dom` with actual email
   - Inserts custom content from recipient file (excluding comments and nickname line)
   - Removes empty optional fields and their following blank lines
   - Processes template placeholders and default values
   - In preview mode: replaces recommendation text with `[saynicethings]` placeholder
   - Note: Letter excerpt is NOT added here - it's added by `fill-email-fields.sh` (in private repo) when copying to private repo
3. Saves `.eml` file ready to send

## Personal Connections

For people with personal connections (met at conferences, RA relationships, co-authors, etc.), add a simple entry to `CONNECTIONS.md` as a reference, then write the personalized content directly in the recipient file.

Example: If you met someone at a conference, add to `CONNECTIONS.md`:
```
person@university.edu | met | Met at NBER Summer Institute
```

Then create `recipients/academic-position/person@university.edu.md` with personalized content:
```
Alex mentioned that he met you at [conference/event] and was particularly interested in your work on [topic], which connects to his research on wealth inequality and heterogeneous-agent models.
```

## Advanced Usage

### Template Selection

Template selection is automatic based on the organization directory name:
- `policy-institution/` → `recipients/policy-institution.md`
- `academic-position/` → `recipients/academic-position.md`  
- `private-sector-consulting/` → `recipients/private-sector-consulting.md`

To add a new organization type, edit the mapping in `emails-make.sh` (search for "Map organization directory to template file").

### Custom Content Insertion

Recipient-specific `.md` files are inserted after a trigger phrase in the template.

Example template has:
```
Dear [recipient_personalname],

I am writing to recommend...

[CUSTOM CONTENT INSERTED HERE]

In summary, they would be...
```

Your `john.doe@frb.gov.md` content appears at `[CUSTOM CONTENT INSERTED HERE]`.

### Batch Processing

Process all organizations:
```bash
./emails-make.sh
```

Process specific organization:
```bash
./emails-make.sh policy-institution
```

## Example Workflow

### Initial Setup

1. Write base template in `recipients/base-recommendation.md`
2. Extract letter excerpt to `../../PhD-RecLetters-private/emails/letter-excerpt.txt`

### For Each Organization

1. Create directory: `mkdir -p recipients/NewOrg`
2. Add template mapping to `emails-make.sh` (see "Map organization directory to template file" section)
3. Add recipient files: `recipients/NewOrg/person@org.com.md`
4. Add custom content if needed

### Generate and Send

1. Run `./emails-make.sh NewOrg`
2. Review output in `../../PhD-RecLetters-private/sent-emails/NewOrg/`
3. Open `.eml` files and send from your mail client

## Template Variables

All template variables are documented in **[TEMPLATE-VARIABLES-INVENTORY.md](TEMPLATE-VARIABLES-INVENTORY.md)**.

Key variables:
- `[recipient_personalname]` - From **`PERSONAL_NAME:`** (required); optional **`NICKNAME:`** overrides salutation
- `[STUDENT_NAME_FULL]`, `[STUDENT_NAME_PERSONAL]` - Student name (set in `student-info.md`)
- `[CDC_NICE_THINGS]`, `[OPTIONAL_CDC_SAY_HI]`, `[OPTIONAL_CDC_SAY_BYE]` - **ADVISOR-ONLY content** (preserved as placeholders in preview mode so student can see where advisor content will go)
- `[FIELD]`, `[RESEARCH_AGENDA_IN_ONE_SENTENCE]`, etc. - Research description (set in `student-info.md`)

Default values are set in `student-info.md`. Empty optional fields are automatically removed from final emails (along with their following blank lines).

## Tips

- **Start early**: Set up templates before job market opens
- **Personalize**: Even 1-2 sentences of custom content makes a difference
- **Test first**: Generate one email and test before batch processing
- **Track carefully**: Use contact files to avoid duplicate emails
- **Update excerpt**: Keep letter excerpt current as letter evolves
- **Use nicknames**: Add `NICKNAME: Alex` when salutation should differ from `PERSONAL_NAME`

## Customization

### Changing Insertion Point

Edit the `sed` command in `emails-make.sh` to change where custom content appears.

### Adding Organization-Specific Headers

Some organizations may need special CC: or Bcc: handling. Edit `emails-make.sh` to add conditional logic.

### Different Email Formats

You can create entirely different templates for different contexts:
- Research universities
- Teaching-focused schools
- Policy institutions
- Private sector
- International positions

## Troubleshooting

### Script fails with `rpl` error

Install `rpl`:
```bash
brew install rpl  # macOS
apt-get install rpl  # Linux
```

### Custom content not appearing

Check:
- File is non-empty
- Insertion point in template is correct
- File naming matches email address exactly

### Emails look garbled

Ensure:
- Templates use plain text (no rich formatting)
- Avoid special characters that need escaping
- Test with a simple email first

## Requirements

- `bash`
- `sed`
- `rpl` (for string replacement)
- Mail client that can open `.eml` files

