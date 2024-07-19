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

#ifndef __DSDA_WIDESCREEN__
#define __DSDA_WIDESCREEN__

extern const char* stbar_wide;
extern const char* titlepic_wide;
extern const char* interpic_wide;
extern const char* credit_wide;
extern const char* help0_wide;
extern const char* help1_wide;
extern const char* help2_wide;
extern const char* bossback_wide;
extern const char* e1map_wide;
extern const char* e2map_wide;
extern const char* e3map_wide;
extern const char* victory_wide;
extern const char* bunny1_wide;
extern const char* bunny2_wide;
extern const char* endpic_wide;

int D_CheckWide(const char* lump);

void dsda_WideExistCheck(void);
extern int Check_Stbar_Wide;
extern int Check_Titlepic_Wide;
extern int Check_Interpic_Wide;
extern int Check_Credit_Wide;
extern int Check_Help0_Wide;
extern int Check_Help1_Wide;
extern int Check_Help2_Wide;
extern int Check_Bossback_Wide;
extern int Check_E1map_Wide;
extern int Check_E2map_Wide;
extern int Check_E3map_Wide;
extern int Check_Victory_Wide;
extern int Check_Bunny1_Wide;
extern int Check_Bunny2_Wide;
extern int Check_Endpic_Wide;

#endif
