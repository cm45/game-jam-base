# AI and MCP guide

AI can help a new developer learn, explain a Godot error, draft a focused
change, and review a diff. It cannot replace running the scene or deciding what
fits the game. Keep each request small, inspect the changed files, then run the
project.

## Start with a free option

The options below were checked on 13 September 2026. Free quotas and available
models change often, so open the linked provider page before the jam.

| Option | Free starting point | Best use in this jam |
| --- | --- | --- |
| [Google Antigravity](https://antigravity.google/docs/ide/overview) | Personal Google account with an Antigravity plan, including a free tier | Recommended agent-first workflow: plans, supervised edits, MCP, and `.agents/skills/` support. |
| [Kilo Code](https://kilo.ai/docs/getting-started/using-kilo-for-free) | Free platform access; choose `Auto Free` or an available free model | Editor-first agent with Agent Skills. Free-model availability and rate limits vary. |
| [Cline](https://docs.cline.bot/getting-started/authorizing-with-cline) | Its provider offers models tagged `FREE` for learning and experimentation | A flexible VS Code agent with workspace skills and MCP support. |
| [GitHub Copilot Free](https://docs.github.com/en/copilot/get-started/plans) | Free GitHub plan with a limited monthly allowance | Inline help and short VS Code questions; it understands this repository's native `.github/` customizations. |
| [Codex extension](https://marketplace.visualstudio.com/items?itemName=openai.chatgpt) | Requires an eligible ChatGPT plan | Larger code tasks, review, and documentation-aware work. |

The free tiers and quotas change often. Treat hosted models as shared services:
if one is busy or rate-limited, switch to another option rather than adding
money by mistake. None of the setup steps in this guide require an API key in
the repository. Do not paste a provider API key into this repository.

## Recommended: Antigravity in VS Code

Google Antigravity is an agent-first development environment available as a VS
Code extension. It supports supervised plans and diffs, MCP, and the open
`SKILL.md` Agent Skills format and is the supported Google agent workflow for
this repository.

1. Open VS Code and install [Google Antigravity](https://marketplace.visualstudio.com/items?itemName=Google.google-antigravity)
   from the Extensions view.
2. Open the Antigravity activity-bar panel and sign in with a personal Google
   account. Antigravity's free tier and plan quotas are shown by the product.
3. Open this repository as the workspace. Antigravity discovers the checked-in
   workflows in `.agents/skills/`.
4. In Antigravity's MCP settings, load the local
   `.agents/mcp_config.json`, then keep Godot open before connecting the local
   Godot MCP bridge.
5. Ask for a plan first, review the proposed files and commands, and require a
   focused Godot check before accepting changes.

See Antigravity's [IDE overview](https://antigravity.google/docs/ide/overview),
[VS Code setup](https://antigravity.google/docs/ide/extensions/vscode), and
[Agent Skills guide](https://www.antigravity.google/docs/skills) for the
current product workflow.

## Editor-first alternative: Kilo Code

Kilo Code runs directly in VS Code and can use free hosted models without a
local model runtime.

1. In VS Code, open **Extensions** (`Ctrl+Shift+X`), search for **Kilo Code**,
   then use the Install dropdown to select **Install Pre-Release Version**.
   Kilo documents this channel as its stable recommended extension.
2. Open the Kilo sidebar and sign in with a free account.
3. In model selection, choose **Auto Free** or another model marked free. Kilo
   may route Auto Free to different providers, so availability and limits can
   change during the jam.
4. Kilo discovers the repository's compatibility workflows in
   `.agents/skills/`. They point to the shared workflow text in
   `.github/skills/`.

See Kilo's [installation instructions](https://kilo.ai/docs/getting-started/installing)
and its [Agent Skills compatibility notes](https://github.com/Kilo-Org/kilocode/blob/main/packages/kilo-docs/pages/customize/skills.md).

## Flexible alternative: Cline

Cline is a VS Code agent that supports workspace `SKILL.md` files, MCP, and a
model picker. It is useful when Antigravity or Kilo reaches a quota.

1. In VS Code, search Extensions for **Cline** and install it.
2. Open the Cline panel, choose the **Cline** provider, and sign in.
3. Search the model picker for `free`, then choose a model marked `FREE`.
   These models are meant for learning and experimentation; do not assume a
   particular model will remain available.
4. Cline discovers the compatibility workflows in `.cline/skills/`, which
   point to the shared source files in `.github/skills/`.

Cline's [installation guide](https://docs.cline.bot/getting-started/installing-cline),
[free-model guidance](https://docs.cline.bot/core-workflows/task-management),
and [workspace-skills guide](https://docs.cline.bot/customization/skills) cover
the current UI. Cline can also use paid or bring-your-own-key providers, but
they are outside this free-first setup.

## A good first workflow

1. Ask the AI to explain a selected script, node, or Godot error in plain
   language.
2. Ask for a plan that names the files it would change and the check it would
   run.
3. Review the plan against the current roadmap milestone.
4. Ask for the smallest implementation, or write it yourself.
5. Review the diff and run the scene before accepting the change.

Useful prompts:

~~~text
Explain this GDScript file for a beginner. Identify the node it expects and the
signals it emits. Do not edit files.
~~~

~~~text
Plan a one-scene pickup mechanic that fits the current foundation milestone.
Name the files, data flow, and one Godot validation command. Do not implement it.
~~~

~~~text
Review my uncommitted Godot changes. Find broken scene paths, generated files,
and anything that makes the main scene fail to start.
~~~

## Repository AI customizations

The workflow source of truth is `.github/skills/`. The small files in other
directories let compatible agents discover the same workflow without copying
its instructions. Change the source file when improving a workflow.

| File or folder | Purpose |
| --- | --- |
| `AGENTS.md` | Shared instructions for Codex and agents that read repository instruction files. |
| `.github/copilot-instructions.md` | Always-on VS Code Copilot guidance. |
| `.github/instructions/` | Rules applied when GDScript files are involved. |
| `.github/agents/` | Planner and implementer roles available in VS Code chat. |
| `.github/skills/` | Source workflows for foundation work and verification. |
| `.agents/skills/` | Antigravity and compatible-agent discovery entries for the source workflows. |
| `.cline/skills/` | Cline discovery entries for the source workflows. |
| `AGENTS.md` | Shared project instructions for agents that read repository guidance. |

In VS Code, run **Chat: Open Customizations** to inspect the native GitHub
Copilot files. The Planner is for a reviewable plan without edits. The
Implementer is for an already approved small change.

## Use MCP in VS Code and agents

MCP connects an AI chat to named tools and resources. The repository ships the
read-only OpenAI Developer Docs server and a local Godot MCP server with write
tools enabled. Both are included in these configurations:

| Agent | Checked-in configuration | How to inspect it |
| --- | --- | --- |
| VS Code chat / GitHub Copilot | `.vscode/mcp.json` | Run **MCP: List Servers**. |
| VS Code Agent Host and compatible agents | `.mcp.json` | Use that agent's MCP/server view. |
| Antigravity | `.agents/mcp_config.json` | Open Antigravity MCP settings and load the checked-in local configuration. |

The Developer Docs server definition is public and contains no credential:

~~~json
{
  "openaiDeveloperDocs": {
    "httpUrl": "https://developers.openai.com/mcp"
  }
}
~~~

For VS Code chat, install an AI provider, run **MCP: List Servers**, inspect
both server names and capabilities, then start them when you trust the
configuration. `openaiDeveloperDocs` is a remote documentation service;
`godotMcpToolkit` is local and requires Node.js 22+ plus an open Godot editor.
VS Code's [MCP guide](https://code.visualstudio.com/docs/agent-customization/mcp-servers)
explains workspace and user-level servers.

Kilo and Cline also support MCP, but use their own configuration UI and file
format. For the local Godot bridge, copy its `mcpServers` entry from
`.mcp.json` if the extension does not discover it. Keep credentials in secret
storage rather than a project file. For Codex CLI, add both services with:

~~~powershell
codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp
codex mcp add godot-mcp-toolkit --env GODOT_MCP_CONFIG_VERSION=1 -- cmd /c npx -y @npgamedev/godot-mcp-server@1.0.0
codex mcp list
~~~

See the [official Codex MCP documentation](https://learn.chatgpt.com/docs/extend/mcp)
for authentication and server-management details.

## Included Godot editor MCP

The repository includes a pinned community add-on in
`addons/godot_mcp_toolkit/` with write tools enabled by default. It can inspect
and edit the locally running Godot editor. Start with a small, reviewable
request; the full process, configuration locations, and temporary read-only
option are in [the Godot MCP guide](GODOT_MCP.md).

## Treat AI output as a draft

Never paste a secret, personal save file, or private key into an AI prompt.
Do not approve a command you do not understand. Do not commit generated Godot
import files. Keep source assets untouched, and use a Git checkpoint before
asking an agent to make a broad change.
