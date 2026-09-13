# Tests

Framework tests live here so validation remains separate from examples and
gameplay scenes.

`demo_loop_smoke.gd` is the focused milestone 4 check. It instantiates the run,
collects every pickup, completes it through the real exit signal, verifies the
Lucky Satchel reward multiplier and the reward summary, then restores the local
`user://` save. The run's home route is loaded separately by the scene-startup
check because changing scenes ends a test scene's lifetime.

Run it from the repository root with:

```powershell
& "D:\Path\To\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --scene res://tests/demo_loop_smoke.tscn
```

`progression_layout_smoke.tscn` verifies the Shop stays a two-column compact
grid with space for six cards and that every catalog node fits inside the
compact SkillTree canvas.

`run_contract_smoke.tscn` starts a context, completes a result, verifies that
only a completed result grants permanent currency, then restores the local save.

`demo_removal_smoke.ps1` copies a demo-free project into a unique system-temp
folder, excludes `.git`, `.godot`, `demo`, and `tests`, then starts the editor
and main scene from that copy. Run it with the same Godot console executable:

```powershell
.\tests\demo_removal_smoke.ps1 -GodotPath "D:\Path\To\Godot_v4.7.2-stable_win64_console.exe"
```
