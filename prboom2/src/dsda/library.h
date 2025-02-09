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
//	DSDA Library
//

#ifndef __DSDA_LIBRARY__
#define __DSDA_LIBRARY__

// Define menu animated background
#define doomflat1   (gamemode == shareware ? "NUKAGE1" : "FWATER1")
#define doomflat2   (gamemode == shareware ? "NUKAGE3" : "FWATER4")
#define ravenflat1  (hexen ? "X_005" : "FLTWAWA1")
#define ravenflat2  (hexen ? "X_008" : "FLTWAWA3")
#define aniflat1    (raven ? ravenflat1 : doomflat1)
#define aniflat2    (raven ? ravenflat2 : doomflat2)

// Define standard Doom lumps
#define mskull1     "M_SKULL1"
#define mskull2     "M_SKULL2"
#define mdoom       "M_DOOM"
#define stbar       "STBAR"
#define starms      "STARMS"
#define titlepic    "TITLEPIC"
#define interpic    "INTERPIC"
#define credit      "CREDIT"
#define help0       "HELP"
#define help1       "HELP1"
#define help2       "HELP2"
#define e2victory   "VICTORY2"
#define e4endpic    "ENDPIC"
#define e3bunny1    "PFUB1"
#define e3bunny2    "PFUB2"

#endif
