# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

rec {

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8c448842-faa8-4f88-bad3-152b9ba5e386";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/57ad8b11-4cee-472b-9ad2-db77175e5277";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/1541c54c-34e7-42c5-abc1-a9d179538dbd"; }
    ];

  nix.maxJobs = 4;
  nix.extraOptions = ''
    build-cores = 4
  '';

  hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.luks.devices = [
    {
      name = "rootfs"; device="/dev/sda3"; preLVM = true; allowDiscards = true;
    }
  ];
  
  boot.extraModulePackages = [ config.boot.kernelPackages.tp_smapi ];
  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "usb_storage" "aesni-intel" "fbcon" "i915" ];
  boot.kernelModules = [ "kvm-intel" "tp_smapi" "msr"];
  boot.vesa = false;

  boot.kernelPackages = pkgs.linuxPackages_4_0;
    
  boot.blacklistedKernelModules = [ "pcspkr" "snd_pcsp" ];
  boot.extraModprobeConfig = ''
   options thinkpad_acpi fan_control=1
  '';

  networking.hostName = "nixos"; # Define your hostname.
  networking.hostId = "817fde0d";
  networking.wireless.enable = false; #disable when using networkmanager
  networking.firewall.enable = true;  
  networking.firewall.allowedTCPPorts = [ 80 443 ];


  networking.networkmanager.enable = true;
  services.dbus.enable = true;
  services.thinkfan.enable = true;
  services.virtualboxHost.enable = true;

nixpkgs.config = {

    allowUnfree = true;

    firefox = {
     enableGoogleTalkPlugin = true;
    };

    chromium = {
     enablePepperFlash = true; # Chromium removed support for Mozilla (NPAPI) plugins so Adobe Flash no longer works 
     enablePepperPDF = true;
    };

  virtualbox.enableExtensionPack = true;
  };


  services.udev.extraRules = ''
   SUBSYSTEM=="firmware", ACTION="add", ATTR{loading}="-1"
  '';

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "uk";
    defaultLocale = "en_US.UTF-8";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    bash
    polkit_gnome
    iwlwifi
    networkmanager
    networkmanagerapplet
    firmwareLinuxNonfree
    chromium
    firefoxWrapper
    transmission
    pkgs.transmission_gtk
    vlc
    tmux
    pkgs.microcode2ucode
    pkgs.nox
    pkgs.vimPlugins.Gist
    pkgs.vimPlugins.Gundo
    pkgs.vimPlugins.Syntastic
    pkgs.vimPlugins.Tagbar
    pkgs.vimPlugins.The_NERD_Commenter
    pkgs.vimPlugins.The_NERD_tree
    pkgs.vimPlugins.youcompleteme
    pkgs.vimPlugins.vim-airline
    pkgs.vimPlugins.ctrlp
    pkgs.vimPlugins.vim-easy-align
    pkgs.vimPlugins.easymotion
    pkgs.vimPlugins.eighties
    pkgs.vimPlugins.fugitive
    pkgs.vimPlugins.gitgutter
    pkgs.vimPlugins.golang
    pkgs.vimPlugins.ipython
    pkgs.vimPlugins.lushtags
    pkgs.vimPlugins.pathogen
    pkgs.vimPlugins.taglist
    pkgs.vimPlugins.tmux-navigator
    pkgs.vimPlugins.tslime
    pkgs.vimPlugins.vim-addon-nix
    pkgs.vimPlugins.vim-addon-sql
    pkgs.vimPlugins.vim-addon-async
    pkgs.vimPlugins.vim-snippets
    pkgs.firefox
    busybox
    dmenu2
    awesome
    hibernate
    acpi
    acl
    afuse
    fuse
    anonymousPro
    ansible
    antiword
    arduino
    arduino-core
    aria2
    argyllcms
    asciidoc
    asciidoc-full
    at
    aspell
    atftp
    atop
    attic
    attr
    augeas
    aumix
    autoconf
    autofs5
    autossh
    aws
    awscli
    banner
    bashCompletion
    bc
    beep
    bindfs
    binutils
    blueman
    bluez
    bsdiff
    btar
    btrfsProgs
    buildbot
    buildbot-slave
    bup
    bzip2
    cabextract
    pkgs.fabric
    vagrant
    libffi
    ruby
    rubygems
    pkgs.bundler
    pkgs.gnumake40
    pkgs.gcc49
    pkgs.gtk # To get GTK+'s themes.
    pkgs.hicolor_icon_theme
    pkgs.tango-icon-theme
    pkgs.shared_mime_info
    pkgs.gnome.gnomeicontheme
    pkgs.desktop_file_utils
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "gb";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkbModel = "thinkpad60";

  time.timeZone = "Europe/London";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  services.udisks2.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  users.extraUsers.azul = {
   isNormalUser = true;
   home = "/home/azul";
   description = "Azul";
   uid = 15626;
   extraGroups = [ "wheel" "networkmanager" "vboxusers" ];
   openssh.authorizedKeys.keys = [];
   password = "$6$xpMf1vRW$De0pGnX5213Y8C0caspD2Q4AHcRxWOKpgbWmD35iCJaRk0QrGyWkC57sx4dUZugq/rBiX3mkQAgKFZ8i8CW.V/:16616";
   };

environment.pathsToLink =
      [ "/share/xfce4" "/share/themes" "/share/mime" "/share/desktop-directories" "/share/gtksourceview-2.0" ];

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    extraFonts = with pkgs; [
#       andagii
#       anonymousPro
#       arkpandora_ttf
#       bakoma_ttf
#       cantarell_fonts
       corefonts
#      clearlyU
#      cm_unicode
       dejavu_fonts
#       freefont_ttf
#       gentium
       inconsolata
       liberation_ttf
#       libertine
#       lmodern
#       mph_2b_damase
#       oldstandard
#       theano
#       tempora_lgc
       terminus_font
       ttf_bitstream_vera
#       ucsFonts
#       unifont
       vistafonts
#       wqy_zenhei
    ];
  };

hardware.pulseaudio.enable = true;

}
