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

extern const char* titlepic_start;
extern const char* titlepic_end;
extern const char* interpic_start;
extern const char* interpic_end;
extern const char* mdoom_start;
extern const char* mdoom_end;
extern const char* mskull_start;
extern const char* mskull_end;
extern const char* stbar_start;
extern const char* stbar_end;
extern const char* starms_start;
extern const char* starms_end;
extern const char* credit_start;
extern const char* credit_end;
extern const char* help0_start;
extern const char* help0_end;
extern const char* help1_start;
extern const char* help1_end;
extern const char* help2_start;
extern const char* help2_end;
extern const char* bossback_start;
extern const char* bossback_end;
extern const char* e1map_start;
extern const char* e1map_end;
extern const char* e2map_start;
extern const char* e2map_end;
extern const char* e3map_start;
extern const char* e3map_end;
extern const char* victory_start;
extern const char* victory_end;
extern const char* endpic_start;
extern const char* endpic_end;

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


int D_CheckAnimate(const char* lump_s, const char* lump_e);
void D_DrawAnimate(const char* lump_s, const char* lump_e);
//void D_DrawAnimateBunny(const char *lump_x, const char *lump_y, const char *lump_s, const char *lump_e);
void M_DrawMenuAnimate(const int lump_x, const int lump_y, const char* lump_s, const char* lump_e);
void M_DrawStbarAnimate(const int lump_x, const int lump_y, const int lump_z, const char* lump_s, const char* lump_e);
void dsda_AnimateExistCheck(void);

#endif