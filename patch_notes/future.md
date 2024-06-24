## Planned Features for the Future
- Add dark transparent background behind menu / automap like in [Woof](https://github.com/fabiangreffrath/woof)
- PrBoomX's "Tag Finder"
- Add option / functionality for midtexture bleeds in OpenGL
- Re-add shrunken view (+ and - view)
- ENDOOM
  - Add check / option to view ENDOOM 'only if PWAD Modified'
  - Add a 'wait for keyboard press' for the terminal ENDOOM output on Windows
  - Add proper support for ENDOOM on Windows (possibly thru an external ENDOOM.exe?)

## Feature Status and Notes (For Nerds)
- PrBoomX's "Tag Finder"
  - I've created a "tag-finder" [branch](https://github.com/andrikpowell/nyan-doom/tree/tag-finder) that has all the needed code for the feature. I'm not sure why It's not working... Perhaps DSDA Doom code has changed something? :/
- Woof Dark Transparent Background
  - Seems like it may be possible, but it's a bit harder to figure out due to WinMBF having a slightly different codebase than PrBoom's.
  - Seems to use a new CR_DARK colormap to print over the screen like a screen palette (like berserk or item pickup)
  - Could possibly have a conflict on OpenGL renderer?
- OpenGL Midtexture Bleeds
  - I'm a bit stumped on this one since I'm not that familiar with exactly how the OpenGL rendering works. Not even sure if it's possible.
- Re-add shrunken view (+ and - view)
  - This is a little tricky because of the hud message code being [extracted / rewritten](https://github.com/kraflab/dsda-doom/commit/58cdb8b0d8b3fe2762c922aa2c66594c2040de09), so a simple copy and paste from [this](https://github.com/kraflab/dsda-doom/commit/697ccec56e4fefa1376097d2cc632963cb2b56e5) isn't that easy. It's most definitely possible, I just have to parse through how the hud message code has changed.
- ENDOOM 'only if PWAD Modified'
  - Honestly this is probably one of the easiest things to implement
- Terminal ENDOOM 'wait for keyboard press' on Windows
  - Haven't really looked into this yet
- 'Proper' suppport for ENDOOM on Windows
  - I personally find the terminal implementation of ENDOOM unsatisfactory, and so I'd like to add a fullscreen option that doesn't use the terminal.
  - I can see why it was cut due to the amount of files needed to print the ENDOOM
  - At first, thought was to maybe make a separate application so that Nyan Doom / DSDA Doom could add support... But it's tricky because, first the WAD loadorder would have to be sent over as a parameter, but also I'm not sure how to also send over the screen display settings from Nyan Doom. Plus this would probably suck if players where screen capturing an application via OBS.
