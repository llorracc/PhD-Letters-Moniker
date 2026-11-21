# Student info & variables — full reference (read-only help)

> **Students:** edit **`../student-info.md`** in `email-templates/` for your defaults. This file is an extended field-by-field reference (examples use fictional names).

This document lists default values and conventions for email template variables.

**How to use this file:**
1. Fill in **`student-info.md`** first (short form).
2. Use this file when you need detail on a variable or recipient-file conventions.
3. Leave empty `""` when a default should be blank.
4. Per-job overrides go in `recipients/<organization>/email@domain.md`.

## Core Variables (All Templates)

### recipient_personalname
**Default:** `""` (REQUIRED: set via the `PERSONAL_NAME:` line in each recipient file; scripts map it to `[recipient_personalname]`.)
**Note:** `FAMILY_NAME:` is also required. Optional `NICKNAME:` overrides the salutation (e.g. Dear Alex).
**Example:** `"Russell"` or `"Search Committee"` or `"Dear"` (for formal addresses)

### recipient@place.dom
**Default:** `""` (extracted from recipient filename or `email:` field in recipient file)

### STUDENT_NAME_FULL
**Default:** `"Alex Candidate"`

### STUDENT_NAME_PERSONAL
**Default:** `"Alex"`

### CV_URL
**Default:** `"https://example.edu/your-cv.pdf"` (replace with your real permalink)
**Purpose:** Same idea as **` \CVUrl`** in **`student-macros.ltx`**: a **stable public URL** that always serves your **latest** CV. Use it in **`student-info.md`** so any email template that includes **`[CV_URL]`** stays aligned with the letter. Most body templates do not include `[CV_URL]` by default; you can still cite it in **`CUSTOM_CONTENT`** or **`OPTIONAL_INSTITUTION_FIT`** in a recipient file, or add `[CV_URL]` to a custom template copy. Leave as `""` if you do not use it in email text.

## Advisor Content Blocks (All Templates)

**⚠️ IMPORTANT: DO NOT EDIT THESE FIELDS ⚠️**

All fields beginning with `CDC_` are **ADVISOR-ONLY** fields. They are filled in the private repository by your advisor during the email generation process. Students should **NEVER** populate these fields.

These placeholders appear in templates to show where advisor content will be inserted. Leave them empty (default: `""`).

### OPTIONAL_CDC_SAY_HI
**Default:** `""` (LEAVE EMPTY - advisor fills this in the private repo)
**Purpose:** Optional opening greeting from advisor
**Example of advisor content:** `"I wanted to reach out personally because Alex has spoken very highly of his experience working with you."`

### CDC_NICE_THINGS
**Default:** `""` (LEAVE EMPTY - advisor fills this in the private repo)
**Purpose:** Main recommendation content from advisor
**Example of advisor content:** `"Alex is working at the intersection of macroeconomics and inequality. His job-market paper shows that rate-of-return heterogeneity is sufficient to generate observed wealth heterogeneity, with important implications for understanding inequality and policy design."`

### OPTIONAL_CDC_SAY_BYE
**Default:** `""` (LEAVE EMPTY - advisor fills this in the private repo)
**Purpose:** Optional closing note from advisor
**Example of advisor content:** `"I'd be happy to discuss Alex's work further if you'd like to schedule a Zoom call."`
**Note:** In preview mode (`--preview`), this placeholder is preserved so students can see where advisor content will go.

## Research Description

### FIELD
**Default:** `"macroeconomics"`
**Used in:** base
**Usage:** "a [FIELD] student" → "a macroeconomics student"
**Source:** Letter describes Alex as working in macroeconomics with focus on inequality
**Example:** `"macroeconomics"` or `"applied microeconomics"` or `"labor economics"` or `"econometrics"`

### KIND_OF_ECONOMIST
**Default:** `"macroeconomist"`
**Used in:** academic
**Usage:** "is a [KIND_OF_ECONOMIST]" → "is a macroeconomist"
**Source:** Letter describes Alex as a macroeconomist
**Example:** `"macroeconomist"` or `"heterogeneous-agent macroeconomist"` or `"applied microeconomist"` or `"labor economist"` or `"econometrician"`

### RESEARCH_AGENDA_IN_ONE_SENTENCE
**Default:** `"focuses on the intersection of macroeconomics and inequality, particularly how aggregate shocks are transmitted across households with different income and wealth profiles"`
**Used in:** academic
**Source:** Letter future-research section
**Example:** `"focuses on the intersection of macroeconomics and inequality, particularly how aggregate shocks are transmitted across households with different income and wealth profiles"` or `"combines heterogeneous-agent modeling with empirical methods to study distributional consequences of macroeconomic policies"`

### JOBMARKET_PAPER_TITLE
**Default:** `"Matching Wealth Moments with Heterogeneous Returns"`
**Used in:** base
**Source:** student-macros.ltx
**Example:** `"Matching Wealth Moments with Heterogeneous Returns"` or `"[Title of Job Market Paper]"`

### JOBMARKET_PAPER_ONE_PHRASE_DESCRIPTION
**Default:** `"shows that observed variation in rate-of-return heterogeneity is, by itself, sufficient to generate the observed degree of wealth heterogeneity, using a state-of-the-art stochastic dynamic life cycle model calibrated to match empirical estimates of household income processes and life cycle patterns"`
**Used in:** base, academic, policy
**Source:** jmp.tex - main finding about wealth and return heterogeneity
**Example:** `"shows that observed variation in rate-of-return heterogeneity is, by itself, sufficient to generate the observed degree of wealth heterogeneity, using a state-of-the-art stochastic dynamic life cycle model calibrated to match empirical estimates of household income processes and life cycle patterns"` or `"[Brief one-sentence description of the main finding or contribution]"`

### JOBMARKET_PAPER_URL
**Default:** `"https://YOURGITHUB.github.io/files/Chp1-draft.pdf"`
**Used in:** base, policy
**Example:** `"https://YOURGITHUB.github.io/files/Chp1-draft.pdf"` or `"https://github.com/user/repo/blob/main/JMP.pdf"`
**Note:** This URL will be inserted into the email where the job market paper is mentioned. Leave empty if no URL is available.

### RECOMMENDATION_LETTER_URL
**Default:** `"https://www.dropbox.com/scl/fi/XXXXX/Letter-CANDIDATE_GITHUB_ID-for_ADVISOR-from.pdf?rlkey=XXXXX&dl=0"`

**Example:** `"https://www.dropbox.com/scl/fi/XXXXX/Letter-CANDIDATE_GITHUB_ID-for_advisor-from.pdf?rlkey=example_key&st=example&dl=0"`
**Used in:** all templates
**Example:** `"https://example.com/path/to/letter.pdf"` or `"https://github.com/user/repo/blob/main/Letter.pdf"`
**Note:** This URL will be inserted into the email where it says "I'm attaching my full recommendation letter" - change that text to include the link.

## Fit/Match with Institution

### OPTIONAL_PEOPLE_AT_THE_INSTITUTION
**Default:** `""` (empty - fill in when you know specific people/divisions)
**Used in:** academic, base, policy
**Example:** `"the Monetary Policy Division"` or `"your research team"` or `"I know [Name] is working on similar questions"` or `"the macro group"` or `"your computational economics group"`

## Policy-Specific Fields

### THE_INSTITUTION
**Default:** `""` (Organization-specific defaults set below)
**Used in:** policy
**Note:** Organization-specific defaults are set below. For "Other" organizations, this must be specified in each recipient file.

#### Organization-Specific Defaults for THE_INSTITUTION:

**policy-institution/**
**Default:** `"the Federal Reserve Board"`

**ECB/**
**Default:** `"the ECB"`

**Bundesbank/**
**Default:** `"the Bundesbank"`

**Other/**
**Default:** `""` (REQUIRED - must be specified in each recipient file)

**Examples for recipient files:**
- `"the Federal Reserve Board"` or `"The Fed"`
- `"the ECB"` or `"the European Central Bank"`
- `"the Bundesbank"` or `"the Deutsche Bundesbank"`
- `"the Riksbank"` or `"Sveriges Riksbank"`
- `"CBO"` or `"the Congressional Budget Office"`

### KEY_FINDING_WITH_POLICY_RELEVANCE_FOR_INSTITUTION
**Default:** `"rate-of-return heterogeneity is sufficient to generate observed wealth heterogeneity, and capital income taxes have a larger impact on reducing wealth inequality than wealth taxes because they more directly target high-return (and hence high-wealth) households"`
**Used in:** policy
**Source:** Letter JMP section - policy implications finding
**Example:** `"rate-of-return heterogeneity is sufficient to generate observed wealth heterogeneity, and capital income taxes have a larger impact on reducing wealth inequality than wealth taxes because they more directly target high-return (and hence high-wealth) households"`

### RELEVANT_TOOLS
**Default:** `"heterogeneous-agent models, Python, the HARK toolkit for computational economics (https://github.com/econ-ark/HARK), and stochastic dynamic life cycle modeling"`
**Used in:** policy
**Source:** Letter mentions HARK, Python, computational methods; Fed internship experience
**Example:** `"heterogeneous-agent models, Python, the HARK toolkit for computational economics (https://github.com/econ-ark/HARK), and stochastic dynamic life cycle modeling"` or `"computational methods for solving heterogeneous-agent models"`

### OPTIONAL_PARTICULARLY_HIGHLIGHT
**Default:** `"Alex's work on wealth inequality and heterogeneous returns has direct policy relevance, particularly for understanding the distributional effects of taxation policies. His framework comparing wealth taxes versus capital income taxes provides valuable insights for policy institutions."`
**Used in:** policy
**Source:** jmp.tex policy implications section
**Example:** `"Alex's work on wealth inequality and heterogeneous returns has direct policy relevance, particularly for understanding the distributional effects of taxation policies. His framework comparing wealth taxes versus capital income taxes provides valuable insights for policy institutions."` or `"Alex's experience with Fed internship and computational methods makes him well-suited for policy-relevant research"`

### OTHER_ACCOMPLISHMENTS
**Default:** `"has additional research on trust and household returns (second chapter), contributed to the Econ-ARK toolkit, served as a Fed intern in Financial Stability division, and presented at the 2025 AEA Summer Mentoring Pipeline Conference"`
**Source:** Letter other-papers section, intro section, and background section
**Example:** `"has additional research on trust and household returns (second chapter), contributed to the Econ-ARK toolkit, served as a Fed intern in Financial Stability division, and presented at the 2025 AEA Summer Mentoring Pipeline Conference"` or `"published work on [topic], contributed to [toolkit/project], and has relevant experience"`

## Pronouns

### HIS_HER
**Default:** `"his"`
**Example:** `"his"` or `"her"` (possessive pronoun)

### HE_SHE
**Default:** `"he"`
**Example:** `"he"` or `"she"` (subject pronoun)

### HIM_HER
**Default:** `"him"`
**Example:** `"him"` or `"her"` (object pronoun)

### OPTIONAL_INSTITUTION_FIT
**Default:** `""` (empty - institution-specific sentence about why Alex fits this institution)
**Used in:** all templates
**Source:** `institution_fit:` field in recipient file (optional)
**Example:** `"Alex's work on household consumption responses to unemployment expectations would complement [THE_INSTITUTION]'s focus on policy-relevant research and administrative data."` or `"Given [THE_INSTITUTION]'s strength in heterogeneous-agent macroeconomics, Alex's computational innovations in solving (s,S) models would be a natural fit."`
**Note:** This should be a single sentence explaining why Alex's research/background fits this specific institution. Add as `institution_fit:` field in the recipient file. Leave empty if no specific fit can be identified.

### OPTIONAL_PERSON_FIT
**Default:** `""` (empty - person-specific sentence about research connection)
**Used in:** all templates
**Source:** `person_fit:` field in recipient file (optional)
**Example:** `"Your research on household finance and durable goods provides an excellent foundation for understanding how Alex's job market paper fits into this broader literature."`
**Note:** This should be a single sentence explaining the research connection between Alex's work and the recipient's research. Only include if there is a strong, specific connection. Add as `person_fit:` field in the recipient file. Leave empty if no specific connection can be identified.

### YOU
**Default:** `"your department"`
**Used in:** base
**Example:** `"your department"` or `"this position"` or `"the Economics Department"` or `"your research group"`

## Notes

- Variables marked as "automatically filled" don't need defaults - the script handles them
- Empty defaults (`""`) mean the variable will be omitted unless filled in
- For variables used in multiple templates, the same default applies to all
- Institution-specific overrides are specified in recipient files (see README for format)
- All defaults are extracted from the recommendation letter content

## Using `NICKNAME` in recipient files

`emails-make.sh` requires **`PERSONAL_NAME:`** and **`FAMILY_NAME:`** on their own lines (see `RECIPIENT-FILE-TEMPLATE.md`). Optional **`NICKNAME:`** overrides the salutation.

```markdown
NICKNAME: Alex
```

The script will:
1. Read `PERSONAL_NAME:` (REQUIRED)
2. Read `NICKNAME:` if present
3. If `NICKNAME:` is set, use it (capitalized) for “Dear …”
4. Otherwise use `PERSONAL_NAME:` (capitalized)

**Examples:**
- `PERSONAL_NAME: Alexander` and `NICKNAME: Alex` → "Dear Alex"
- `PERSONAL_NAME: Russell` and `NICKNAME: Russ` → "Dear Russ"

**Note:** `PERSONAL_NAME`, `FAMILY_NAME`, and `NICKNAME` lines are stripped from the body text inserted into the email.

## Handling generic email addresses

For `search.committee@university.edu`, still set **`PERSONAL_NAME:`** and **`FAMILY_NAME:`** (e.g. "Search" / "Committee"). Use **`NICKNAME:`** for how you want the salutation to read.

**Example:**
```markdown
NICKNAME: Search Committee
```
