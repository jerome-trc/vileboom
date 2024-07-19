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

const char* titlepic_start;
const char* titlepic_end;
const char* interpic_start;
const char* interpic_end;
const char* mdoom_start;
const char* mdoom_end;
const char* mskull_start;
const char* mskull_end;
const char* stbar_start;
const char* stbar_end;
const char* starms_start;
const char* starms_end;
const char* credit_start;
const char* credit_end;
const char* help0_start;
const char* help0_end;
const char* help1_start;
const char* help1_end;
const char* help2_start;
const char* help2_end;
const char* bossback_start;
const char* bossback_end;
const char* e1map_start;
const char* e1map_end;
const char* e2map_start;
const char* e2map_end;
const char* e3map_start;
const char* e3map_end;
const char* victory_start;
const char* victory_end;
const char* endpic_start;
const char* endpic_end;

int Check_Doom_Animate;
int Check_Skull_Animate;
int Check_Stbar_Animate;
int Check_Starms_Animate;
int Check_Titlepic_Animate;
int Check_Interpic_Animate;
int Check_Credit_Animate;
int Check_Help0_Animate;
int Check_Help1_Animate;
int Check_Help2_Animate;
int Check_Bossback_Animate;
int Check_E1map_Animate;
int Check_E2map_Animate;
int Check_E3map_Animate;
int Check_Victory_Animate;
int Check_Endpic_Animate;


int D_CheckAnimate(const char* lump_s, const char* lump_e);
void D_DrawAnimate(const char* lump_s, const char* lump_e);
//void D_DrawAnimateBunny(const char *lump_x, const char *lump_y, const char *lump_s, const char *lump_e);
void M_DrawMenuAnimate(const int lump_x, const int lump_y, const char* lump_s, const char* lump_e);
void M_DrawStbarAnimate(const int lump_x, const int lump_y, const int lump_z, const char* lump_s, const char* lump_e);
void dsda_AnimateExistCheck(void);

#endif