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

char* stbar_wide = "STBAR_WS";
char* titlepic_wide = "TITLE_WS";
char* interpic_wide = "INTER_WS";
char* credit_wide = "CREDI_WS";
char* help0_wide = "HELP_WS";
char* help1_wide = "HELP1_WS";
char* help2_wide = "HELP2_WS";
char* bossback_wide = "BOSSB_WS";
char* e1map_wide = "WIMAP0WS";
char* e2map_wide = "WIMAP1WS";
char* e3map_wide = "WIMAP2WS";
char* victory_wide = "VICTO_WS";
char* bunny1_wide = "PFUB1_WS";
char* bunny2_wide = "PFUB2_WS";
char* endpic_wide = "ENDPI_WS";

extern int D_CheckWide(const char* lump) {
    static int ws = 0;
    static int last_numwadfiles = -1;

    // This might be called before all wads are loaded
    if (numwadfiles != last_numwadfiles) {
        int num;

        last_numwadfiles = numwadfiles;
        num = W_CheckNumForName(lump);

        if (num != LUMP_NOT_FOUND) {
            ws = 1;
        }
    }
    return ws;
}