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

#include "w_wad.h"

#include "widescreen.h"

const char* stbar_wide = "STBAR_WS";
const char* titlepic_wide = "TITLE_WS";
const char* interpic_wide = "INTER_WS";
const char* credit_wide = "CREDI_WS";
const char* help0_wide = "HELP_WS";
const char* help1_wide = "HELP1_WS";
const char* help2_wide = "HELP2_WS";
const char* bossback_wide = "BOSSB_WS";
const char* e1map_wide = "WIMAP0WS";
const char* e2map_wide = "WIMAP1WS";
const char* e3map_wide = "WIMAP2WS";
const char* victory_wide = "VICTO_WS";
const char* bunny1_wide = "PFUB1_WS";
const char* bunny2_wide = "PFUB2_WS";
const char* endpic_wide = "ENDPI_WS";

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

extern int D_CheckWide(const char* lump) {
    static int widecheck;
    static int widescreen;
    widescreen = 0;

    widecheck = W_CheckNumForName(lump);

    if (widecheck != LUMP_NOT_FOUND)
        widescreen = 1;
    return widescreen;
}

extern void dsda_WideExistCheck(void) {
  Check_Stbar_Wide = D_CheckWide(stbar_wide);
  Check_Titlepic_Wide = D_CheckWide(titlepic_wide);
  Check_Interpic_Wide = D_CheckWide(interpic_wide);
  Check_Credit_Wide = D_CheckWide(credit_wide);
  Check_Help0_Wide = D_CheckWide(help0_wide);
  Check_Help1_Wide = D_CheckWide(help1_wide);
  Check_Help2_Wide = D_CheckWide(help2_wide);
  Check_Bossback_Wide = D_CheckWide(bossback_wide);
  Check_E1map_Wide = D_CheckWide(e1map_wide);
  Check_E2map_Wide = D_CheckWide(e2map_wide);
  Check_E3map_Wide = D_CheckWide(e3map_wide);
  Check_Victory_Wide = D_CheckWide(victory_wide);
  Check_Bunny1_Wide = D_CheckWide(bunny1_wide);
  Check_Bunny2_Wide = D_CheckWide(bunny2_wide);
  Check_Endpic_Wide = D_CheckWide(endpic_wide);
}