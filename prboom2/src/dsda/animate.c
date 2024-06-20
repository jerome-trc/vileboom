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
//	DSDA Animate
//

#include "w_wad.h"

#include "animate.h"
#include "v_video.h"

int frameTime;

void Animate_Ticker(void)
{
    // counter for all animation
    frameTime++;
}

extern int D_CheckAnimate(const char* lump_s, const char* lump_e)
{
    static int SCheck;
    static int ECheck;
    static int SLump;
    static int ELump;
    static int Animate;
    Animate = 0;
    SCheck = W_CheckNumForName(lump_s);
    ECheck = W_CheckNumForName(lump_e);
    if ((SCheck != LUMP_NOT_FOUND) && (ECheck != LUMP_NOT_FOUND))
    {
        // Arsinikk - Note this check doesn't work... if you know
        // how to make lump_e come after lump_s, please help fix.
        if ((W_GetNumForName(lump_s)) < (W_GetNumForName(lump_e)))
        {
            Animate = 1;
        }
    }
    else
        return Animate;
}

extern void D_DrawAnimate(const char* lump_s, const char* lump_e)
{
    int frameDiff;
    int frame;
    static int SLump;
    static int ELump;
    SLump = W_GetNumForName(lump_s);
    ELump = W_GetNumForName(lump_e);
    frameDiff = ELump - SLump;
    frame = (frameTime / 12) % (frameDiff + 1);
    V_DrawNumPatch(0, 0, 0, SLump + frame, CR_DEFAULT, VPT_STRETCH);
}

extern void D_DrawAnimateAdv(const char* lump_x, const char* lump_y, const char* lump_s, const char* lump_e)
{
    int frameDiff;
    int frame;
    static int SLump;
    static int ELump;
    SLump = W_GetNumForName(lump_s);
    ELump = W_GetNumForName(lump_e);
    frameDiff = ELump - SLump;
    frame = (frameTime / 12) % (frameDiff + 1);
    V_DrawNumPatch(lump_x, lump_y, 0, SLump + frame, CR_DEFAULT, VPT_STRETCH);
}

extern void M_DrawMenuAnimate(const char* lump_x, const char* lump_y, const char* lump_s, const char* lump_e)
{
    int frameDiff;
    int frame;
    static int SLump;
    static int ELump;
    SLump = W_GetNumForName(lump_s);
    ELump = W_GetNumForName(lump_e);
    frameDiff = ELump - SLump;
    frame = (frameTime / 8) % (frameDiff + 1);
    V_DrawNumPatch(lump_x, lump_y, 0, SLump + frame, CR_DEFAULT, VPT_STRETCH);
}