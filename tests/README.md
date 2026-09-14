# Validation

From the repository root:

```powershell
.\tests\release_validation.ps1 -GodotPath "D:\Path\To\godot.exe"
```

The suite imports the editor, starts home, then checks:

- camp_runtime: real volume slider wiring, upgrades, pickup reach, rewards,
  and gameplay freezing behind the completion popup.
- progression_layout: six shop cards, separate station windows, compact
  tooltips, pause layering, and full-tree Fit.
- progression_mechanics: independent shop purchases and prerequisite skills.
- save_reset: persistence, legacy ownership migration, and reset.
- run_contract: completed results grant rewards exactly once.
- project_copy: starts a copy without editor cache or tests.
- fresh_clone: clones committed source and verifies Git LFS/import/startup.
- Windows export and startup.

Save tests use isolated files. Each scene prints PASS or reports an error;
the suite imposes timeouts. Use -SkipFreshClone/-SkipExport while iterating.
The old six-shard demo test is replaced by the actual gameplay checks.
See [release instructions](../docs/RELEASE.md) for setup and manual verification.
