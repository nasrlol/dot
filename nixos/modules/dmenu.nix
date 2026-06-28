
{pkgs, ...}

{
 home.packages = with pkgs; [
    (pkgs.dmenu.overrideAttrs (_: {
      src = ../../suckless/dmenu; 
    }))
  ];
}