{
  config,
  pkgs,
  ...
}:

let
  satoshi = pkgs.runCommandLocal "satoshi" { } ''
    mkdir -p $out/share/fonts/opentype
    cp -r ${../fonts/satoshi} $out/share/fonts/opentype/satoshi
  '';
in
{
  fonts = {
    packages = [
      satoshi
    ];

    fontconfig.defaultFonts = {
      sansSerif = [
        "Satoshi"
      ];
    };
  };
}
