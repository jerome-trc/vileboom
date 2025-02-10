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
#include "m_menu.h"
#include "animate.h"
#include "v_video.h"
#include "lprintf.h"
#include "st_stuff.h"
#include "library.h"

int animateLumps;
int widescreenLumps;

int Check_Stbar_Wide;
int Check_Skull_Animate;
int Check_Stbar_Animate;

void AnimateTicker(void)
{
  AnimateTime++;
}

void dsda_InitNyanLumps(void) {
    if(!raven) {
        Check_Skull_Animate = D_CheckAnimate(mskull1);
        Check_Stbar_Animate = D_CheckAnimate(stbar);
        Check_Stbar_Wide = D_CheckWide(stbar);
    }
}

void dsda_ReloadNyanLumps(void)
{
    if(!raven) {
        animateLumps = (dsda_IntConfig(nyan_config_enable_animate_lumps) ? 1 : 0);
        widescreenLumps = (dsda_IntConfig(nyan_config_enable_widescreen_lumps) ? 1 : 0);
        ST_SetScaledWidth();
    }
}

const int D_CheckAnimate(const char* lump)
{
    int Animate = 0;
    const char* lump_s;
    const char* lump_e;
    int SCheck;
    int ECheck;

    if (!strcmp(lump, mskull1))
        lump = "SKULL";
    if (!strcmp(lump, mdoom))
        lump = "DOOM";

    lump_s = PrefixCombine("S_", lump);
    lump_e = PrefixCombine("E_", lump);
    SCheck = W_CheckNumForName(lump_s);
    ECheck = W_CheckNumForName(lump_e);

    if ((SCheck != LUMP_NOT_FOUND) && (ECheck != LUMP_NOT_FOUND))
        if ((W_GetNumForName(lump_s)) <= (W_GetNumForName(lump_e)))
            Animate = 1;

    return Animate;
}

const int D_CheckWide(const char* lump) {
    int widescreen = 0;
    const char* lump_w;

    lump_w = PrefixCombine("W_", lump);

    if (W_CheckNumForName(lump_w) != LUMP_NOT_FOUND)
        widescreen = 1;
    return widescreen;
}

const char* D_ApplyWide(const char* lump)
{
    const char* lump_w;

    if (!widescreenLumps)
        return lump;

    lump_w = PrefixCombine("W_", lump);

    if (W_CheckNumForName(lump_w) != LUMP_NOT_FOUND)
        return lump_w;
    else
        return lump;
}

void V_DrawNameNyanPatch(const int x, const int y, const int scrn, const char* lump, const int color, const int flags)
{
    int lumpNum = W_GetNumForName(lump);
    int AniCheck = 0;
    int WideCheck = 0;
    int SkipWide = 0;

    if (!strcmp(lump, mskull1))  { SkipWide = 1; lump = "SKULL"; }
    if (!strcmp(lump, mdoom))    { SkipWide = 1; lump = "DOOM"; }
    if (!strcmp(lump, starms))   { SkipWide = 1; }

    if (animateLumps)
    {
        AniCheck = D_SetupAnimatePatch(lump);

        if (AniCheck)
            lumpNum = AniCheck;
    }
    if (widescreenLumps && !AniCheck && !SkipWide)
    {
        WideCheck = D_SetupWidePatch(lump);

        if (WideCheck)
            lumpNum = WideCheck;
    }

    V_DrawNumPatch(x, y, scrn, lumpNum, color, flags);
}

void V_DrawNyanBackground(const char* lump_s, const char* lump_e, const int scrn)
{
    int lumpNum = R_FlatNumForName("FLOOR16");
    int SCheck = W_CheckNumForName2(lump_s, ns_flats);
    int ECheck = W_CheckNumForName2(lump_e, ns_flats);

    if (SCheck)
        lumpNum = R_FlatNumForName(lump_s);

    if ((SCheck != LUMP_NOT_FOUND) && (ECheck != LUMP_NOT_FOUND))
    {
        int SLump = R_FlatNumForName(lump_s);
        int ELump = R_FlatNumForName(lump_e);

        if(SLump <= ELump)
        {
            int speed = 8;
            int frame = (AnimateTime / speed) % (ELump - SLump + 1);
            lumpNum = SLump + frame;
        }
    }

    V_DrawBackgroundNum(lumpNum, scrn);
}

int D_SetupAnimatePatch(const char* lump)
{
    const char* lump_s = PrefixCombine("S_", lump);
    const char* lump_e = PrefixCombine("E_", lump);
    int SCheck = W_CheckNumForName(lump_s);
    int ECheck = W_CheckNumForName(lump_e);

    if ((SCheck != LUMP_NOT_FOUND) && (ECheck != LUMP_NOT_FOUND))
    {
        int SLump = W_GetNumForName(lump_s);
        int ELump = W_GetNumForName(lump_e);

        if (SLump <= ELump)
        {
            int speed = 8;
            int frame = (AnimateTime / speed) % (ELump - SLump + 1);
            return SLump + frame;
        }
        else
            return 0;
    }
    else
        return 0;
}

int D_SetupWidePatch(const char* lump)
{
    const char* lump_w = D_ApplyWide(lump);

    lump_w = D_ApplyWide(lump);

    if (W_CheckNumForName(lump_w))
        return W_GetNumForName(lump_w);
    else
        return 0;
}

const char* PrefixCombine(const char *lump_prefix, const char *lump_main)
{
    char result[9];

    if (lump_prefix == NULL)
        lump_prefix = "W_";

    strncpy(result, lump_prefix, 2);
    strncpy(&result[2], lump_main, 6);
    return result;
}
