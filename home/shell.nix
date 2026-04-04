{ pkgs, ... }:

{
  # ── Git ───────────────────────────────────────────────────────────────────────

  programs.git = {
    enable = true;
    userName = "your-github-username";   # CHANGE ME
    userEmail = "you@example.com";       # CHANGE ME
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # ── Bash ──────────────────────────────────────────────────────────────────────

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ls  = "eza --icons";
      ll  = "eza -la --icons";
      lt  = "eza --tree --icons";
      cat = "bat";
      cd  = "z";
    };
    initExtra = ''
      eval "$(zoxide init bash)"
      eval "$(starship init bash)"
      export PATH="$HOME/Projects/nixeko/bin:$HOME/.local/bin:$PATH"
    '';
  };

  # ── Starship ──────────────────────────────────────────────────────────────────

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      format = "$directory$git_branch$git_status$character";
      character = {
        success_symbol = "[▸](green)";
        error_symbol   = "[▸](red)";
      };
      directory = {
        truncation_length = 3;
        style = "cyan bold";
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
        style  = "yellow";
        symbol = "⎇ ";
      };
      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style  = "red";
      };
    };
  };

  # ── Alacritty ─────────────────────────────────────────────────────────────────

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding    = { x = 12; y = 12; };
        decorations = "None";
        opacity    = 0.95;
      };
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size = 13.0;
      };
      cursor.style.shape = "Beam";
    };
  };

  # ── Shell tools ───────────────────────────────────────────────────────────────

  programs.fzf.enable    = true;
  programs.zoxide.enable = true;
  programs.lazygit.enable = true;
}
