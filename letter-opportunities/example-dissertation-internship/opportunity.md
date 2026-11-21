---
id: example-dissertation-internship
kind: internship
student_github: your-github-id
employer: Federal Reserve Bank of Example
role_title: PhD Dissertation Intern
term: Summer 2027
location: Example City
posting_url: https://example.org/careers/phd-dissertation-intern
portal: workday
requisition_id: ""
deadline_application: ""
deadline_letters: ""
letter_delivery: portal
status: tracking
related_recipient_files:
  - email-templates/recipients/internship-dissertation/contact@examplefed.org.md
letter_sent_date: ""
---

## Why this role

Summarize in your own words why the program fits your research (dissertation topic, methods, policy relevance). Your advisor can use this when tailoring the letter or email.

## Letter / portal checklist

- [ ] Does the application ask for a **generic** letter or **program-specific** wording (e.g. "PhD Dissertation Intern," summer dates)?
- [ ] Any **word limits** or upload format (PDF only, etc.)?
- [ ] **Visa / citizenship:** if the portal collects this, set `\OmitBackgroundVisaParagraph` to `yes` in `student-macros.ltx` so the letter does not repeat it.
- [ ] **Teaching:** dissertation internships need no teaching section. Say so here; your advisor's build for this destination uses a `Letter-sections.tex` without it.
- [ ] Outreach email needed? Generate previews from `email-templates/` (see `email-templates/README.md`).

## Primary contact (email outreach)

See `related_recipient_files` above. The recipient file's name must match the email address exactly.
