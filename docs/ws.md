# Widescreen _WS Lump Support

Nyan Doom supports new widescreen background and statusbar lumps with the suffix `_WS`.

When any of the `widescreen` lumps are loaded within a WAD, they will take priority over the following `original` lumps.

Note there are no widescreen versions for [animated lumps](animbg.md) as the animated lumps take priority over widescreen lumps. So the lump priority is: `start/end animations` > `widescreen` > `original`.

### Doom Patches

| Original       | Widescreen              |
|----------------|-------------------------|
| STBAR          | STBAR_WS                |
| TITLEPIC       | TITLE_WS                |
| INTERPIC       | INTER_WS                |
| CREDIT         | CREDI_WS                |
| HELP           | HELP_WS                 |
| HELP1          | HELP1_WS                |
| HELP2          | HELP2_WS                |
| BOSSBACK       | BOSSB_WS                |
| WIMAP0         | WIMAP0WS                |
| WIMAP1         | WIMAP1WS                |
| WIMAP2         | WIMAP2WS                |
| VICTORY2       | VICTO_WS                |
| PFUB1          | PFUB1_WS                |
| PFUB2          | PFUB2_WS                |
| ENDPIC         | ENDPI_WS                |

### Boom Patches

| Original       | Widescreen              |
|----------------|-------------------------|
| HELP01         | HELP01WS                |
| HELP02         | HELP02WS                |
| ...            | ...                     |
| HELP99         | HELP99WS                |

### UMAPINFO Patches
Nyan Doom automatically truncates strings larger than 6 characters to fit the suffix `WS` in the 8 character limit. Strings under than 6 characters won't be truncated.

| UMAPINFO KEY   | Example        | WS Example              |
|----------------|----------------|-------------------------|
| ENTERPIC       | INTER1EN       | INTER1WS                |
| EXITPIC        | EXIT1          | EXIT1WS                 |
| ENDPIC         | EXAMP1PC       | EXAMP1WS                |
| INTERBACKDROP  | MEOW1          | MEOW1WS                 |

### Heretic/Hexen Patches

Lumps not yet implimented.