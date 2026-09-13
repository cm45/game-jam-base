# Optional Godot MCP setup

This guide connects an AI agent to a **locally running Godot editor**. That is
different from the repository's OpenAI Developer Docs MCP server: a Godot MCP
server can inspect scenes, start playtests, and, once permitted, edit scripts
and nodes.

The recommended free-first option is the community-maintained [Godot MCP
Toolkit](https://github.com/NPGameDev/godot-mcp-toolkit). It supports Godot
4.2 through 4.7, runs locally, and uses the open-source
`@npgamedev/godot-mcp-server` bridge. It is not an official Godot product.

## Before installing

- Keep Godot, Node.js, and your AI client on native Windows. Do not mix a WSL
  client with a Windows Godot editor; each sees a different `127.0.0.1`.
- Install [Node.js 22 LTS or newer](https://nodejs.org/) and verify it in a new
  PowerShell window:

  ```powershell
  node --version
  ```

- This foundation intentionally does **not** include a Godot MCP add-on. The
  add-on is third-party code and enabling it adds files under `addons/` and an
  editor-plugin entry to `project.godot`. Try it in your own clone, inspect the
  resulting Git diff, and do not commit it unless the whole team agrees to use
  that exact version.
- Do not use **Project > Tools > MCP Toolkit > Write .mcp.json** in this
  repository. `.mcp.json` is already tracked for the documentation MCP server;
  use a user-level client configuration instead.

## Install the editor add-on

1. Open this project in the Godot editor.
2. Open the **AssetLib** tab, search for **Godot MCP Toolkit**, then choose
   **Download** and **Install**. The AssetLib listing links to its source and
   MIT license.
3. Open **Project > Project Settings > Plugins** and enable **Godot MCP
   Toolkit**.
4. Confirm that an **MCP** dock appears along Godot's bottom panel and that the
   Output log reports it is listening on `127.0.0.1`.
5. In Source Control, inspect `addons/` and `project.godot`. Leave those local
   changes uncommitted for an individual trial.

The MCP server discovers the editor from its local registry. Do not configure
or pin ports unless a later troubleshooting step requires it.

## Connect VS Code safely

In VS Code, open the Command Palette and run **MCP: Open User Configuration**.
Add this entry under its top-level `servers` object. Replace the project path
with the absolute path to your own clone. The `cmd /c` wrapper is the reliable
way to launch `npx` from MCP clients on Windows.

```json
{
  "servers": {
    "godot-mcp-toolkit": {
      "type": "stdio",
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@npgamedev/godot-mcp-server"],
      "env": {
        "GODOT_MCP_PROJECT_PATH": "C:/path/to/your/game-jam-base",
        "GODOT_MCP_READ_ONLY": "1"
      }
    }
  }
}
```

Keep `GODOT_MCP_READ_ONLY` set to `1` at first. It removes write-capable tools
from the server, rather than merely asking the AI to behave. Save the user
configuration, restart or reconnect the VS Code chat client, then run
**MCP: List Servers**. The Godot editor must stay open with the add-on active.

## Connect the other recommended agents

Use the agent's **user-level** MCP configuration, never the tracked project
files, and use the same command and environment values shown above.

| Agent | User-level setup |
| --- | --- |
| Gemini CLI | Add a `godot-mcp-toolkit` entry to `~/.gemini/settings.json`, or use its MCP command from the project root. Run `/mcp` to verify it. |
| Cline | Open the MCP Servers view in the Cline panel, choose **Configure MCP Servers**, and add the `mcpServers` form of the entry. Reconnect from the same panel. |
| Kilo Code | Use its MCP/server settings, create a local stdio server with the command and arguments above, and set the two environment variables. |
| Codex CLI | From the project root, run `codex mcp add godot-mcp-toolkit -- cmd /c npx -y @npgamedev/godot-mcp-server`, then verify with `codex mcp list`. Install the bridge globally if a first-time `npx` download exceeds the client's startup timeout. |

The configuration shape differs by client: VS Code uses `servers`; Gemini,
Cline, and many other clients use `mcpServers`. Use the toolkit's [client setup
reference](https://github.com/NPGameDev/godot-mcp-server/blob/main/docs/mcp-clients.md)
when an agent's UI has changed.

## First use

Start with a read-only request, such as:

```text
Use only read-only Godot MCP tools. Inspect the current scene tree and project
settings, then explain which node owns player movement. Do not modify, save,
or run anything.
```

After reviewing that result, change `GODOT_MCP_READ_ONLY` to `0` or remove it,
reconnect the client, and make one small, reviewable request. Check the Godot
scene diff and Git diff before keeping it. The toolkit's editor operations use
Godot's undo history, but Git remains the project checkpoint.

## Troubleshooting and removal

If no tools connect, verify Node 22+, the active MCP dock, the project path,
and that both Godot and the AI client run on native Windows. Run the client from
the project root when it supports that; otherwise the explicit
`GODOT_MCP_PROJECT_PATH` value is required.

To remove a local trial, disable the plugin in **Project Settings > Plugins**,
remove its user-level MCP server entry, then inspect the Git diff. Delete the
untracked add-on and restore only the confirmed plugin change in `project.godot`.
Do not discard unrelated work.

For current compatibility and troubleshooting, read the toolkit's
[quick start](https://github.com/NPGameDev/godot-mcp-toolkit#quick-start) and
[troubleshooting guide](https://github.com/NPGameDev/godot-mcp-toolkit/blob/main/docs/troubleshooting.md).
