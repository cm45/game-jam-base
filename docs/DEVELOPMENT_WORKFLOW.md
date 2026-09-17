# Development workflow

This guide explains how to receive foundation updates, keep work reviewable,
and contribute changes through pull requests. Complete the one-time setup in
the root [README](../README.md) first.

The intended protection for `main` is **Require a pull request before
merging**, with force pushes and branch deletion disabled. GitHub's separate
**Lock branch** option makes a branch fully read-only and prevents commits,
which would also prevent pull-request merges. The pull-request rule therefore
provides the useful meaning of read-only here: no direct updates to `main`,
while reviewed pull requests can still merge.

GitHub currently reports that this private, personal repository's protection
rules will not be enforced on its plan. Enforcement requires a public
repository on GitHub Free or a supported paid/organization plan. Do not assume
that a rule shown in Settings is active; verify the plan and the rule status
after changing repository ownership or visibility.

## Understand the three copies

| Name | Meaning |
| --- | --- |
| Local repository | The files on your computer. |
| `origin` | Your fork on GitHub. You normally push branches here. |
| `upstream` | The original `cm45/game-jam-base` repository. You fetch foundation updates from here. |

Check the configuration at any time:

```powershell
git remote -v
```

If `upstream` is missing, add it once:

```powershell
git remote add upstream https://github.com/cm45/game-jam-base.git
```

## Start a work session

First, make sure your current work is committed or intentionally left on its
own branch. Then update your local `main`:

```powershell
git switch main
git fetch upstream
git merge upstream/main
git push origin main
```

`fetch` downloads information without changing your files. `merge` applies the
downloaded foundation changes to the current branch. If Git reports a conflict,
stop and ask an experienced teammate before choosing which lines to keep.

Create a branch for one focused change:

```powershell
git switch -c feature/short-description
```

Use a clear name such as `feature/player-dash` or `docs/better-setup`. Do not
work directly on `main`; the upstream repository requires pull requests for
changes to that branch.

## Save and share work

Inspect what changed:

```powershell
git status
git diff
```

After running the affected scene, stage and commit the files you intend to
keep:

```powershell
git add path/to/changed_file.gd
git commit -m "feat: add player dash"
git push -u origin feature/short-description
```

On GitHub, open your fork and select **Compare & pull request**. Use
`cm45/game-jam-base` and `main` as the base repository and branch when
contributing to the foundation. Explain what changed, how you tested it, and
anything a reviewer should try.

If the change belongs only to your game, merge it into your fork instead of
opening a pull request against the foundation.

## Bring later upstream changes into a game branch

Update local `main` first using the earlier commands. Then switch back to the
game branch and merge:

```powershell
git switch feature/short-description
git merge main
```

Run the game again after the merge. Foundation updates can be combined with a
forked game, but Git cannot decide how two people intended conflicting edits
to behave.

## Before ending a work session

1. Run the changed scene and check the Godot Output panel for errors.
2. Run `git status` and make sure generated `.godot/` or `*.import` files are
   not included.
3. Review `git diff` or the VS Code Source Control view.
4. Commit useful work to the feature branch.
5. Push the branch to `origin` if teammates need it or you want an online
   backup.

For project-wide release checks, follow [RELEASE.md](RELEASE.md).
