{
  pkgs,
  ...
}:
let
  # Use Satoshi with proportional numerals and alternate t (with tail)
  satoshi =
    pkgs.runCommandLocal "satoshi"
      {
        nativeBuildInputs = [
          pkgs.python3Packages.opentype-feature-freezer
        ];
      }
      ''
        dir="$out/share/fonts/opentype/satoshi"
        mkdir -p "$dir"
        for font in ${../fonts/satoshi}/*.otf; do
          outpath="$dir/$(basename "$font")"

          # Freeze proportional numerals and alternate t as default glyphs
          pyftfeatfreeze -f 'pnum,ss03' "$font" "$outpath"

          # Strip tabular numerals to prevent apps from overriding proportional numerals
          pyftsubset "$outpath" --output-file="$outpath" --unicodes='*' --layout-features-='tnum'
        done
      '';
in
{
  fonts = {
    packages = [ satoshi ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Satoshi" ];
      };
    };
  };
}
