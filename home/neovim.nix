{ config, pkgs, ... }:

# Neovim — LazyVim powered
# Plugins are downloaded by lazy.nvim on first launch (needs internet).
# LSPs: Python (pyright), Go, Rust, TypeScript.

{
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;
    # LSPs are in packages.nix — available in PATH
  };

  # LazyVim bootstrap — downloads everything on first launch
  home.file.".config/nvim/init.lua".text = ''
    -- nixeko/nvim — LazyVim
    -- First launch installs plugins via lazy.nvim (internet required).

    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
      })
    end
    vim.opt.rtp:prepend(lazypath)

    -- Options
    vim.opt.number         = true
    vim.opt.relativenumber = true
    vim.opt.scrolloff      = 8
    vim.opt.tabstop        = 2
    vim.opt.shiftwidth     = 2
    vim.opt.expandtab      = true
    vim.opt.smartindent    = true
    vim.opt.wrap           = false
    vim.opt.swapfile       = false
    vim.opt.undofile       = true
    vim.opt.termguicolors  = true
    vim.opt.updatetime     = 50
    vim.opt.signcolumn     = "yes"
    vim.opt.clipboard      = "unnamedplus"

    -- LazyVim
    require("lazy").setup({
      spec = {
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        -- Languages
        { import = "lazyvim.plugins.extras.lang.python" },
        { import = "lazyvim.plugins.extras.lang.go" },
        { import = "lazyvim.plugins.extras.lang.rust" },
        { import = "lazyvim.plugins.extras.lang.typescript" },
      },
      defaults  = { lazy = false, version = false },
      checker   = { enabled = true, notify = false },
      install   = { colorscheme = { "tokyonight", "habamax" } },
      performance = {
        rtp = {
          disabled_plugins = {
            "gzip", "matchit", "matchparen", "netrwPlugin",
            "tarPlugin", "tohtml", "tutor", "zipPlugin",
          },
        },
      },
    })
  '';
}
