# Godot MCP integration

This repository includes **Godot MCP Toolkit v1.0.0**. It lets an MCP-capable AI
client inspect the Godot editor that is running on the same computer. The
plugin listens only on localhost; the bridge and editor token stay on the
participant's machine.

The project starts each shared configuration in **read-only mode**. That lets a
new developer inspect scenes, scripts, project settings, and errors before an
AI can change files or editor state.

## What a clone already contains

| Item | Location | Why it is included |
| --- | --- | --- |
| Godot editor add-on | `addons/godot_mcp_toolkit/` | Starts a local MCP endpoint when Godot opens the project. |
| VS Code server entries | `.vscode/mcp.json` | Makes the bridge available to VS Code chat and Copilot. |
| Generic client entry | `.mcp.json` | Supplies the `mcpServers` form for compatible project-aware clients. |
| Gemini CLI entry | `.gemini/settings.json` | Makes the same bridge available from Gemini CLI. |
| Usage and safety notes | This document | Explains the first connection and how to enable writes deliberately. |

The add-on is enabled in `project.godot`. Do not install it again through
AssetLib. The bridge itself is started with the pinned npm package
`@npgamedev/godot-mcp-server@1.0.0`; `npx` downloads it the first time a client
connects. No API key, port, token, or absolute machine path belongs in Git.

## First connection in VS Code

1. Install [Node.js 22 LTS or newer](https://nodejs.org/), then open a **new**
   PowerShell window and run:

   ```powershell
   node --version
   ```

2. Clone the repository, open it in VS Code, and trust the workspace.
3. Import and open `project.godot` in Godot. The first import can take a moment.
   The **MCP** dock should appear in Godot's bottom panel. In the Output panel,
   look for a line saying that the server is listening on `127.0.0.1`.
4. In VS Code, install and sign in to an AI provider, then run **MCP: List
   Servers** from the Command Palette. Start `godotMcpToolkit`.
5. The first start may take longer while `npx` downloads the bridge. Keep Godot
   open, then reconnect the chat client if VS Code reports a startup timeout.
6. Ask a read-only question:

   ```text
   Use only read-only Godot MCP tools. Inspect the current scene tree and
   project settings, then explain which node owns player movement. Do not
   modify, save, or run anything.
   ```

If Godot opens an onboarding dialog, use it to inspect the connection status.
Do **not** ask it to write a replacement `.mcp.json`; this repository already
keeps both its documentation and Godot server entries.

## Gemini CLI, Cline, Kilo, and Codex

- **Gemini CLI:** the checked-in `.gemini/settings.json` is ready. Start
  `gemini` from the repository root and run `/mcp`; keep Godot open while using
  the tools.
- **Cline or Kilo Code:** if the extension does not discover `.mcp.json`, open
  its MCP server configuration and copy the `godot-mcp-toolkit` object from the
  file's `mcpServers` section. Keep its `command`, `args`, and `env` values
  unchanged.
- **Codex CLI:** add the same pinned, read-only server to your user profile:

  ```powershell
  codex mcp add godot-mcp-toolkit --env GODOT_MCP_CONFIG_VERSION=1 --env GODOT_MCP_READ_ONLY=1 -- cmd /c npx -y @npgamedev/godot-mcp-server@1.0.0
  codex mcp list
  ```

On Windows, `npx` is a `.cmd` shim. The `cmd /c` wrapper in every configuration
is required for reliable client startup.

## Enable write tools after the first probe

The `GODOT_MCP_READ_ONLY` environment variable hides mutating tools at the
server. It is stronger than asking an AI to avoid edits.

After a successful read-only probe, choose one client configuration you use and
change its value from `"1"` to `"0"` (or remove that environment entry):

| Client | Configuration to change |
| --- | --- |
| VS Code chat / Copilot | `.vscode/mcp.json` |
| Gemini CLI | `.gemini/settings.json` |
| Cline or Kilo Code | Its local MCP server entry |
| Codex CLI | Remove and re-add the server without `--env GODOT_MCP_READ_ONLY=1` |

Restart or reconnect that MCP client after changing the setting. Then ask for
one small, reviewable change, inspect the Godot scene diff and `git diff`, and
run the affected scene before keeping it. Do not let an AI edit a script that
has unsaved changes in Godot's built-in editor.

## Troubleshooting

- **No MCP dock or listener:** confirm Godot 4.7.2 opened this repository and
  that `Project > Project Settings > Plugins` lists **Godot MCP Toolkit** as
  active. Do not edit the plugin path manually.
- **The client cannot connect:** confirm Node 22+, keep both the editor and the
  AI client on native Windows, and restart the client after Godot is open.
- **First `npx` run times out:** run the same command from PowerShell once to
  complete the package download, then reconnect the client:

  ```powershell
  npx -y @npgamedev/godot-mcp-server@1.0.0
  ```

  Press `Ctrl+C` after it starts; Godot must be open for the bridge to connect.
- **A configuration was replaced:** restore the tracked file with Git, then
  keep the repository's documentation and Godot entries together. Do not paste
  personal tokens or absolute paths into a shared configuration.

## Version and attribution

The repository vendors the MIT-licensed Godot MCP Toolkit release `v1.0.0`,
source commit `06761dfe4241714e82cc4830777927bd084f1a99` (released 27 July
2026). Its license and attribution material are retained beside the code in
`addons/godot_mcp_toolkit/LICENSE` and `addons/godot_mcp_toolkit/ATTRIBUTIONS.md`.
The matching npm bridge is pinned to `@npgamedev/godot-mcp-server@1.0.0`.

For toolkit updates, review the upstream release, update both pins together,
run the Godot checks, and record the new source revision here. See the
[Godot MCP Toolkit](https://github.com/NPGameDev/godot-mcp-toolkit), its
[client setup reference](https://github.com/NPGameDev/godot-mcp-server/blob/main/docs/mcp-clients.md),
and [troubleshooting guide](https://github.com/NPGameDev/godot-mcp-toolkit/blob/main/docs/troubleshooting.md).
