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

char* stbar_wide;
char* titlepic_wide;
char* interpic_wide;
char* credit_wide;
char* help0_wide;
char* help1_wide;
char* help2_wide;
char* bossback_wide;
char* e1map_wide;
char* e2map_wide;
char* e3map_wide;
char* victory_wide;
char* bunny1_wide;
char* bunny2_wide;
char* endpic_wide;

int D_CheckWide(const char* lump);

int dsda_WideExistCheck(void);
int Check_Stbar_Wide;
int Check_Titlepic_Wide;
int Check_Interpic_Wide;
int Check_Credit_Wide;
int Check_Help0_Wide;
int Check_Help1_Wide;
int Check_Help2_Wide;
int Check_Bossback_Wide;
int Check_E1map_Wide;
int Check_E2map_Wide;
int Check_E3map_Wide;
int Check_Victory_Wide;
int Check_Bunny1_Wide;
int Check_Bunny2_Wide;
int Check_Endpic_Wide;

#endif
