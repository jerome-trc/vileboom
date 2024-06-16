## COMPLVL Lump

The COMPLVL lump allows for the loading of an exact complevel, without the need for specifying via the parameter `-complevel`.

The order of precedence is highest to lowest: parameter > lump > config. This means that if a complevel is set through a parameter, this will take precedence over the contents of COMPLVL, while COMPLVL will in turn take precedence over whatever is set in the menu as the default compatibility.

### Specification

The COMPLVL lump only has a single value:

`value`

### Values

- `vanilla`
  - Selects complevel 2, 3 and 4, depending on the IWAD loaded, for vanilla compatibility
  - Can be used in conjunction with the GAMEVERS lump to use a specific / rare vanilla complevel (0-4) and/or enabling limit-removing mode.
- `boom`
  - Selects complevel 9, for boom compatibility
- `mbf`
  - Selects complevel 11, for mbf compatibility
- `mbf21`
  - Selects complevel 21 for MBF21 specifications