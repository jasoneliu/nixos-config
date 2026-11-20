{
  inputs,
  pkgs,
  self,
  ...
}:
{
  users.users.jason = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs self; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jason = import "${self}/home-manager";
  };
}
