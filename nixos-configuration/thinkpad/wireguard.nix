{ config, lib, pkgs, ... }:

{
  # Wireguard client
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.2/24" ];
      listenPort = 51820;
      privateKeyFile = "/home/srid/nix-config/private-config/wireguard/bornagain/private";
      peers = [
        { publicKey = "cInHQG7ns2Hvq7HW6kqVGoRXvoZALNZ00pvjH1bPTmM=";
          allowedIPs = [ "10.100.0.1" /* "167.71.82.208" */ ];
          endpoint = "facade.srid.ca:51820";
          persistentKeepalive = 25;
        }
        # pixel slate
        #{ publicKey = "yMuIxno/f/eI5W+P6SsBZ0Ib5s0uhqEo/DB8MdCbryY=";
        #  allowedIPs = [ "10.100.0.3" ];
        #  persistentKeepalive = 25;
        #}
      ];
    };
  };

}
