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

char* titlepic_start;
char* titlepic_end;
char* interpic_start;
char* interpic_end;
char* mdoom_start;
char* mdoom_end;
char* mskull_start;
char* mskull_end;
char* stbar_start;
char* stbar_end;
char* starms_start;
char* starms_end;
char* credit_start;
char* credit_end;
char* help0_start;
char* help0_end;
char* help1_start;
char* help1_end;
char* help2_start;
char* help2_end;
char* bossback_start;
char* bossback_end;
char* e1map_start;
char* e1map_end;
char* e2map_start;
char* e2map_end;
char* e3map_start;
char* e3map_end;
char* victory_start;
char* victory_end;
char* endpic_start;
char* endpic_end;

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
void D_DrawAnimateBunny(const char* lump_x, const char* lump_y, const char* lump_s, const char* lump_e);
void M_DrawMenuAnimate(const char* lump_x, const char* lump_y, const char* lump_s, const char* lump_e);
void M_DrawStbarAnimate(const char* lump_x, const char* lump_y, const char* lump_z, const char* lump_s, const char* lump_e);
int dsda_AnimateExistCheck(void);

#endif