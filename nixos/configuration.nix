{
 config, lib, pkgs, ... }:

{
  imports = [ 
      	./hardware-configuration.nix
      	./modules/dmenu.nix
    ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "como"; 

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Brussels";


  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.gdm.enable     = false;
  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.displayManager.startx.enable  = true;

  services.displayManager.defaultSession = "none+xmonad";

  services.xserver.windowManager.xmonad = {
     enable = true;
     enableContribAndExtras = true;
     extraPackages = hp: [ hp.xmonad-contrib hp.xmobar ];
  };


  services.xserver.xkb.layout = "us";
  
  services.pipewire = {
	enable = true;
     	pulse.enable = true;
  };

  services.libinput.enable = true;
  users.users.nasr = {
  	isNormalUser = true;
     	extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     	shell = pkgs.zsh;
     	home = "/home/nasr";
     	packages = with pkgs; [
       		tree
   		fastfetch
   		emacs
   		alacritty
		xmobar
		tmux
		neovim
     ];
   };

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs.git.enable = true;
  programs.lazygit.enable = true;


   environment.systemPackages = with pkgs; [
   			      vis
   			      wget
  ];

  networking.firewall.enable = false;
  system.stateVersion = "26.05"; 
}

