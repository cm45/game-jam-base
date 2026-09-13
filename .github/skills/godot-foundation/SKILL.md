---
name: godot-foundation
description: Extend the Game Jam Foundation in a small, teachable, runnable way. Use for Godot features, scenes, UI, or framework documentation in this repository.
---

# Godot Foundation workflow

Read AGENTS.md, the root README, the roadmap, and the closest feature README
before changing a foundation system. Work only in the milestone the project
owner has approved.

1. Identify the owning folder: app, features, components, ui, game, or demo.
2. Keep the initial change small enough to run without later milestone code.
3. Use the shared theme and pixel-art defaults for new interface work.
4. Keep the Ninja Adventure source pack unchanged and add new art outside its
   source directory.
5. Explain public extension points in a nearby README or docs file.
6. Run the smallest meaningful Godot check and report its outcome.

Prefer a clear signal or small public method when features communicate. Do not
create empty manager scripts, autoloads, or speculative abstractions.
