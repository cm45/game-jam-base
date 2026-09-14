# Tests

Framework tests live here so validation remains separate from examples and
gameplay scenes.

`demo_loop_smoke.gd` is the focused milestone 4 check. It instantiates the run,
collects every pickup, completes it through the real exit signal, and verifies
the Lucky Satchel reward multiplier and reward summary in an isolated test save.
The run's home route is loaded separately by the scene-startup check because
changing scenes ends a test scene's lifetime.

Run it from the repository root with:

```powershell
& "D:\Path\To\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --scene res://tests/demo_loop_smoke.tscn
```

`progression_layout_smoke.tscn` verifies the 1280×720 UI canvas, six-card shop
capacity, and full skill-tree canvas. `progression_mechanics_smoke.tscn`
verifies that Gold shop ownership and Insight skill ownership stay separate,
including a prerequisite unlock.

`run_contract_smoke.tscn` starts a context, completes a result, and verifies
that only a completed result grants permanent currency in an isolated test save.

`demo_removal_smoke.ps1` copies a demo-free project into a unique system-temp
folder, excludes `.git`, `.godot`, `demo`, and `tests`, then starts the editor
and main scene from that copy. Run it with the same Godot console executable:

```powershell
.\tests\demo_removal_smoke.ps1 -GodotPath "D:\Path\To\Godot_v4.7.2-stable_win64_console.exe"
```

`save_reset_smoke.tscn` verifies that settings and progression both persist to
disk, migrates legacy upgrade storage, and confirms reset clears both sections
in an isolated test save.

`fresh_clone_smoke.ps1` clones a selected branch into a unique system-temp
folder, verifies Git LFS, lets Godot complete its first asset import, then
validates a clean editor launch and main scene before removing the clone.
`release_validation.ps1` runs every smoke test, the
demo-removal and fresh-clone checks, and a temporary Windows release export.
See [`docs/RELEASE.md`](../docs/RELEASE.md) for commands and export-template
setup.

`camp_runtime_smoke.tscn` uses isolated saves to exercise actual volume
sliders, every sample upgrade, pickup reach, reward amounts, and local world
freeze across pause/resume. Layout checks verify Fit hides both scrollbars
and contains all skill nodes, and pause draws above station windows.
