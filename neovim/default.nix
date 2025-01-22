{ pkgs, ... }:

{
  programs.neovim = {
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
      nixfmt-rfc-style

      # Treesitter
      gcc # Needed for treesitter
    ];
  };

  xdg.configFile."nvim/lua" = {
    recursive = true;
    source = ./lua;
  };
}
