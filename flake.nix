{
  description = "top 29 quintillion cheese";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=25.11";
  };

  outputs = inputs @ { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    devShells."${system}".default = pkgs.mkShell {
      packages = with pkgs; [ ffmpeg bc python3 ];
    };
  };
}
