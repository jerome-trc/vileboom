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

#include "base.h"

#include "sml_berserk.h"

#define PATCH_DELTA_X 14
#define PATCH_DELTA 10
#define PATCH_SPACING 2
#define PATCH_VERTICAL_SPACING 2

typedef struct {
    dsda_patch_component_t component;
} local_component_t;

static local_component_t* local;

static int strength_lump;
static int patch_delta_x;
static int patch_spacing;

static const char* dsda_BerserkName(player_t* player) {
    if (player->powers[pw_strength])
        if (gamemission == chex) { return "CHXPSTR"; }
        else if (bfgedition) { return "STFPSTR2"; }
        else { return "STFPSTR"; }
    else
        return NULL;
}

void drawBerserkIcon(player_t* player, int* x, int* y, const char* (*hasBerserk)(player_t*)) {
    const char* name;

    name = hasBerserk(player);

    if (name)
        V_DrawNamePatch(*x, *y, FG, name, CR_DEFAULT, local->component.vpt);
}

static void dsda_DrawComponent(void) {
    player_t* player;
    int x, y;

    player = &players[displayplayer];

    x = local->component.x;
    y = local->component.y;
    if (!raven)
        drawBerserkIcon(player, &x, &y, dsda_BerserkName);
    //V_DrawNumPatch(x, y, FG, strength_lump, CR_DEFAULT, local->component.vpt);
    //x += 4;
}

void dsda_InitSmlBerserkHC(int x_offset, int y_offset, int vpt, int* args, int arg_count, void** data) {
    *data = Z_Calloc(1, sizeof(local_component_t));
    local = *data;

    //hide_lump = return;
    //strength_lump = R_NumPatchForSpriteIndex(SML_PSTR);
    //strength_lump = W_CheckNumForName("SML_PSTR");
    //patch_delta_x = 14;
    //patch_vertical_spacing = 2;
    //patch_spacing = 2;
    //patch_spacing += R_NumPatchWidth(strength_lump);
    dsda_InitPatchHC(&local->component, x_offset, y_offset, vpt);
}

void dsda_UpdateSmlBerserkHC(void* data) {
    local = data;
}

void dsda_DrawSmlBerserkHC(void* data) {
    local = data;

    dsda_DrawComponent();
}
