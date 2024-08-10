## Limit-Removing

The term "limit-removing" has been used in the Doom Community for over a decade, and yet there hasn't been a definition ascribed to it.

*Nyan Doom* strives to define "limit-removing" as a standard (similar to a complevel) for the benefit of mappers, players, and speedrunners. 

### Specification

"Limit-Removing" is a Vanilla complevel that removes the all vanilla overflows. "Vanilla" refers to `complevels 0-4`.

When playing/recording demos or just playing casual in "Limit-Removing" mode, the following overflows and warnings are disabled:

- Spechits Overflow
- Reject Overflow
- Intercepts Overflow
- Donut Overflow
- Missing Backside Overflow

Note that `Boom` / `MBF` / `MBF21` features are ***NOT*** supported when running in "Limit-Removing" *(exceptions being sky transfers, music changes, and other non-demo breaking features)*

### Parameter
- `-complevel #r`
  - The `#` can be `0-4` for vanilla complevels. The `r` is short for "removed"
  - Example: `-complevel 0r`, `-complevel 4r`

### Autoload via Lumps
"Limit-Removing" can also be automatically toggled via lumps placed in a wad. Note that Parameters will overwrite the following lumps.
- The [`COMPLVL`](complvl.md) lump must use have the value of `limit-removing`
- The [`GAMEVERS`](gamevers.md) lump can then specify an exact vanilla complevel if needed

### Final Notes
Please note that the order of precedence is highest to lowest: parameter > lump > config.

This means that if a complevel and/or "limit-removing" is (or is not) set through a parameter, that will take precedence over the contents of `COMPLVL` and `GAMEVERS`.

### Example (Precedence)

If a wad is loaded with the parameters `-complevel 2`, and has `COMPLVL` with the value of `limit-removing`, then the wad will be loaded with complevel 2 without "limit-removing" since the parameter `-complevel 2` does not specify "limit-removing".