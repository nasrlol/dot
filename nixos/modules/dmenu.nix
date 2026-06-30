{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    (pkgs.dmenu.overrideAttrs (_: {
      src = ../../suckless/dmenu; 
    }))
  ];
}