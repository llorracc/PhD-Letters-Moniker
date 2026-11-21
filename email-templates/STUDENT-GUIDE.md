# Student Guide - Email Templates

> **New here?** Start with **[QUICK-START.md](QUICK-START.md)** for a 1-page overview.

This guide explains the email template system and what you need to do.

---

## Overview

Your advisor uses this system to send personalized recommendation emails for your job market. You provide the information; your advisor writes and sends the emails.

**What you edit:**
1. `student-info.md` - Your name, research description (one-time setup)
2. `recipients/*.md` - Individual recipient files (10-15 priority jobs)

**What your advisor edits:**
- Email templates (you don't touch these)
- `CDC_*` fields (recommendation content)

---

## Convention: UPPERCASE vs lowercase

**UPPERCASE fields** = Inserted directly into email
- `PERSONAL_NAME`, `FAMILY_NAME`, `NICKNAME`
- `OPTIONAL_INSTITUTION_FIT`, `OPTIONAL_PERSON_FIT`
- `CUSTOM_CONTENT`

**lowercase fields** = Private notes to advisor (NOT inserted in email)
- `optional_private_comment_to_advisor`

**Write email-ready content:** Your UPPERCASE field content goes directly into the email. Write as if your advisor is saying it.

---

## File 1: student-info.md (One-Time Setup)

**Purpose:** Default values used for all emails

**What to fill:**
- `STUDENT_NAME_FULL` - Your full name
- `STUDENT_NAME_PERSONAL` - Your first name
- `FIELD` - Your field (e.g., "macroeconomics")
- `KIND_OF_ECONOMIST` - Type of economist (e.g., "macroeconomist")
- `RESEARCH_AGENDA_IN_ONE_SENTENCE` - Brief research description
- `JOBMARKET_PAPER_TITLE` - Your JMP title
- `JOBMARKET_PAPER_URL` - Link to your JMP
- `JOBMARKET_PAPER_ONE_PHRASE_DESCRIPTION` - One-sentence JMP summary

**What to IGNORE:**
- All `CDC_*` fields (advisor fills these)
- All `OPTIONAL_CDC_*` fields (advisor fills these)

**Leave them empty** - your advisor fills them in the private repository.

---

## File 2: recipients/*.md (Per Priority Job)

**Purpose:** Customization for each high-priority contact (10-15 jobs)

### Required Fields

Every recipient file must have:

```markdown
PERSONAL_NAME: FirstName
FAMILY_NAME: LastName
```

### Optional Fields

Add **at least ONE** of these to explain why this job is a good fit:

#### OPTIONAL_INSTITUTION_FIT
Why this institution/job fits your research.

**Example:**
```markdown
OPTIONAL_INSTITUTION_FIT: Alex's work on wealth inequality and heterogeneous-agent models would be a strong fit for the department's macroeconomics group.
```

#### OPTIONAL_PERSON_FIT
How your work connects to this person's research.

**Example:**
```markdown
OPTIONAL_PERSON_FIT: I know your longstanding interest in the distribution of wealth, so I think you'll be particularly interested in Alex's research.
```

#### CUSTOM_CONTENT
Personal connection or custom message (inserted after greeting).

**Example:**
```markdown
CUSTOM_CONTENT: Alex tells me you were a mentor of his in the ASSA program for URMs, and that your advice was very helpful to him.
```

#### NICKNAME (Optional)
Use for people who go by nicknames.

**Example:**
```markdown
NICKNAME: Alex
```

This overrides `PERSONAL_NAME` in the salutation ("Dear Alex" instead of "Dear Alexander").

#### optional_private_comment_to_advisor (Optional, lowercase)
Private note/question for your advisor (NOT inserted in email).

**Example:**
```markdown
optional_private_comment_to_advisor: I think you told me this person was a colleague of yours when you worked at the Fed?
```

---

## Creating a Recipient File

**Step 1: Copy the template**
```bash
cp recipients/RECIPIENT-FILE-TEMPLATE.md recipients/academic-position/email@university.edu.md
```

**Step 2: Fill required fields**
- `PERSONAL_NAME` and `FAMILY_NAME`

**Step 3: Add at least ONE fit explanation**
- Choose from: `OPTIONAL_INSTITUTION_FIT`, `OPTIONAL_PERSON_FIT`, or `CUSTOM_CONTENT`
- Write email-ready content (not notes)

**Step 4: Validate**
```bash
./validate-recipients.sh
```

---

## Generating Preview Emails

**Generate previews:**
```bash
./emails-make.sh --preview
```

**Check output:**
- Preview emails appear in `preview-emails/[Organization]/`
- `[CDC_*]` placeholders show where advisor content will go
- Your fit explanations should be inserted correctly

**Regenerate anytime:**
```bash
./emails-make.sh --preview
```

---

## Common Questions

**Q: Do I need a recipient file for everyone?**  
A: No! Only for your top 10-15 priority jobs where personalization adds value.

**Q: How long should OPTIONAL_INSTITUTION_FIT be?**  
A: 1-2 sentences. Keep it concise and specific.

**Q: Can I use multiple fit fields?**  
A: Yes, but don't overdo it. Choose 1-2 that best explain the fit.

**Q: What if I don't know the person's first name?**  
A: For generic addresses like `search@university.edu`, use:
```markdown
PERSONAL_NAME: Search
FAMILY_NAME: Committee
NICKNAME: Search Committee
```

**Q: What's the difference between OPTIONAL_PERSON_FIT and CUSTOM_CONTENT?**  
A: `OPTIONAL_PERSON_FIT` is about research connections. `CUSTOM_CONTENT` is for personal connections (met at conference, former RA, etc.).

**Q: How do I know if my content is email-ready?**  
A: Ask yourself: "Could my advisor copy-paste this into the email as-is?" If not, expand it.

---

## Tips for Success

✅ **Write complete sentences** - Not just notes  
✅ **Be specific** - Name research areas, projects, connections  
✅ **Focus on fit** - Why THIS job/person/institution  
✅ **Keep it concise** - 1-2 sentences per field  
✅ **Use preview mode** - Check your work before sharing  
✅ **Validate early** - Run `./validate-recipients.sh` to catch errors

❌ **Don't fill CDC_ fields** - Advisor-only  
❌ **Don't be generic** - "Would be a good fit" is too vague  
❌ **Don't write notes** - Write email content

---

## Getting Help

- **Quick start:** [`QUICK-START.md`](QUICK-START.md)
- **Field reference:** [`docs/TEMPLATE-VARIABLES-INVENTORY.md`](docs/TEMPLATE-VARIABLES-INVENTORY.md)
- **Template to copy:** [`recipients/RECIPIENT-FILE-TEMPLATE.md`](recipients/RECIPIENT-FILE-TEMPLATE.md)
- **System design:** [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)
- **Technical docs:** [`README.md`](README.md)

---

**Ready to start? See [QUICK-START.md](QUICK-START.md) for the 4-step workflow!**
