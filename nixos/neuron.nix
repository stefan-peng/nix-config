{ description, notesDir, port, ... }:

# To read log output, I recommend:
#   journalctl -o cat -fu $description
let 
  neuron = import ../dep/neuron { };
in {
  inherit description;
  enable = true;
  wantedBy = [ "default.target" ];
  after = [ "network-online.target" ];
  environment = { };
  serviceConfig = {
    WorkingDirectory = "${notesDir}";
    ExecStart = "${neuron}/bin/neuron gen -ws 127.0.0.1:${toString port}";
    Restart = "always";
    PrivateTmp = true;
    User = "srid";
  };
}

