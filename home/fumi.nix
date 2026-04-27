{ pkgs, ... }:

import ./default.nix {
  inherit pkgs;
  username = "fumi";
  gitName = "fumi";
  gitEmail = "expugnatiomundi@gmail.com";
}
