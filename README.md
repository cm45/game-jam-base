# Game Jam Foundation

Game Jam Foundation is a beginner-friendly Godot 4.7.2 starting point for a
weekend game jam, including developers with zero programming or game-development
experience. It includes the full Ninja Adventure asset pack and a small,
playable pixel-art loop: explore a home area, start a run, collect rewards, and
buy upgrades. Teams can replace the example game while keeping the reusable
save, audio, input, progression, UI, and scene-flow systems.

This guide assumes Windows and explains every required step. Experienced
developers can use the headings as a checklist; first-time developers can
follow the steps in order.

## Initial setup

### 1. Create a GitHub account

Create a free [GitHub account](https://github.com/signup) if you do not have
one. GitHub hosts the project, your personal copy, and pull requests.

### 2. Install the prerequisites

Install these tools before downloading the project:

1. [Godot 4.7.2 Standard](https://godotengine.org/download/archive/4.7.2-stable/)
   - Download the Windows x86_64 **Standard** build, not the .NET build.
   - Extract it to a permanent folder and open Godot once.
2. [Git for Windows](https://git-scm.com/download/win)
   - The default installer choices are suitable.
   - Allow Git to be used from the command line when the installer asks.
3. [Git LFS](https://git-lfs.com/)
   - LFS downloads the project's large images and audio correctly.
4. [Visual Studio Code](https://code.visualstudio.com/download)
   - The Windows User Installer is the simplest choice.
   - Reopen your terminal after installation so the `code` command is available.
5. [Node.js 22 LTS or newer](https://nodejs.org/)
   - Node runs the included local Godot MCP bridge used by AI tools.

Open a **new terminal window** and check the installations:

```shell
git --version
git lfs version
code --version
node --version
```

If the terminal says a command is unknown, restart the terminal first. If it is
still unknown, reinstall that tool and keep its option to add the command to
`PATH` enabled.

Tell Git which name to record on your commits. Run these once, replacing the
example values with your name and the email used by your GitHub account:

```powershell
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

GitHub also offers a private `noreply` email in **GitHub > Settings > Emails**
if you do not want your normal email stored in public commits.

### 3. Fork and clone the repository

A **fork** is your own GitHub copy of this repository. You can change your fork
freely while still receiving improvements from this original project.

1. Open <https://github.com/cm45/game-jam-base> and select **Fork**.
2. Keep the suggested repository name and create the fork.
3. On your fork, select **Code > HTTPS** and copy its URL.
4. Open a terminal. Use `cd` followed by a folder path to choose where the
   project will be stored, for example `cd C:\Users\YOUR_WINDOWS_NAME\Documents`.
5. Run the following commands. Replace `YOUR_GITHUB_NAME` with your GitHub
   username.

```shell
git lfs install
git clone https://github.com/YOUR_GITHUB_NAME/game-jam-base.git
cd game-jam-base
git lfs pull
code .
```

`git clone` creates a local working copy. `git lfs pull` makes sure the real
asset files are present instead of small text placeholders.

For a game jam, start with a fork even when you are working alone: it gives your
game its own home and keeps a clean path for receiving later foundation updates.
Only use a direct clone when you want a temporary, read-only copy and will
never keep or publish changes.

The first time you later push a branch, Git may open a browser and ask you to
sign in to GitHub. Complete that prompt; do not put a GitHub password into a
terminal command.

### 4. Add the original repository as `upstream`

Git calls online repositories **remotes**. By convention, `origin` is your
fork and `upstream` is the original project. Adding `upstream` lets you merge
future foundation improvements into your game without replacing your work.

Run these commands from the cloned `game-jam-base` folder:

```shell
git remote add upstream https://github.com/cm45/game-jam-base.git
git remote -v
```

You should see both `origin` and `upstream`. This is a one-time setup. See the
[development workflow](docs/DEVELOPMENT_WORKFLOW.md) for syncing safely,
working on branches, and opening pull requests.

### 5. Configure VS Code

When VS Code opens the folder, select **Install** in the recommended extensions
notification. If it does not appear, open **Extensions** with `Ctrl+Shift+X`,
type `@recommended`, and install the workspace recommendations.

Recommended extensions:

| Extension | Why it is included |
| --- | --- |
| **Godot Tools** (`geequlim.godot-tools`) | GDScript completion, navigation, errors, and debugging. Required. |
| **Godot Files** (`alfish.godot-files`) | Easier-to-read Godot scene, resource, and shader files. |
| **GitHub Pull Requests and Issues** (`GitHub.vscode-pull-request-github`) | Create, review, and check pull requests without leaving VS Code. |
| **Error Lens** (`usernamehw.errorlens`) | Shows errors and warnings directly beside the relevant line. |
| **Antigravity** (`Google.google-antigravity`) | Optional agentic VS Code extension for plans, supervised edits, MCP, and verification. |
| **Codex** (`openai.chatgpt`) | Optional AI agent for eligible ChatGPT accounts. |
| **GitHub Copilot** (`GitHub.copilot`) | Optional inline assistance and repository-aware chat. |

You can also install the core recommendations from a terminal:

```shell
code --install-extension geequlim.godot-tools
code --install-extension alfish.godot-files
code --install-extension GitHub.vscode-pull-request-github
code --install-extension usernamehw.errorlens
code --install-extension Google.google-antigravity
```

The repository includes shared launch, extension, and MCP configuration in
`.vscode/`. Your personal `.vscode/settings.json` is intentionally ignored by
Git because it can contain a path specific to your computer.

### 6. Open and configure the Godot project

You do not need to start in Godot's Project Manager. Open the repository in VS
Code first. Godot Tools will connect to an already open editor; if it cannot
find one, use its prompt to open this repository's `project.godot` in Godot.

If that prompt does not appear, open Godot's **Project Manager**, select
**Import**, choose `project.godot`, and wait for the first asset import to
finish. Keep Godot open while working with GDScript or Godot MCP.

Tell Godot to open scripts in VS Code:

1. Open **Editor > Editor Settings > Text Editor > External**.
2. Enable **Use External Editor**.
3. Set **Exec Path** to `code.cmd`. For the normal VS Code User installation,
   it is usually under
   `%LOCALAPPDATA%\Programs\Microsoft VS Code\bin\code.cmd`. Use the file
   picker to select the real file; do not type `%LOCALAPPDATA%` literally.
4. Set **Exec Flags** to `{project} --goto {file}:{line}:{col}`.
5. Enable **Text Editor > Behavior > Files > Auto Reload Scripts on External
   Change**.
6. Enable **Interface > Editor > Save on Focus Loss** and **Interface > Editor
   > Import Resources When Unfocused**.

Keep Godot open while editing GDScript so Godot Tools can connect to its
language server. Open `game/home.tscn` to edit the camp or
`game/gameplay.tscn` to edit the run; the [game editing guide](game/README.md)
explains the beginner-friendly entry points.

### 7. Set up AI integration (optional)

AI tools are optional; the project runs without them. The recommended
agent-first workflow is **Google Antigravity**. Install the official VS Code
extension, open its Agent panel, and sign in with a personal Google account.
Antigravity can use this repository's `.agents/skills/` workflows and local MCP
configuration.

The repository also supports Kilo Code, Cline, GitHub Copilot, and Codex. Read
the [AI guide](docs/AI_GUIDE.md) before choosing a provider; it explains safe
prompts, MCP, and how to review AI changes.

Read the [AI guide](docs/AI_GUIDE.md) before choosing a provider. It explains
free options, repository instructions, safe prompts, and how to review AI
changes. Never commit an API key or paste a secret into an AI prompt.

### 8. Start the MCP connections (optional)

MCP lets a compatible AI inspect documentation and the locally running Godot
editor. The repository already contains the server configurations and the
Godot add-on; do not reinstall the add-on or generate replacement config files.

For VS Code:

1. Keep this Godot project open. Confirm that an **MCP** dock appears in
   Godot's bottom panel.
2. In VS Code, open the Command Palette with `Ctrl+Shift+P`.
3. Run **MCP: List Servers**.
4. Start `openaiDeveloperDocs` and `godotMcpToolkit`.
5. Allow extra time on the first start while `npx` downloads the pinned local
   bridge.
6. Ask the AI to use only read-only tools for its first inspection.

Antigravity users can load `.agents/mcp_config.json` from the repository's MCP
settings. Cline, Kilo, and Codex need a small client-specific step described in the
[Godot MCP guide](docs/GODOT_MCP.md), which also contains troubleshooting and
the option to disable MCP write tools.

## Every time you return to the project

After the one-time setup, use this short checklist:

1. Open a terminal in the project folder.
2. Fetch foundation updates with `git fetch upstream`.
3. If you want those updates, merge them using the safe steps in the
   [development workflow](docs/DEVELOPMENT_WORKFLOW.md).
4. Open the folder with `code .`.
5. Open the project in Godot and wait for any imports to finish.
6. Create or switch to a feature branch before editing.
7. Press **F5** once before working to confirm the project still runs.
8. If using Godot MCP, keep Godot open and reconnect the server in your AI
   client.
9. Before stopping, review `git status`, run the changed scene, and commit work
   you want to keep.

## Learn and extend the foundation

- [Development workflow: upstream, branches, and pull requests](docs/DEVELOPMENT_WORKFLOW.md)
- [Setup details and project defaults](docs/SETUP.md)
- [GDScript starter exercises](docs/GDSCRIPT_BASICS.md)
- [Architecture overview](docs/ARCHITECTURE.md)
- [App shell and core services](docs/APP_SHELL.md)
- [Meta-progression guide](docs/PROGRESSION.md)
- [Edit the maps and gameplay](game/README.md)
- [RunContext and RunResult contract](docs/RUN_CONTRACT.md)
- [Replace the example with your game](docs/REPLACE_STARTER.md)
- [Extension recipes](docs/EXTENSION_RECIPES.md)
- [AI and MCP guide](docs/AI_GUIDE.md)
- [Godot MCP setup and troubleshooting](docs/GODOT_MCP.md)
- [Release readiness and weekend checklist](docs/RELEASE.md)
- [Incremental roadmap](docs/ROADMAP.md)

## Folder map

| Path | Purpose |
| --- | --- |
| `app/` | Startup and persistent application flow. |
| `assets/` | Third-party and project-specific art and audio. |
| `components/` | Optional reusable gameplay building blocks. |
| `features/` | Reusable services such as saving and progression. |
| `game/` | The participant's maps, gameplay, and game configuration. |
| `ui/` | Shared theme and interface scenes. |
| `tests/` | Automated validation and smoke tests. |
| `docs/` | Architecture, extension, AI, and release guides. |

## Asset credit

The [Ninja Adventure Asset Pack](https://pixel-boy.itch.io/ninja-adventure-asset-pack)
was created by Pixel-boy and AAA and is released under CC0. Attribution is not
required, but is retained here in appreciation. See the
[asset notes](docs/ASSETS.md) and the original
`assets/ninja_adventure/source/LICENSE.txt`.

## License and reuse

The project code is available under the [MIT License](LICENSE). You may use,
modify, distribute, and sell it, including as part of a commercial game. The
Ninja Adventure asset pack is CC0 and retains its original attribution and
license files; see [asset notes](docs/ASSETS.md). Other vendored dependencies
keep their own notices and licenses.
