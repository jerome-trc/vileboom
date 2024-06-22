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
//	DSDA Small Berserk HUD Component
//

#ifndef __DSDA_HUD_COMPONENT_SML_BERSERK__
#define __DSDA_HUD_COMPONENT_SML_BERSERK__

void dsda_InitSmlBerserkHC(int x_offset, int y_offset, int vpt_flags, int* args, int arg_count, void** data);
void dsda_UpdateSmlBerserkHC(void* data);
void dsda_DrawSmlBerserkHC(void* data);

#endif
