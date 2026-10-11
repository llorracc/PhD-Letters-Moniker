## Material shared between CDC and [Moniker]

This is a repository for coordinating letters of recommendation between you and CDC. You are requested to leave the repository in better condition than you found it by making PR's to the upstream for anything which you think would improve the instructions and structure.

There is a tension here: you will likely only find such things as you go about filling in your personal information. But you do not want to push your personal information into the template.

As a result, here is the suggested workflow. Please read the directions all the way through before beginning.

1. Fork the repo and clone to your machine.

2. Create and switch to a branch called `personal-draft`.

3. In `personal-draft`, fill in the materials with your information:

    a. Review content in `Letter.tex`. Replace {Mr} and {Spock} in `Letter.tex` with your personal and family names. Review the introductory sentence.

    b. Update `Subfiles/Intro.tex` to describe your work, fit for the position, etc.

    c. Update `Subfiles/JMP.tex` to describe your JMP and a few other relevant projects. 
    
    d. Update `Subfiles/Conclusion.tex` to summarize the argument.

    e. You do **not** need to adjust `EmailAddress-To-Which-Letter-Will-Be-Sent.txt`, `Name-Of-Program.tex`, or other similar `Name-Of` files; these are destination-specific inputs that CDC will use to generate the letters.

4. *Commit locally only*. Do not push the branch. Your fork is public, because the original template repo is public, and you may not want all of the information you have filled in to be public.

    `git status --short --branch`

    `git add Letter.tex Subfiles/Intro.tex Subfiles/JMP.tex Subfiles/Conclusion.tex` (and any other edited files)

    `git diff --cached`

    `git commit -m "Draft personal letter materials"`

5. If you have found improvements you would like to contribute, proceed with 5-7. Switch to `main` and create a branch called `template-suggestions`:

    `git switch main`

    `git switch -c template-suggestions`

    Add to this any general fixes you discovered while drafting which would improve the instructions, structure, and general efficiency of the workflow in the future. Do not merge in `personal-draft`. Commit them locally:

    `git add README.md` (and any other changed files)

    `git diff --cached`

    `git commit -m "Improve template instructions"`

6. Ensure that no personal information has been added:

    `git log -p main..template-suggestions`

    Then push `template-suggestions` only (e.g. **not** `personal-draft`):

    `git push -u origin template-suggestions`

7. Open a PR to the original repository. Wait for CDC to merge the PR before proceeding to step 8.

8. Use `Sync Fork` on GitHub to update `main`. Then update the local clone by running:

    `git switch main`

    `git pull --ff-only origin main`
    
    <!-- *Optional cleanup if PR was opened*: after confirming the PR is merged and main is updated, delete `template-suggestions` locally and on GitHub. Consult GitHub guidance or AI; the specific deletion commands will depend on if CDC does a squash merge. -->

9. Bring updated `main` into the `personal-draft` branch:

    `git switch personal-draft`

    `git merge main`

    If Git reports a conflict, resolve it before continuing.

10. Detach your fork, change visibility to private, and rename it by switching {Moniker} to your family name. Confirm that GitHub displays **Private** before proceeding.

11. In your local clone, update `origin` to the renamed repository. Then merge `personal-draft` into `main` and push `main`:

    `git remote set-url origin https://github.com/YOUR-USERNAME/PhD-Letters-NAME.git`

    `git switch main`

    `git merge personal-draft`

    `git push origin main`

12. You should now have a private repo with everything necessary to generate the letters. Add CDC as a collaborator.