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
        for font in ${../assets/fonts/satoshi}/*.otf; do
          outpath="$dir/$(basename "$font")"

          # Freeze proportional numerals and alternate t as default glyphs
          pyftfeatfreeze -f 'pnum,ss03' "$font" "$outpath"

          # Strip tabular numerals to prevent apps from overriding proportional numerals
          pyftsubset "$outpath" --output-file="$outpath" --unicodes='*' --layout-features-='tnum'
        done
      '';

  # Use custom Iosevka build
  # Configured using https://typeof.net/Iosevka/customizer
  iosevka = pkgs.iosevka.override {
    set = "";
    privateBuildPlan = ''
      [buildPlans.Iosevka]
      family = "Iosevka"
      spacing = "normal"
      serifs = "sans"
      noCvSs = true
      exportGlyphNames = false
      noLigation = true

      [buildPlans.Iosevka.variants.design]
      one = "base"
      two = "straight-neck-serifless"
      four = "closed-serifless"
      eight = "two-circles"
      zero = "tall-slashed"
      capital-d = "more-rounded-serifless"
      capital-g = "toothless-rounded-serifless-hooked"
      capital-j = "serifless"
      capital-q = "crossing-baseline"
      f = "flat-hook-serifless"
      i = "serifed-flat-tailed"
      l = "serifed-flat-tailed"
      q = "tailed-serifless"
      t = "flat-hook"
      y = "straight-turn-serifless"
      asterisk = "hex-low"
      number-sign = "slanted"
      percent = "rings-continuous-slash"

      [buildPlans.Iosevka.weights.Regular]
      shape = 400
      menu = 400
      css = 400

      [buildPlans.Iosevka.weights.Bold]
      shape = 700
      menu = 700
      css = 700

      [buildPlans.Iosevka.widths.Normal]
      shape = 600
      menu = 5
      css = "normal"

      [buildPlans.Iosevka.slopes.Upright]
      angle = 0
      shape = "upright"
      menu = "upright"
      css = "normal"

      [buildPlans.Iosevka.slopes.Italic]
      angle = 9.4
      shape = "italic"
      menu = "italic"
      css = "italic"
    '';
  };
in
{
  fonts = {
    packages = [
      satoshi
      iosevka
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Satoshi" ];
        monospace = [ "Iosevka" ];
      };
    };
  };
}
