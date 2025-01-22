{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withPython3 = true;
    extraLuaConfig = builtins.readFile ./init.lua;

    extraPackages = with pkgs; [
      # Needed by LuaSnip
      luajitPackages.jsregexp

      # LUA
      lua-language-server
      stylua

      # Nix
      nixd
      fish-lsp
      deadnix
      nixfmt-rfc-style

      # Treesitter
      gcc # Needed for treesitter
      # ^ treesitter

      alejandra
      statix
    ];
  };

  xdg.configFile."nvim/lua" = {
    recursive = true;
    source = ./lua;
  };
}
