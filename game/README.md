# Build your game here

Open **home.tscn** to edit the camp, or **gameplay.tscn** to edit the resource
gathering area. Press F5 to play from home. These are the single playable
example; replace them in place as your jam game grows.

- `home.gd`: Merchant, Mentor, Scout interactions and the permanent wallet HUD.
- `gameplay.gd`: the current three-token objective and reward popup.
- `game_definition.gd`: scene paths, base movement speed, and permanent
  upgrade values passed into the next gameplay session.
- `world/terrain_tileset.tres`: the shared paint palette for the two maps.

## Paint the ground in Godot

1. Open `home.tscn` or `gameplay.tscn` in the 2D editor.
2. Expand **Terrain** in the scene tree.
3. Select **Grass** to paint the base field, or **Paths** to paint/erase paths.
4. In the TileMap bottom panel, select the grass or dirt tile from the atlas.
   Use the paint, rectangle, bucket, and eraser tools to change cells.
5. Save with Ctrl+S. F5 shows exactly those saved cells: no script regenerates
   the ground or overwrites your edits.

Tiles are 16×16 source pixels. Terrain starts at (0, 0), so its saved base
grass covers the visible 640×360 world from the top-left corner; it draws below
world props. The last grass row extends slightly below the viewport to provide
an edit-safe lower edge.

The source palette starts with two seamless tiles. To expose more art, edit
`world/terrain_tileset.tres` in the TileSet editor and add atlas regions.
Do not modify the original PNG in assets/ninja_adventure/source/.

Buildings, trees, NPCs, and their colliders are ordinary scene nodes.
Move each parent node to move its sprite and collision together. Tree sprites
use (0, 0, 32, 32), and the house uses (0, 0, 64, 48). Ground tiles are walkable;
building and tree StaticBody2D nodes provide the solid obstacles.

## Change the gameplay

A **run** in the framework means one gameplay session: a wave-defense map,
mining trip, dungeon, or anything else. It is not a genre requirement.
Home creates RunContext; gameplay consumes it and returns RunResult once.
See [the replacement guide](../docs/REPLACE_STARTER.md) for the tower-defense
recipe and the [contract](../docs/RUN_CONTRACT.md) for the API.

Movement lives in components/top_down_player, not in a foundation service.
For a tower-defense game, remove the player, pickups, and exit from gameplay
and implement waves and towers. Keep home and progression only where useful.

## Quick play check

Walk to Merchant (shop), Mentor (skills), and Scout (start gameplay), pressing E.
Collect three tokens and claim the reward. Check that the next session uses
your upgrades. Escape supplies Resume, Settings, Keybinds, and Quit.
