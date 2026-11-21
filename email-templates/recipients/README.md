# Recipients Directory

This directory organizes email recipients by job type and contains the email templates.

## Structure

**Each job type has:**
1. A template file (e.g., `academic-position.md`)
2. A matching directory (e.g., `academic-position/`) with recipient files

```
recipients/
├── academic-position.md          ← Email template for academic jobs
├── academic-position/            ← Recipients for academic jobs
│   ├── example.search@university.edu.md   ← fictional example (copy pattern from RECIPIENT-FILE-TEMPLATE.md)
│   ├── search.chair@university-a.edu.md
│   └── faculty.contact@university-b.edu.md
│
├── policy-institution.md         ← Email template for policy jobs
├── policy-institution/           ← Recipients for policy jobs
│   ├── jane.smith@frb.gov.md
│   └── john.doe@frb.gov.md
│
├── private-sector-consulting.md  ← Email template for consulting
├── private-sector-consulting/    ← Recipients for consulting jobs
│   └── recruiter@firm.com.md
│
├── internship.md                 ← General dissertation / summer internships (broader wording)
├── internship/
│   └── (optional recipients; use **internship-dissertation** for PhD dissertation intern programs)
│
├── internship-dissertation.md   ← PhD dissertation intern programs (Fed-style; reduced job-market framing)
├── internship-dissertation/
│   └── contact@examplefed.org.md   ← example (a Fed PhD dissertation intern program)
│       (for the letter PDF: `\OmitBackgroundVisaParagraph` → `yes` in `student-macros.ltx`; the advisor's copy of `Letter-sections.tex` for that destination leaves out Teaching)
│
└── base-recommendation.md        ← Generic recommendation template
```

---

## How It Works

**Template Selection:** The directory name determines which template is used:
- Files in `academic-position/` → use `academic-position.md` template
- Files in `policy-institution/` → use `policy-institution.md` template
- Files in `private-sector-consulting/` → use `private-sector-consulting.md` template
- Files in `internship/` → use `internship.md` template
- Files in `internship-dissertation/` → use `internship-dissertation.md` template

**One-to-one naming:** Directory name matches template filename (minus `.md`)

---

## Creating Recipient Files

### Step 1: Choose the Right Directory

- **Academic job?** → `academic-position/`
- **Fed, Treasury, IMF, etc.?** → `policy-institution/`
- **PhD dissertation intern** (e.g. Reserve Bank summer dissertation program)? → **`internship-dissertation/`**
- **Other dissertation / summer internship** (broader wording, includes “job market paper” line)? → `internship/`
- **Consulting firm?** → `private-sector-consulting/`

### Step 2: Copy the Template

```bash
cp RECIPIENT-FILE-TEMPLATE.md academic-position/email@university.edu.md
```

### Step 3: Fill Required Fields

Edit the file and fill in:
- `PERSONAL_NAME:` and `FAMILY_NAME:`
- At least one fit explanation (`OPTIONAL_INSTITUTION_FIT`, `OPTIONAL_PERSON_FIT`, or `CUSTOM_CONTENT`)

---

## File Naming Rules

**Filename MUST exactly match the email address:**

✅ Good:
- `john.doe@frb.gov.md`
- `search.committee@university.edu.md`
- `recruiter@consultingfirm.com.md`

❌ Bad:
- `john.doe.md` (missing domain)
- `john.doe@frb.gov.txt` (wrong extension)
- `john-doe@frb.gov.md` (must match exact email)

---

## Adding a New Job Type

If you need a new template (e.g., for think tanks):

1. **Create the template file:**
   ```bash
   cp base-recommendation.md think-tank.md
   ```

2. **Create the matching directory:**
   ```bash
   mkdir think-tank
   ```

3. **Update the script:**
   Edit `emails-make.sh` and add to the case statement:
   ```bash
   think-tank)
       template_path="$TEMPLATE_BASE_DIR/think-tank.md"
       ;;
   ```

4. **Add recipient files:**
   ```bash
   cp RECIPIENT-FILE-TEMPLATE.md think-tank/person@thinktank.org.md
   ```

---

## Tips

- **Start with 10-15 priority jobs** - Don't create files for every posting
- **Empty optional fields are fine** - Only add custom content where it helps
- **Test with one** - Generate preview, check it, then do the rest
- **Validate your work** - Run `./validate-recipients.sh` before generating emails

---

## Questions?

See:
- **QUICK-START.md** (in `email-templates/`) - Step-by-step workflow
- **STUDENT-GUIDE.md** - Detailed instructions
- **RECIPIENT-FILE-TEMPLATE.md** - Copy this for each recipient
