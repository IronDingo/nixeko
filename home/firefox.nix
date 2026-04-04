{ pkgs, ... }:

# Firefox — declarative settings, search, bookmarks.
# Extensions are NOT managed here (install once via Firefox, sync via Firefox Sync).
# This avoids the NUR dependency and is more stable across rebuilds.

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      # ── Privacy & performance settings ────────────────────────────────────────
      settings = {
        # Privacy
        "privacy.trackingprotection.enabled"                 = true;
        "privacy.trackingprotection.socialtracking.enabled"  = true;
        "privacy.donottrackheader.enabled"                   = true;
        "browser.send_pings"                                 = false;
        "dom.battery.enabled"                                = false;
        "network.cookie.cookieBehavior"                      = 1;

        # Telemetry — all off
        "toolkit.telemetry.enabled"                          = false;
        "toolkit.telemetry.unified"                          = false;
        "toolkit.telemetry.server"                           = "";
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry"                      = false;
        "datareporting.healthreport.uploadEnabled"           = false;
        "datareporting.policy.dataSubmissionEnabled"         = false;

        # UI
        "browser.toolbars.bookmarks.visibility"              = "newtab";
        "browser.tabs.warnOnClose"                           = false;
        "browser.startup.page"                               = 3;
        "browser.newtabpage.enabled"                         = false;
        "browser.startup.homepage"                           = "about:blank";

        # Performance
        "gfx.webrender.all"                                  = true;
        "media.ffmpeg.vaapi.enabled"                         = true;
        "media.hardware-video-decoding.force-enabled"        = true;
      };

      # ── Search engines ─────────────────────────────────────────────────────────
      search = {
        force   = true;
        default = "SearXNG";
        engines = {
          "SearXNG" = {
            urls            = [{ template = "http://localhost:8888/search?q={searchTerms}"; }];
            updateInterval  = 24 * 60 * 60 * 1000;
            definedAliases  = [ "@s" ];
          };
          "Google".metaData.hidden      = true;
          "Bing".metaData.hidden        = true;
          "Amazon.com".metaData.hidden  = true;
          "eBay".metaData.hidden        = true;
        };
      };

      # ── Bookmarks toolbar ─────────────────────────────────────────────────────
      bookmarks = [
        {
          name = "nixeko";
          toolbar = true;
          bookmarks = [
            { name = "SearXNG";          url = "http://localhost:8888"; }
            { name = "Pi-hole";          url = "http://localhost:8080/admin"; }
            { name = "Jellyfin";         url = "http://localhost:8096"; }
            { name = "Proton Mail";      url = "https://mail.proton.me"; }
            { name = "Proton Calendar";  url = "https://calendar.proton.me"; }
            { name = "Claude";           url = "https://claude.ai"; }
            { name = "DeepSeek";         url = "https://chat.deepseek.com"; }
          ];
        }
      ];
    };
  };
}
