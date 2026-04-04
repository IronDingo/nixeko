{ ... }:

{
  # ── Default applications ───────────────────────────────────────────────────────
  # xdg-open uses these. Change to whatever you prefer.

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Web
      "text/html"                = "firefox.desktop";
      "x-scheme-handler/http"    = "firefox.desktop";
      "x-scheme-handler/https"   = "firefox.desktop";

      # Files
      "inode/directory"          = "org.gnome.Nautilus.desktop";

      # Images
      "image/png"                = "org.gnome.eog.desktop";
      "image/jpeg"               = "org.gnome.eog.desktop";
      "image/gif"                = "org.gnome.eog.desktop";
      "image/webp"               = "org.gnome.eog.desktop";
      "image/svg+xml"            = "org.gnome.eog.desktop";

      # Video
      "video/mp4"                = "mpv.desktop";
      "video/mkv"                = "mpv.desktop";
      "video/webm"               = "mpv.desktop";
      "video/x-matroska"         = "mpv.desktop";

      # Audio
      "audio/mpeg"               = "mpv.desktop";
      "audio/flac"               = "mpv.desktop";
      "audio/ogg"                = "mpv.desktop";

      # Documents
      "application/pdf"          = "firefox.desktop";
      "application/zip"          = "org.gnome.FileRoller.desktop";
      "application/x-tar"        = "org.gnome.FileRoller.desktop";

      # Text / code
      "text/plain"               = "nvim.desktop";
      "text/markdown"            = "nvim.desktop";
    };
  };
}
