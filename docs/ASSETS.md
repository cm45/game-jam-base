# Ninja Adventure assets

The complete original **Ninja Adventure Asset Pack** is vendored in
`assets/ninja_adventure/source/`. Its folder layout is unchanged so an artist or
developer can find the same files described by the publisher.

## Source record

| Field | Value |
| --- | --- |
| Publisher | Pixel-boy and AAA |
| Source | https://pixel-boy.itch.io/ninja-adventure-asset-pack |
| Downloaded | 2026-09-13 |
| Archive | `Ninja Adventure - Asset Pack.zip` |
| Archive SHA-256 | `95A06F4FDCFD1882F061A45FF313B7C905DBE2DE1E8512B281D7937DF62A7B15` |
| License | CC0 1.0 Universal |

The original `README.md` and `LICENSE.txt` remain inside the source folder.
CC0 permits commercial use and does not require attribution. This project still
credits Pixel-boy and AAA in its README and releases.

## Git LFS storage

The pack's PNG, GIF, WAV, OGG, and TTF files are stored with Git LFS. Install
Git LFS before cloning, then run git lfs install once on each developer machine.
Normal cloning downloads the files automatically; run git lfs pull if a source
asset is still a text pointer.

The two original text files remain normal Git files so their source and license
are immediately readable. Do not change the LFS patterns without confirming a
fresh clone still receives every asset used by the project.

## How Godot uses the pack

Godot imports assets directly from this source folder. The project-wide texture
filter is nearest-neighbor, so pixel art remains crisp. The initial shared UI
theme uses:

- `Ui/Font/NormalFont.ttf`
- `Ui/Theme/Theme Wood/`

Do not put generated `.import` files or the `.godot/` cache under version
control. Create game-specific scenes, TileSet resources, and animation
resources outside this original source folder.
