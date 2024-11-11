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

#ifndef __DSDA_ANIMATE__
#define __DSDA_ANIMATE__

extern short AnimateTime;
extern int animateLumps;
extern int widescreenLumps;

extern int Check_Stbar_Wide;
extern int Check_Skull_Animate;
extern int Check_Stbar_Animate;

const int D_CheckAnimate(const char* lump);
const char* D_CheckAnimateNyanPatch(const char* lump);
const char* D_CheckWideNyanPatch(const char* lump);

const int D_CheckWide(const char* lump, const char *suffix);
const char* D_ApplyWide(const char* lump, const char* suffix);

void dsda_CheckNyanLumps(void);
void dsda_ReloadNyanLumps(void);

void V_DrawNameNyanPatch(const int x, const int y, const int scrn, const char* lump, const int color, const int flags);
void V_DrawNameMenuPatch(const int x, const int y, const int scrn, const char* lump, const int color, const int flags);


const char* AnimateCombine(const char *lump_prefix, const char *lump_main);
const char* WideCombine(const char *lump_main, const char *lump_suffix);


#endif