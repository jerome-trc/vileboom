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

char* mskull_start = "S_SKULL";
char* mskull_end = "E_SKULL";
char* mdoom_start = "S_DOOM";
char* mdoom_end = "E_DOOM";
char* stbar_start = "S_STBAR";
char* stbar_end = "E_STBAR";
char* starms_start = "S_STARMS";
char* starms_end = "E_STARMS";
char* titlepic_start = "S_TITLEP";
char* titlepic_end = "E_TITLEP";
char* interpic_start = "S_INTERP";
char* interpic_end = "E_INTERP";
char* credit_start = "S_CREDIT";
char* credit_end = "E_CREDIT";
char* help0_start = "S_HELP";
char* help0_end = "E_HELP";
char* help1_start = "S_HELP1";
char* help1_end = "E_HELP1";
char* help2_start = "S_HELP2";
char* help2_end = "E_HELP2";
char* bossback_start = "S_BOSSBA";
char* bossback_end = "E_BOSSBA";
char* e1map_start = "S_WIMAP0";
char* e1map_end = "E_WIMAP0";
char* e2map_start = "S_WIMAP1";
char* e2map_end = "E_WIMAP1";
char* e3map_start = "S_WIMAP2";
char* e3map_end = "E_WIMAP2";
char* victory_start = "S_VICTOR";
char* victory_end = "E_VICTOR";
char* endpic_start = "S_ENDPIC";
char* endpic_end = "E_ENDPIC";

extern int Check_Doom_Animate;
extern int Check_Skull_Animate;
extern int Check_Stbar_Animate;
extern int Check_Starms_Animate;
extern int Check_Titlepic_Animate;
extern int Check_Interpic_Animate;
extern int Check_Credit_Animate;
extern int Check_Help0_Animate;
extern int Check_Help1_Animate;
extern int Check_Help2_Animate;
extern int Check_Bossback_Animate;
extern int Check_E1map_Animate;
extern int Check_E2map_Animate;
extern int Check_E3map_Animate;
extern int Check_Victory_Animate;
extern int Check_Endpic_Animate;

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
        if ((W_GetNumForName(lump_s)) <= (W_GetNumForName(lump_e)))
            Animate = 1;
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
    frame = (AnimateTime) % (frameDiff + 1);
    V_DrawNumPatch(0, 0, 0, SLump + frame, CR_DEFAULT, VPT_STRETCH);
}

// Arsinik - Currently disabled due to Bunny sequence not working
//
/* extern void D_DrawAnimateBunny(const char* lump_x, const char* lump_y, const char* lump_s, const char* lump_e)
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
} */

extern void M_DrawMenuAnimate(const char* lump_x, const char* lump_y, const char* lump_s, const char* lump_e)
{
    int frameDiff;
    int frame;
    static int SLump;
    static int ELump;
    SLump = W_GetNumForName(lump_s);
    ELump = W_GetNumForName(lump_e);
    frameDiff = ELump - SLump;
    frame = (AnimateTime) % (frameDiff + 1);
    V_DrawNumPatch(lump_x, lump_y, 0, SLump + frame, CR_DEFAULT, VPT_STRETCH);
}

extern void M_DrawStbarAnimate(const char* lump_x, const char* lump_y, const char* lump_z, const char* lump_s, const char* lump_e)
{
    int frameDiff;
    int frame;
    static int SLump;
    static int ELump;
    SLump = W_GetNumForName(lump_s);
    ELump = W_GetNumForName(lump_e);
    frameDiff = ELump - SLump;
    frame = (AnimateTime) % (frameDiff + 1);
    V_DrawNumPatch(lump_x, lump_y, lump_z, SLump + frame, CR_DEFAULT, VPT_ALIGN_BOTTOM);
}

extern int dsda_AnimateExistCheck(void) {
  Check_Doom_Animate = D_CheckAnimate(mdoom_start,mdoom_end);
  Check_Skull_Animate = D_CheckAnimate(mskull_start,mskull_end);
  Check_Stbar_Animate = D_CheckAnimate(stbar_start,stbar_end);
  Check_Starms_Animate = D_CheckAnimate(starms_start,starms_end);
  Check_Titlepic_Animate = D_CheckAnimate(titlepic_start,titlepic_end);
  Check_Interpic_Animate = D_CheckAnimate(interpic_start,interpic_end);
  Check_Credit_Animate = D_CheckAnimate(credit_start,credit_end);
  Check_Help0_Animate = D_CheckAnimate(help0_start,help0_end);
  Check_Help1_Animate = D_CheckAnimate(help1_start,help1_end);
  Check_Help2_Animate = D_CheckAnimate(help2_start,help2_end);
  Check_Bossback_Animate = D_CheckAnimate(bossback_start,bossback_end);
  Check_E1map_Animate = D_CheckAnimate(e1map_start,e1map_end);
  Check_E2map_Animate = D_CheckAnimate(e2map_start,e2map_end);
  Check_E3map_Animate = D_CheckAnimate(e3map_start,e3map_end);
  Check_Victory_Animate = D_CheckAnimate(victory_start,victory_end);
  Check_Endpic_Animate = D_CheckAnimate(endpic_start,endpic_end);
}