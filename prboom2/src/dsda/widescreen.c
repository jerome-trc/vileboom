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