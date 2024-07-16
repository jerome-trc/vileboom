# Animated Background and Menu Support

Nyan Doom supports new animated background and menu graphics via specific lumps.

Only when both `start` and `end` animation lumps are present for a single entry, will those animation lumps take priority over the `original` lumps. Any lumps in-between the `start` and `end` lumps will also be included in the animation. Animations run at the same speed as the Menu Selector (`M_SKULL1/2`).

Note there are no [widescreen](ws.md) versions for these animated lumps as they take priority over widescreen lumps. The lump priority is: `start/end animations` > `widescreen` > `original`.

#### Please Note:
The `start` lumps should be placed *above* or *before* the `end` lumps in the WAD lump order. Failure to do so will result in the widescreen / original lumps being displayed instead.
- `Start` Lumps with the prefix `S_` mark the start the animation
- `End` Lumps with the prefix `E_` mark the end of animation

### Animated Backgrounds

| Original       | Start Animation         | End Animation           |
|----------------|-------------------------|-------------------------|
| TITLEPIC       | S_TITLEP                | E_TITLEP                |
| INTERPIC       | S_INTERP                | E_INTERP                |
| CREDIT         | S_CREDIT                | E_CREDIT                |
| HELP           | S_HELP                  | E_HELP                  |
| HELP1          | S_HELP1                 | E_HELP1                 |
| HELP2          | S_HELP2                 | E_HELP2                 |
| BOSSBACK       | S_BOSSBA                | E_BOSSBA                |
| WIMAP0         | S_WIMAP0                | E_WIMAP0                |
| WIMAP1         | S_WIMAP1                | E_WIMAP1                |
| WIMAP2         | S_WIMAP2                | E_WIMAP2                |
| VICTORY2       | S_VICTOR                | E_VICTOR                |
| ENDPIC         | S_ENDPIC                | E_ENDPIC                |

### Animated Menu / Statusbar Graphics

| Original       | Animation Start         | Animation End           |
|----------------|-------------------------|-------------------------|
| M_DOOM         | S_DOOM                  | E_DOOM                  |
| M_SKULL1/2     | S_SKULL                 | E_SKULL                 |
| STBAR          | S_STBAR                 | E_STBAR                 |
| STARMS         | S_STARMS                | E_STARMS                |

### Boom Patches

| Original       | Animation Start         | Animation End           |
|----------------|-------------------------|-------------------------|
| HELP01         | S_HELP01                | E_HELP01                |
| HELP02         | S_HELP02                | E_HELP02                |
| ...            | ...                     | ...                     |
| HELP99         | S_HELP99                | E_HELP99                |

### Heretic/Hexen Animated Backgrounds

Lumps not yet implimented.

### Unsupported

The following lumps have visual or technical issues and therefore do not have animations:
- PFUB1
- PFUB2