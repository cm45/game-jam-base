---
applyTo: "**/*.gd"
---

# GDScript conventions

- Target Godot 4.7.2 and use tabs with a width of four spaces in the editor.
- Give public functions, exported values, signals, and nodes names that explain
  their game purpose. Use snake_case for members and PascalCase for classes.
- Add type annotations when they make data flow clearer. Avoid types only when
  Godot's dynamic value is intentional.
- Keep gameplay-specific logic out of autoloads. Communicate between features
  through a small, documented interface or signal.
- Use @onready only for nodes that must exist in the owning scene. Fail with a
  clear error message when a required node or resource is missing.
