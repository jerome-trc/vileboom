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

#include "library.h"

//#define WideSpecialLumps (stbar_og || starms_og || titlepic_og || interpic_og || credit_og || help0_og || help1_og || help2_og || victory_og || endpic_og || bunny1_og || bunny2_og)

int animateLumps;
int widescreenLumps;

int Check_Stbar_Wide;
int Check_Skull_Animate;
int Check_Stbar_Animate;

extern void ST_SetScaledWidth();

extern void dsda_CheckNyanLumps(void) {
    Check_Skull_Animate = D_CheckAnimate(mskull1);
    Check_Stbar_Animate = D_CheckAnimate(stbar);
    Check_Stbar_Wide = D_CheckWide(stbar, "_WS");
}

extern void dsda_ReloadNyanLumps(void)
{
  animateLumps = (dsda_IntConfig(nyan_config_enable_animate_lumps) ? 1 : 0);
  widescreenLumps = (dsda_IntConfig(nyan_config_enable_widescreen_lumps) ? 1 : 0);
  ST_SetScaledWidth();
}

extern const int D_CheckAnimate(const char* lump)
{
    static int SCheck;
    static int ECheck;
    static int Animate;
    const char* lump_s;
    const char* lump_e;
    Animate = 0;

    //if(!animateLumps)
      //return Animate;

    if(lump == mskull1)
        lump = "SKULL";
    if(lump == mdoom)
        lump = "DOOM";

    lump_s = AnimateCombine("S_", lump);
    lump_e = AnimateCombine("E_", lump);
    //lprintf(LO_INFO, "Check Start lump name: %s\n", lump_s);
    //lprintf(LO_INFO, "Check End lump name: %s\n", lump_e);
    //lprintf(LO_INFO, "Check End lump name: %s\n", lump);

    SCheck = W_CheckNumForName(lump_s);
    ECheck = W_CheckNumForName(lump_e);
    //lprintf(LO_INFO, "Start lump exist?: %i\n", SCheck);
    //lprintf(LO_INFO, "End lump exist?: %i\n", ECheck);

    if ((SCheck != LUMP_NOT_FOUND) && (ECheck != LUMP_NOT_FOUND))
        if ((W_GetNumForName(lump_s)) <= (W_GetNumForName(lump_e)))
            Animate = 1;

    //lprintf(LO_INFO, "Animate exitpic/enterpic?: %i\n", Animate);
    return Animate;
}

extern const int D_CheckWide(const char* lump, const char *suffix) {
    static int widecheck;
    static int widescreen;
    const char* lump_w;
    widescreen = 0;

    //if(!widescreenLumps)
      //return widescreen;

    if (lump == e3bunny1 || lump == e3bunny2)
        suffix = "_WS";

    //lprintf(LO_INFO, "lump = %s\n", lump);

    lump_w = WideCombine(lump, suffix);
    //lprintf(LO_INFO, "Check combine name: %s\n", lump_w);
    widecheck = W_CheckNumForName(lump_w);
    //lprintf(LO_INFO, "lump exist?: %i\n", widecheck);

    if (widecheck != LUMP_NOT_FOUND)
        widescreen = 1;
    return widescreen;
}

extern const char* D_ApplyWide(const char* lump, const char* suffix)
{
    static int widecheck;
    const char* lump_w;

    if(!widescreenLumps)
      return lump;

    lump_w = WideCombine(lump, suffix);
    //lprintf(LO_INFO, "Check combine name: %s\n", lump_w);
    widecheck = W_CheckNumForName(lump_w);
    //lprintf(LO_INFO, "lump exist?: %i\n", widecheck);

    if (widecheck != LUMP_NOT_FOUND)
    {
        //lprintf(LO_INFO, "Widescreen?: %s\n", lump_w);
        return lump_w;
    }
    else
    {
        //lprintf(LO_INFO, "Not widescreen: %s\n", lump);
        return lump;
    }
}

extern void V_DrawNameNyanPatch(const int x, const int y, const int scrn, const char* lump, const int color, const int flags)
{
    int frameDiff;
    int frame;
    int lumpNum;
    //static int MCheck;
    static int SCheck;
    static int ECheck;
    const char* lump_s;
    const char* lump_e;
    const char* lump_w;
    static int SLump;
    static int ELump;
    static int WCheck;
    static int AniCheck;
    AniCheck = 0;

    //MCheck = W_CheckNumForName(lump);
    //MLump = W_GetNumForName(lump);

    //if (MCheck)
    lumpNum = W_GetNumForName(lump);

    if (animateLumps)
    {
        lump_s = AnimateCombine("S_", lump);
        lump_e = AnimateCombine("E_", lump);
        SCheck = W_CheckNumForName(lump_s);
        ECheck = W_CheckNumForName(lump_e);

        if ((SCheck != LUMP_NOT_FOUND) && (ECheck != LUMP_NOT_FOUND))
        {
            SLump = W_GetNumForName(lump_s);
            ELump = W_GetNumForName(lump_e);

            if (SLump <= ELump)
            {
                frameDiff = ELump - SLump;
                frame = (AnimateTime) % (frameDiff + 1);
                lumpNum = SLump + frame;
                AniCheck = 1;
            }
        }
    }
    if (widescreenLumps && !AniCheck)
    {
        if(lump == stbar || lump == titlepic || lump == interpic || lump == credit ||
            lump == help0 || lump == help1 || lump == help2 || lump == e2victory ||
            lump == e4endpic || lump == e3bunny1 || lump == e3bunny2)
            lump_w = D_ApplyWide(lump, "_WS");
        else
            lump_w = D_ApplyWide(lump, "WS");

        WCheck = W_CheckNumForName(lump_w);

        if (WCheck)
            lumpNum = W_GetNumForName(lump_w);
    }

    V_DrawNumPatch(x, y, scrn, lumpNum, color, flags);
}

extern const char* D_CheckAnimateNyanPatch(const char* lump)
{
    static int SCheck;
    static int ECheck;
    const char* lump_s;
    const char* lump_e;
    static int SLump;
    static int ELump;

    lump_s = AnimateCombine("S_", lump);
    lump_e = AnimateCombine("E_", lump);
    SCheck = W_CheckNumForName(lump_s);
    ECheck = W_CheckNumForName(lump_e);

    if ((SCheck != LUMP_NOT_FOUND) && (ECheck != LUMP_NOT_FOUND))
    {
        SLump = W_GetNumForName(lump_s);
        ELump = W_GetNumForName(lump_e);

        if (SLump <= ELump)
            return lump_s;
        else
            return lump;

    }
    else
        return lump;
}

extern const char* D_CheckWideNyanPatch(const char* lump)
{
    const char* lump_w;
    static int WCheck;

    lump_w = D_ApplyWide(lump, "_WS");
    WCheck = W_CheckNumForName(lump_w);

    if (WCheck)
        return lump_w;
    else
        return lump;
}

extern void V_DrawNameMenuPatch(const int x, const int y, const int scrn, const char* lump, const int color, const int flags)
{
    int frameDiff;
    int frame;
    int lumpNum;
    static int SCheck;
    static int ECheck;
    //static int MCheck;
    const char* lump_s;
    const char* lump_e;
    static int SLump;
    static int ELump;

    //MCheck = W_CheckNumForName(lump);
    //MLump = W_GetNumForName(lump);

    //if (MCheck)
    //{
    lumpNum = W_GetNumForName(lump);
    //}
    if (animateLumps)
    {
        if(lump == mskull1)
            lump = "SKULL";
        if(lump == mdoom)
            lump = "DOOM";
        lump_s = AnimateCombine("S_", lump);
        lump_e = AnimateCombine("E_", lump);
        //lprintf(LO_INFO, "Check Start lump name: %s\n", lump_s);
        //lprintf(LO_INFO, "Check End lump name: %s\n", lump_e);
        SCheck = W_CheckNumForName(lump_s);
        ECheck = W_CheckNumForName(lump_e);
        //lprintf(LO_INFO, "Start lump exist?: %i\n", SCheck);
        //lprintf(LO_INFO, "End lump exist?: %i\n", ECheck);

        if ((SCheck != LUMP_NOT_FOUND) && (ECheck != LUMP_NOT_FOUND))
        {
            SLump = W_GetNumForName(lump_s);
            ELump = W_GetNumForName(lump_e);

            if (SLump <= ELump)
            {
                frameDiff = ELump - SLump;
                frame = (AnimateTime) % (frameDiff + 1);
                lumpNum = SLump + frame;
            }
        }
    }

    V_DrawNumPatch(x, y, scrn, lumpNum, color, flags);
}

const char* AnimateCombine(const char *lump_prefix, const char *lump_main)
{
    char lump_short[7];
    size_t main, prefix;
    memcpy(lump_short, lump_main, strlen(lump_main));

    if (lump_prefix == NULL)
        lump_prefix = "S_";

    if (strlen(lump_main) > 6)
        lump_short[6] = 0;
    else
        lump_short[strlen(lump_main)] = 0;

    main = strlen(lump_short);
    prefix = strlen(lump_prefix);

    char *result = Z_Malloc(prefix + main + 1);
    memcpy(result, lump_prefix, prefix);
    memcpy(result + prefix, lump_short, main + 1);
    return result;
}

const char* WideCombine(const char *lump_main, const char *lump_suffix)
{
    //lprintf(LO_INFO, "widecombine lump_main = %s\n", lump_main);
    //lprintf(LO_INFO, "widecombine lump_suffix = %s\n", lump_suffix);
    char lump_short[7];
    size_t main, suffix;
    memcpy(lump_short, lump_main, strlen(lump_main));

    if (lump_suffix == NULL)
        lump_suffix = "WS";

    if (strlen(lump_main) > 5 && !strcmp(lump_suffix, "_WS"))
        lump_short[5] = 0;
    else if (strlen(lump_main) > 6 && !strcmp(lump_suffix, "WS"))
        lump_short[6] = 0;
    else
        lump_short[strlen(lump_main)] = 0;
    //lprintf(LO_INFO, "widecombine lump_short = %s\n", lump_short);

    main = strlen(lump_short);
    suffix = strlen(lump_suffix);

    char *result = Z_Malloc(main + suffix + 1);
    memcpy(result, lump_short, main);
    memcpy(result + main, lump_suffix, suffix + 1);
    //lprintf(LO_INFO, "widecombine result = %s\n", result);
    return result;
}