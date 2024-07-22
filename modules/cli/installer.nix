{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.cli.installer;
in {
  options.cli.installer.enable = mkEnableOption "scripts for building, testing and writing the installer to a USB";

  config.hm.home.packages = mkIf cfg.enable [
    (pkgs.writeShellScriptBin "build-installer" ''
      set -euo pipefail

      bold=$'\033[1m'
      normal=$'\033[0m'

      echo "Your installer NixOS configuration must be located at $bold/etc/nixos#iso$normal for this script to work"

      while true; do
        read -rn 1 -p 'Do you want to continue? ' result
        case $result in
          [Yy] ) break;;
          [Nn] ) exit;;
          * ) echo;;
        esac
      done

      pushd /etc/nixos
      nom build /etc/nixos#nixosConfigurations.iso.config.system.build.isoImage
      popd

      echo "The installer ISO has been successfully created and is located in $bold/etc/nixos/result/iso$normal!"
    '')
    (pkgs.writeShellScriptBin "test-installer" ''
      set -euo pipefail

      bold=$'\033[1m'
      normal=$'\033[0m'

      echo "Your installer ISO image must be located in $bold/etc/nixos/result/iso$normal for this script to work"

      while true; do
        read -rn 1 -p 'Do you want to continue? ' result
        case $result in
          [Yy] ) break;;
          [Nn] ) exit;;
          * ) echo;;
        esac
      done

      nom shell qemu -c qemu-system-x86_64 -enable-kvm -m 2G -bios ${pkgs.OVMF.fd}/FV/OVMF.fd -cdrom /etc/nixos/result/iso/nixos-*.iso
    '')
    (pkgs.writeShellScriptBin "write-installer" ''
      set -euo pipefail

      bold=$'\033[1m'
      red=$'\033[1;31m'
      normal=$'\033[0m'

      echo "Your installer ISO image must be located in $bold/etc/nixos/result/iso$normal for this script to work"

      while true; do
        read -rn 1 -p 'Do you want to continue? ' result
        case $result in
          [Yy] ) break;;
          [Nn] ) exit;;
          * ) echo;;
        esac
      done

      disk=$(lsblk -dno name | fzf --border --border-label 'Disk selection' --prompt 'Disk> ' --preview 'lsblk /dev/{}')

      echo -e "\nOverwriting a disk can cause the disk's contents to be ''${red}lost forever$normal!"
      while true; do
        read -rn 1 -p "Do you wish to overwrite the disk $bold$disk$normal? " result
        case $result in
          [Yy] ) break;;
          [Nn] ) exit;;
          * ) echo;;
        esac
      done

      echo $'\nUnmounting the disk...'
      sudo umount /dev/$disk* || true

      echo 'Writing...'
      sudo dd bs=4M conv=fsync oflag=direct status=progress if=/etc/nixos/result/iso/nixos-*.iso of=/dev/$disk

      echo -e "\nThe installer ISO has been successfully written to $bold$disk$normal!"
    '')
  ];
}