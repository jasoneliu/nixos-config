{
  pkgs,
  ...
}: {
  services.swayidle = let 
    display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
    lock = "${pkgs.noctalia-shell}/bin/noctalia-shell ipc call lockScreen lock";
    suspend = "${pkgs.systemd}/bin/systemctl suspend";
  in {
    enable = true;

    # Lock screen before suspend
    events = {
      before-sleep = lock;
      lock = lock;
    };

    timeouts = [
      # Turn off display after 10 minutes
      {
        timeout = 10 * 60;
        command = display "off";
        resumeCommand = display "on";
      }

      # Suspend after 30 minutes
      {
        timeout = 30 * 60;
        command = suspend;
      }
    ];
  };
}
