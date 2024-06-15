## COMPLVL Lump

The COMPLVL lump allows for the loading of an exact complevel, without the need for specifying via the parameter `-complevel`.

The order of precedence is highest to lowest: parameter > lump > config. This means that if a complevel is set through a parameter, this will take precedence over the contents of COMPLVL, while COMPLVL will in turn take precedence over whatever is set in the menu as the default compatibility.

### Specification

The COMPLVL lump only has a single key:

`key`

### Keys

- `vanilla`
  - Selects complevel 2, 3 and 4, depending on the IWAD loaded, for vanilla compatibility
  - Can be used in conjunction with the GAMEVERS lump to use a specific or rare vanilla complevel (0,1)
- `boom`
  - Selects complevel 9, for boom compatibility
- `mbf`
  - Selects complevel 11, for mbf compatibility
- `mbf21`
  - Selects complevel 21 for MBF21 specifications



## GAMEVERS Lump

The GAMEVERS lump can be used only when the COMPLVL lump has the key of `vanilla`, to specify an exact vanilla complevel.
GAMEVERS will not be read if COMPLVL is absent or if COMPLVL has any other key than `vanilla`.

### Specification

The GAMEVERS lump only has a single key:

`key`

### Keys

- `1.2`
  - Selects complevel 0, for Doom 1.2 compatibility.
- `1.666`
  - Selects complevel 1, for Doom 1.666 compatibility.
- `1.9`
  - Selects complevel 2, for Doom (pre-ultimate) / Doom 2 compatibility.
- `ultimate`
  - Selects complevel 3, for Ultimate Doom compatibility.
- `final`
  - Selects complevel 4, for Final Doom (Plutonia, TNT) compatibility.
