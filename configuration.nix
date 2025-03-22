{
  config,
  nix-gaming,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  boot.initrd.kernelModules = [
    "i915"
  ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 30;
  };

  # Enable experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings = {
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

  # Enable nh, a bundle of CLI utilities for NixOS
  programs.nh = {
    enable = true;

    # Enable automatic garbage collection.
    clean.enable = true;
    clean.dates = "daily";
    clean.extraArgs = "--keep-since 4d --keep 2";

    flake = "/home/kodehawa/.local/nix-flakes/system";
  };

  networking.hostName = "Napoli"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Santiago";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_CL.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;

  users.users.kodehawa = {
    isNormalUser = true;
    description = "Kodehawa";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment.sessionVariables = {
    PATH = "$PATH:/home/kodehawa/.local/bin";
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    gnome-tweaks
    pipx
    syncthing
    btop
    fastfetch
    vesktop
    cider
    jetbrains.rider
    zulu
    prismlauncher
    iosevka
    ibm-plex
    ptyxis
    winetricks
    libreoffice
    pfetch
    eza
    pciutils
    lm_sensors
    nix-index
    vscode
    gradience
    adw-gtk3
    htop
    cpu-x
    powertop
    nvtopPackages.full
    zram-generator
    git
    ffmpeg
    powercap
    gparted
    qogir-kde
    qogir-theme
    qogir-icon-theme
    cudaPackages.cudatoolkit
    mangohud
    nix-gaming.packages.${pkgs.system}.wine-tkg
    nvidia_oc
    jetbrains.gateway
    discord
    mission-center
    telegram-desktop
    kubectl
    lens
    dbeaver-bin
    speedtest-cli
    (chromium.override {
      commandLineArgs = [
        "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
        "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
        "--enable-features=UseMultiPlaneFormatForHardwareVideo"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
      enableWideVine = true;
    })
  ];

  # Enable nix-ld so we can run stuff like jetbrains-gateway properly
  programs.nix-ld.enable = true;

  # Force electron and chromium applications to run on wayland when Ozone is set.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # This kinda is just default settings but I wanna set them expliitly
  fonts.fontconfig = {
    allowBitmaps = false;
    antialias = true;
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };
    hinting = {
      style = "slight";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka-term
    nerd-fonts.fira-code
    nerd-fonts.fantasque-sans-mono
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code-symbols
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  zramSwap.enable = true;

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    open = false;

    # Enable the Nvidia settings menu accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services = {
    flatpak = {
      enable = true;
    };
    printing = {
      enable = true;
    };
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      displayManager = {
        gdm = {
          enable = true;
        };
      };
      desktopManager = {
        gnome = {
          enable = true;
        };
      };
      xkb = {
        layout = "latam";
        variant = "";
      };
    };
    syncthing = {
      enable = true;
      group = "users";
      user = "kodehawa";
      dataDir = "/home/kodehawa"; # Default folder for new synced folders
      configDir = "/home/kodehawa/.config/syncthing"; # Folder for Syncthing's settings and keys
    };
    asusd = {
      enable = true;
    };
    zram-generator = {
      enable = true;
    };
    openssh = {
      enable = true;
    };
  };

  systemd.services.undervolt = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.kmod ];
    serviceConfig = {
      ExecStart = "${pkgs.undervolt}/bin/undervolt --core -160 --cache -160";
      Type = "oneshot";
    };
  };

  systemd.services.nbfc-linux = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.kmod ];
    serviceConfig = {
      ExecStart = "${pkgs.nbfc-linux}/bin/ec_probe write 0x5e 0xC0";
      Type = "oneshot";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
