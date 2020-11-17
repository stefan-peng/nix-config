{ config, pkgs, ... }:

let 
  hostName = "bebe";
  nixpkgs-master = import ../nixos/nixpkgs-master.nix;
in {
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix

      <nixos-hardware/lenovo/thinkpad>
      <nixos-hardware/lenovo/thinkpad/x1>
      <nixos-hardware/lenovo/thinkpad/x1/7th-gen>
      <home-manager/nixos>

      ../nixos/shell.nix
      ../nixos/quebec.nix
      ../nixos/fonts.nix
      ../nixos/nix.nix
      ../nixos/nix-distributed.nix

      ../nixos/gnome.nix
      ../nixos/tmux.nix

      ../nixos/syncthing.nix
      ../nixos/syncthing-tray.nix
      ../nixos/docker.nix

      ../private-config/caches.nix
    ];

  home-manager.users.srid = (import ../nix/home.nix {
    inherit pkgs config hostName;
  } );

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Allow non-free firmware, such as for intel wifi
  hardware = {
    enableRedistributableFirmware = true;
  };
  # Sound
  sound.enable = true;
  # Fingerprint reader
  services.fwupd.enable = true;
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.xscreensaver.fprintAuth = true;

  networking = {
    hostName = hostName;
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      wifi.scanRandMacAddress = false;
    };
    wireless.networks = ./private-config/wifi.nix;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  # Set up Wireguard
  networking = {
    nat = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [51820];
    };
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.3/24" ];
        listenPort = 51820;
        privateKeyFile = "/home/srid/nix-config/private-config/wireguard/x1c7/private";
        peers = [
          ../nixos/wireguard/peers/facade.nix
          ../nixos/wireguard/peers/p71.nix
        ];
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # google-chrome UI lags on x1c7
    # google-chrome
    chromium

    peek

    mpv
    qmmp  # winamp like

    nixpkgs-master.vscode
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    # Enable touchpad support.
    libinput = {
      enable = true;
      naturalScrolling = true;
    };
  };

  systemd.services = {
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.srid = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" ];
     shell = pkgs.bash;
     packages = with pkgs; [
       slack
     ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
