# Game Jam Foundation

An approachable, pixel-art Godot 4.7.2 starting point for a weekend game jam.
Every participant starts from this repository, works in their own copy, and can
extend a common home → run → reward → upgrade loop in their own direction.

The starter home is a walkable top-down 2D hub. The player moves through it to
reach NPCs, shops, upgrade points, and the entrance to a run; menus are overlays
opened by those world interactions rather than the home scene itself.

Milestone 5 is ready. It includes the full Ninja Adventure asset pack,
pixel-rendering defaults, a reusable UI theme, Windows/editor/AI onboarding,
the app shell, a configurable meta-progression framework, and a complete
starter home → run → reward → upgrade handoff.

## Before you clone

Install these tools on Windows:

1. [Godot 4.7.2 Standard](https://godotengine.org/download/archive/4.7.2-stable/).
   Download the Windows x86_64 **Standard** build, extract it somewhere stable,
   and start it once. Do not use the .NET build for this GDScript foundation.
2. [Git for Windows](https://git-scm.com/download/win). During setup, allow Git
   to be used from PowerShell.
3. [Git LFS](https://git-lfs.com/). The Ninja Adventure images and audio use
   LFS, so this is required before cloning.
4. [Visual Studio Code](https://code.visualstudio.com/download). The Windows
   User installer is the simplest option and makes the `code` command available
   after reopening PowerShell.
5. [Node.js 22 LTS or newer](https://nodejs.org/). The included local Godot MCP
   bridge uses it; verify the installation in a new PowerShell window with
   `node --version`.

## Clone and run

Open a new PowerShell window and run:

```powershell
git lfs install
git clone https://github.com/cm45/game-jam-base.git
cd game-jam-base
git lfs ls-files
code .
```

Git LFS downloads the asset files as part of cloning. If files under
`assets/ninja_adventure/source/` look like small text pointer files instead of
images or audio, run `git lfs pull` from the repository root and try again.

In the Godot Project Manager, choose **Import**, select this repository's
`project.godot`, and open it. The first import may take a moment. Press **F5**
or use the play button to open the replaceable starter game.

## Configure VS Code for Godot

When VS Code opens this folder, install its workspace recommendations:

- **Godot Tools** (`geequlim.godot-tools`) — required for GDScript language
  support and debugging.
- **Godot Files** (`alfish.godot-files`) — recommended for `.tscn`, `.tres`,
  and shader-file readability.
- **Gemini CLI Companion** — recommended free-first AI companion. Install
  Gemini CLI through the guide below, then let its `/ide install` command add
  this extension.
- **Kilo Code** or **Cline** — optional free-first agents installed from the
  Extensions view; each discovers the workflow files included in this project.
- **Codex** (`openai.chatgpt`) and **GitHub Copilot** (`GitHub.copilot`) —
  optional account-based agents.

You can install the first two from the Extensions view (`Ctrl+Shift+X`) or run:

```powershell
code --install-extension geequlim.godot-tools
code --install-extension alfish.godot-files
```

Tell Godot to open scripts in VS Code:

1. In Godot, open **Editor > Editor Settings > Text Editor > External**.
2. Enable **Use External Editor**.
3. Set **Exec Path** to your `Code.exe`, normally
   `%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe` for the User installer.
4. Set **Exec Flags** to `{project} --goto {file}:{line}:{col}`.
5. Also enable **Text Editor > Behavior > Files > Auto Reload Scripts on
   External Change**, **Interface > Editor > Save on Focus Loss**, and
   **Interface > Editor > Import Resources When Unfocused**.

Keep the Godot editor open while editing. Godot Tools connects to Godot's
language server; once it is open, VS Code supplies navigation, completion, and
F5 debugging through the included `.vscode/launch.json`.

## AI and MCP in the editor

AI is optional. Start with [the AI guide](docs/AI_GUIDE.md), which gives a
complete free-first setup for Gemini CLI in VS Code, Kilo Code, and Cline; it
also covers prompt examples, this repository's agents and skills, and trusted
MCP connections.

This repository includes an enabled, pinned Godot MCP Toolkit add-on and
read-only client entries for it alongside the OpenAI Developer Docs MCP. Open
the project in Godot, then in VS Code run **MCP: List Servers** and start
`godotMcpToolkit`. The first connection downloads the pinned local bridge via
`npx`; no API key or machine-specific path is committed. Follow the
[Godot MCP guide](docs/GODOT_MCP.md) for the first probe, Gemini/Cline/Kilo and
Codex setup, or enabling write tools after review. For Codex in VS Code, install
the **Codex** extension, sign in, then use the Codex icon or run **Codex: Open
Codex Sidebar**.

Project-wide instructions live in [AGENTS.md](AGENTS.md). VS Code additionally
loads [Copilot instructions](.github/copilot-instructions.md), two focused
agents, and reusable skills from `.github/`. Gemini CLI, Kilo Code, and Cline
receive compatibility entries in `.gemini/`, `.agents/`, and `.cline/`.

## What is here now

- `assets/ninja_adventure/source/` contains the complete original asset pack.
  Binary assets use Git LFS; its original license and README remain beside them.
- `ui/theme/game_jam_theme.tres` is the shared wood UI theme built from the
  supplied UI textures and pixel font.
- `app/foundation_hub.tscn` is the runnable startup scene for testing the app
  shell before gameplay systems are added.
- `ui/pause_menu/` supplies pause, settings, keybinds, reset, return-to-hub,
  and quit controls from any scene.
- `features/input/`, `features/audio/`, and `features/save/` contain the
  documented reusable services that later game and demo scenes can use.
- `features/progression/` provides editable currencies and upgrades, persistent
  wallet and level state, calculated effects, a shop, and a visual skill tree.
- `game/starter_home.tscn` and `game/starter_run.tscn` are the minimal,
  replaceable home and run. They demonstrate the `RunContext` / `RunResult`
  contract through the `RunSession` feature.
- `demo/` retains the fuller collect-and-exit example with three residents,
  tents, a Path Shrine, and a six-pickup run. It is optional: open
  `demo/demo_home.tscn` and use **F6** to play it directly.
- `components/` contains optional movement, interaction, and pickup building
  blocks used by the starter scenes and fuller demonstration.
- `addons/godot_mcp_toolkit/` contains the pinned editor add-on that lets a
  local MCP client inspect and, when enabled per developer, edit this project.

## Learn the foundation

- [Setup details](docs/SETUP.md)
- [GDScript starter exercises](docs/GDSCRIPT_BASICS.md)
- [Architecture overview](docs/ARCHITECTURE.md)
- [App shell and core services](docs/APP_SHELL.md)
- [Meta-progression guide](docs/PROGRESSION.md)
- [Playable demo loop](docs/DEMO_LOOP.md)
- [RunContext and RunResult contract](docs/RUN_CONTRACT.md)
- [Extension recipes](docs/EXTENSION_RECIPES.md)
- [AI and MCP guide](docs/AI_GUIDE.md)
- [Optional local Godot MCP setup](docs/GODOT_MCP.md)
- [Incremental roadmap](docs/ROADMAP.md)

## Folder map

| Path | Purpose |
| --- | --- |
| `app/` | Startup and persistent application shell. |
| `assets/` | Original third-party assets and their attribution. |
| `components/` | Optional reusable gameplay building blocks. |
| `demo/` | The complete collect-and-exit example. |
| `features/` | Reusable game services such as saving and progression. |
| `game/` | Minimal scenes and configuration for a participant's own game. |
| `ui/` | Shared theme and UI scenes. |
| `docs/` | Setup, architecture, extension, and AI guides. |

## Asset credit

The [Ninja Adventure Asset Pack](https://pixel-boy.itch.io/ninja-adventure-asset-pack)
was created by Pixel-boy and AAA and is released under CC0. Attribution is not
required, but retained here in appreciation. See [asset notes](docs/ASSETS.md)
and the original `assets/ninja_adventure/source/LICENSE.txt`.
