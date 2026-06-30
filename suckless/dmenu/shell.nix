{pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {

 buildInputs = with pkgs; [
  
    gcc
    pkg-config
    xorg.libX11
    xorg.libXinerama
    xorg.libXft

    freetype
    fontconfig
 ];
}
