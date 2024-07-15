{ lib, ... }:
with lib;
{
  imports = [
    ./core
    ./zsh.nix
    ./localization.nix
    ./docs.nix
    ./hyprland.nix
    ./stylix.nix
    ./programs
  ];

  os.system.stateVersion = "24.11";
  hm.home.stateVersion = "24.11";

  hmUsername = "noah";

  zsh.enable = mkDefault true;
  localization.enable = mkDefault true;
  docs.enable = mkDefault true;
}
