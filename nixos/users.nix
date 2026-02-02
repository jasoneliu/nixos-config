{ 
  inputs,
  ...
}: {
  users.users.jason = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jason = import ../home-manager;
  };
}
