## GAMEVERS Lump

The GAMEVERS lump can be used only when the COMPLVL lump has the key of `vanilla`, to specify an exact vanilla complevel.
GAMEVERS will not be read if COMPLVL is absent or if COMPLVL has any other key than `vanilla`.

### Specification

The GAMEVERS lump has a key and a value:

`key value`

The `key` defines the specific complevel, while the `value` defines limit-removing or not. The `value` can be ommited to run in normal mode.

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

### Values

- `limit`
  - Runs complevel under limit-removing mode. Removes overflow errors and emulation. Omit to run in normal mode. (Note this can be overriden by parameters).