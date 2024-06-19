//
// Copyright(C) 2024 by Andrik Powell
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// DESCRIPTION:
//	DSDA Widescreen
//

#include "w_wad.h"

#include "widescreen.h"

extern int dsda_WadTitlepic(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("TITLE_WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadInterpic(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("INTER_WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadCredit(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("CREDI_WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadBossback(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("BOSSB_WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadHelp(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("HELP_WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadHelp1(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("HELP1_WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadHelp2(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("HELP2_WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadStbar(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("STBAR_WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadWIMAP0(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("WIMAP0WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadWIMAP1(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("WIMAP1WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadWIMAP2(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("WIMAP2WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadVictory(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("VICTO_WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadBunny1(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("PFUB1_WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadBunny2(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("PFUB2_WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}

extern int dsda_WadEndpic(void) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName("ENDPI_WS");

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}