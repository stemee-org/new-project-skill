---
name: ship
description: Verify the current task and publish it as a pull request, following CONTRIBUTING.md.
disable-model-invocation: true
---
1. Check the branch: work is on `<name>/<task-id>-<short-desc>`, never on `main`. If changes sit on `main`, move them to a branch first (`git switch -c …`); never push `main`.
2. Run the Test, Lint and Type-check commands from `CLAUDE.md`. If any fail, fix them and rerun; don't continue with failures.
3. Use the `code-reviewer` subagent on the task diff (`git diff main...HEAD`); add `security-auditor` if the task touches input, access or payments. Fix real issues; mention the rest to the user.
4. Show `git status` and a summary of the diff. Make sure no `.env` file, secret or debug leftover is staged, and that the handover, `docs/STATUS.md` and the task row in `docs/PLAN.md` are part of the commits (`/handover` if not).
5. Commit with `<type>: <what>` subjects (small logical commits if the change has distinct parts) and a body that says why, what was chosen and discarded, how it was verified and what is still unverified.
6. Push the branch and open the pull request from `.github/pull_request_template.md`: title in the commit form with the task at the end (`feat: … (T18)`), description written for a reader who was not in the session. Pushing and opening it are asked for unless the user already said to.
7. Check the CI on the pull request. Set the task row in `docs/PLAN.md` to `in review` with the pull request link. Never merge: merging is a separate decision, to be asked.
