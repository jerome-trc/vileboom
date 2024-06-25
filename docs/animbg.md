# Animated Background and Menu Support

Nyan Doom supports new animated background and menu graphics via specific lumps.

Only when both `start` and `end` animation lumps are present for a single entry, will those animation lumps take priority over the `original` lumps. Any lumps in-between the `start` and `end` lumps will also be included in the animation.

Note there are no [widescreen](ws.md) versions for these animated lumps as they take priority over widescreen lumps. The lump priority is: `start/end animations` > `widescreen` > `original`.

#### Please Note:
The `start` lumps should be placed *above* or *before* the `end` lumps in the WAD lump order. Failure to do so will result in the widescreen / original lumps being displayed instead.

### Animated Backgrounds
- `Start` Lumps with the suffix `_S` mark the start the animation
- `End` Lumps with the suffix `_E` mark the end of animation


| Original       | Start Animation         | End Animation           |
|----------------|-------------------------|-------------------------|
| TITLEPIC       | TITLE_S                 | TITLE_E                 |
| INTERPIC       | INTER_S                 | INTER_E                 |
| CREDIT         | CREDIT_S                | CREDIT_E                |
| HELP           | HELP_S                  | HELP_E                  |
| HELP1          | HELP1_S                 | HELP1_E                 |
| HELP2          | HELP2_S                 | HELP2_E                 |
| BOSSBACK       | BOSSB_S                 | BOSSB_E                 |
| WIMAP0         | WIMAP0_S                | WIMAP0_E                |
| WIMAP1         | WIMAP1_S                | WIMAP1_E                |
| WIMAP2         | WIMAP2_S                | WIMAP2_E                |
| VICTORY2       | VICTOR_S                | VICTOR_E                |
| ENDPIC         | ENDPIC_S                | ENDPIC_E                |

### Animated Menu Graphics
- `Start` Lumps with the prefix `S_` mark the start the animation
- `End` Lumps with the prefix `E_` mark the end of animation

| Original       | Animation Start         | Animation End           |
|----------------|-------------------------|-------------------------|
| M_DOOM         | S_DOOM                  | E_DOOM                  |
| M_SKULL1/2     | S_SKULL                 | E_SKULL                 |

### Heretic/Hexen Animated Backgrounds

Lumps not yet implimented.

### Unsupported

The following lumps currently have visual or technical issues and therefore do not currently have animations:
- PFUB1
- PFUB2
- STBAR