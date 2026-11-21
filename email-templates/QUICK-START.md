# Quick Start Guide - Email Templates

**Goal:** Generate personalized recommendation emails for your job market contacts.  
**Time:** ~1.5-2 hours for initial setup, ~15 minutes per priority job.

---

## Four Steps to Success

### Step 1: Fill Your Information (One-Time Setup)

**Edit:** `student-info.md`

Fill in your basic information:
- Sections 1-3 are REQUIRED (20 minutes)
- Section 4 is OPTIONAL (only if applying to policy jobs)
- Skip Section 4 if only applying to universities

**Leave empty:** All `CDC_*` fields (advisor fills these)

**Time:** 20-25 minutes

---

### Step 2: Create Recipient Files (Your Priority Jobs)

**For each priority contact:**

1. Copy the template:
   ```bash
   cp recipients/RECIPIENT-FILE-TEMPLATE.md recipients/academic-position/email@university.edu.md
   ```

2. Fill required fields:
   - `PERSONAL_NAME:` and `FAMILY_NAME:` (from the email address or job posting)
   
3. Add **at least ONE** fit explanation:
   - `OPTIONAL_INSTITUTION_FIT:` - Why this institution fits your research
   - `OPTIONAL_PERSON_FIT:` - How your work connects to this person's research
   - `CUSTOM_CONTENT:` - Personal connection or custom message

**Focus on 10-15 priority jobs, not everyone.**

**Time:** 10-15 minutes per recipient

---

### Step 3: Generate Preview Emails

**Run:**
```bash
./emails-make.sh --preview
```

**Check:** Preview emails appear in `preview-emails/[Organization]/`

**Look for:**
- `[CDC_NICE_THINGS]` placeholders (advisor will fill these)
- Your fit explanations are inserted correctly
- No typos or formatting issues

**Time:** 5 minutes

---

### Step 4: Validate Your Work

**Run:**
```bash
./validate-recipients.sh
```

**Fix any errors** the script reports.

**Time:** 5 minutes

---

## What Happens Next?

Your advisor will:
1. Review your preview emails
2. Fill in the `[CDC_*]` placeholders with recommendation content
3. Send the emails to your contacts

---

## Key Conventions

### UPPERCASE vs lowercase Fields

**UPPERCASE** = Appears in the email
- `PERSONAL_NAME`, `FAMILY_NAME`, `NICKNAME`
- `OPTIONAL_INSTITUTION_FIT`, `OPTIONAL_PERSON_FIT`
- `CUSTOM_CONTENT`

**lowercase** = Private note to advisor (NOT in email)
- `optional_private_comment_to_advisor`

---

## Common Questions

**Q: Do I need a recipient file for every job posting?**  
A: No! Only for your top 10-15 priority jobs where personalization adds value.

**Q: What if I don't have a personal connection?**  
A: Focus on research fit - explain how your work connects to their institution or research.

**Q: Can I see the emails before they're sent?**  
A: Yes! Step 3 generates preview emails you can review.

**Q: What if I make a mistake?**  
A: Just edit the recipient file and run `./emails-make.sh --preview` again.

---

## Need More Detail?

- **Full student guide:** [`STUDENT-GUIDE.md`](STUDENT-GUIDE.md)
- **Field reference:** [`docs/TEMPLATE-VARIABLES-INVENTORY.md`](docs/TEMPLATE-VARIABLES-INVENTORY.md)
- **Template to copy:** [`recipients/RECIPIENT-FILE-TEMPLATE.md`](recipients/RECIPIENT-FILE-TEMPLATE.md)
- **System architecture:** [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)

---

**Ready? Start with Step 1! 🚀**

