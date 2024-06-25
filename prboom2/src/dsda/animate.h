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

int D_CheckAnimate(const char* lump_s, const char* lump_e);
void D_DrawAnimate(const char* lump_s, const char* lump_e);
//void D_DrawAnimateBunny(const char* lump_x, const char* lump_y, const char* lump_s, const char* lump_e);
void M_DrawMenuAnimate(const char* lump_x, const char* lump_y, const char* lump_s, const char* lump_e);

#endif