## Planned Features for the Future
- Add an [Animate](../docs/animbg.md) lump support to customise animation speed
- Add option / functionality for midtexture bleeds in OpenGL
- Render ENDOOM at fullscreen (like in Woof)
- Re-add shrunken view (+ and - view)

## Feature Status and Notes (For Nerds)
- OpenGL Midtexture Bleeds
  - I'm a bit stumped on this one since I'm unfamiliar with exactly how the OpenGL rendering works. Not even sure if it's possible.
- Render ENDOOM at fullscreen
  - Woof does this, but the "textscreen" code they use is way too complicated and probably un-needed.
- Re-add shrunken view (+ and - view)
  - This is a little tricky because of the hud message code being [extracted / rewritten](https://github.com/kraflab/dsda-doom/commit/58cdb8b0d8b3fe2762c922aa2c66594c2040de09), so a simple copy and paste from [this](https://github.com/kraflab/dsda-doom/commit/697ccec56e4fefa1376097d2cc632963cb2b56e5) isn't that easy. It's most definitely possible, I just have to parse through how the hud message code has changed.