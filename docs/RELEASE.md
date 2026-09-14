# Release readiness

Use this guide when the foundation branch is ready to become the shared jam
starting point. It covers reproducible checks; it does not replace a short
player-facing pass through the menu and starter loop.

## One-time Windows export setup

`export_presets.cfg` provides a tracked **Windows Desktop** preset for 64-bit
Windows. Output files belong under `exports/`, which Git ignores.

Godot needs matching export templates before it can build a game. In Godot
4.7.2, open **Editor > Manage Export Templates**, select the **Windows x86_64**
entries, and download the debug, release, and console-wrapper templates. The
manager downloads only the chosen platform files, so a Windows-only jam does
not need the full multi-platform template archive.

The export templates must match Godot `4.7.2.stable`. Keep the main editor
executable and its console executable in the same extracted Godot folder. The
console executable is useful for interactive logs, while the scripts below
explicitly wait for either executable on Windows.

## Run the automated suite

From the repository root, run:

```powershell
.\tests\release_validation.ps1 -GodotPath "D:\Path\To\Godot_v4.7.2-stable_win64_console.exe"
```

The command checks these runnable concerns in order:

- editor import and the configured main scene;
- the desktop-sized shop and skill-tree layout plus separate shop/skill rules;
- settings/progression persistence and the shared save reset;
- the reusable `RunContext` / `RunResult` transaction;
- the full optional demo loop and the demo-free starter project;
- a fresh local clone of the current branch, including Git LFS assets; and
- a release Windows x86_64 export, followed by a three-frame headless launch.

Use `-SkipFreshClone` or `-SkipExport` only while iterating. Run the complete
command with neither switch before sharing a jam build.

The suite creates temporary copies under the system temp folder and a temporary
`build/release-readiness` output. It removes both after the checks. Save-related
smoke scenes use isolated `user://game_jam_foundation_test_*.cfg` files and do
not overwrite a developer's normal save.

## Verify the shared remote after promotion

The local fresh-clone check proves the committed branch is self-contained. Once
that branch has been merged into `main` and pushed, prove the actual remote is
what participants will receive:

```powershell
.\tests\fresh_clone_smoke.ps1 `
  -GodotPath "D:\Path\To\Godot_v4.7.2-stable_win64_console.exe" `
  -Repository "https://github.com/cm45/game-jam-base.git" `
  -Branch main
```

That command uses `git clone --no-local`, runs `git lfs pull` and `git lfs
fsck`, imports the untouched clone in Godot, and starts its main scene. A
failure leaves no temporary clone behind.

## Manual release pass

Headless checks cannot judge player movement, menu focus, visual scale, or
sound. Before the weekend, run this route in the editor:

1. Press **F5**, visit the Scout in camp, start a run, collect its three tokens,
   and claim the result at home.
2. Press Escape in the home and run. Check pause, resume, controls, settings,
   reset, return to hub, and quit.
3. Change every volume slider, restart the project, then reset settings and
   progression. Confirm the values persist first and then return to defaults.
4. Press **F6** from `demo/demo_home.tscn`, complete its six-shard loop, and
   buy an upgrade. Confirm it changes the next run as described in
   [the demo guide](DEMO_LOOP.md).
5. In the Export menu, select **Windows Desktop** and make one release build.
   Launch the generated `.exe` normally at least once to inspect window size,
   pixel art, menu layout, and audio on the intended display.

## Weekend checklist

### Organizer, before Friday

- [ ] Merge the approved `framework/` foundation branch into `main` and push it.
- [ ] Run the remote fresh-clone check above against `main`.
- [ ] Publish the exact clone command from the root README.
- [ ] Confirm all four participants have Godot 4.7.2 Standard, Git, Git LFS,
  VS Code, and Node 22+ if they want the optional Godot MCP bridge.
- [ ] Agree on the jam’s submission location, deadline, project owner, and
  whether each person works in a private copy or a personal branch.
- [ ] Keep `assets/ninja_adventure/source/` untouched; it is the vendored CC0
  pack and its binary files must stay in Git LFS.

### Each participant, at the start

- [ ] Run `git lfs install`, clone the shared `main` branch, and confirm
  `git lfs ls-files` lists the Ninja Adventure assets.
- [ ] Open `project.godot`, wait for the first import, and press **F5**.
- [ ] Read [the setup guide](SETUP.md), [the architecture](ARCHITECTURE.md),
  [the run contract](RUN_CONTRACT.md), and [the replacement guide](REPLACE_STARTER.md)
  before replacing starter scenes or removing the demo.
- [ ] Make a small first commit before changing the starter game.
- [ ] If using AI, open [the AI guide](AI_GUIDE.md) and keep code and scene
  changes small enough to review and run.

### Submission handoff

- [ ] Run `release_validation.ps1` without skips.
- [ ] Play the manual release route and launch the final exported `.exe`.
- [ ] Include the required jam page text, controls, credits, and asset credit.
- [ ] Archive the final source commit and exported Windows build separately.
