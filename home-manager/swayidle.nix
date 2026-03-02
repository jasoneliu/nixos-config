{
  pkgs,
  ...
}: {
  services.swayidle = let 
    lock = "${pkgs.noctalia-shell}/bin/noctalia-shell ipc call lockScreen lock";
  in {
    enable = true;

    # Lock screen before suspend
    events = {
      before-sleep = lock;
      lock = lock;
    };
  };
}
