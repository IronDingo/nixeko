{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      # ── Extensions ────────────────────────────────────────────────────────────
      # Install via nur — add/remove as desired
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        onepassword-password-manager
        sponsorblock
        return-youtube-dislikes
      ];

      # ── Hardened settings ─────────────────────────────────────────────────────
      settings = {
        # Privacy
        "privacy.trackingprotection.enabled"              = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.donottrackheader.enabled"                = true;
        "browser.send_pings"                              = false;
        "dom.battery.enabled"                             = false;
        "network.cookie.cookieBehavior"                   = 1;

        # Telemetry — all off
        "toolkit.telemetry.enabled"                       = false;
        "toolkit.telemetry.unified"                       = false;
        "toolkit.telemetry.server"                        = "";
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry"                   = false;
        "datareporting.healthreport.uploadEnabled"         = false;
        "datareporting.policy.dataSubmissionEnabled"       = false;

        # UI
        "browser.toolbars.bookmarks.visibility"           = "never";
        "browser.tabs.warnOnClose"                        = false;
        "browser.startup.page"                            = 3;  # restore last session
        "browser.newtabpage.enabled"                      = false;
        "browser.startup.homepage"                        = "about:blank";

        # Performance
        "gfx.webrender.all"                               = true;
        "media.ffmpeg.vaapi.enabled"                      = true;  # hardware video decode
        "media.hardware-video-decoding.force-enabled"     = true;

        # Search — use SearXNG
        "browser.search.defaultenginename"                = "SearXNG";
        "browser.urlbar.placeholderName"                  = "SearXNG";
      };

      # ── Search engines ─────────────────────────────────────────────────────────
      search = {
        force = true;
        default = "SearXNG";
        engines = {
          "SearXNG" = {
            urls = [{ template = "http://localhost:8888/search?q={searchTerms}"; }];
            iconUpdateURL = "http://localhost:8888/static/themes/simple/img/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@s" ];
          };
          "Google".metaData.hidden = true;
          "Bing".metaData.hidden   = true;
          "Amazon.com".metaData.hidden = true;
          "eBay".metaData.hidden   = true;
        };
      };

      # ── Bookmarks ─────────────────────────────────────────────────────────────
      bookmarks = [
        {
          name = "nixeko";
          toolbar = true;
          bookmarks = [
            { name = "SearXNG";        url = "http://localhost:8888"; }
            { name = "Pi-hole";        url = "http://localhost:8080/admin"; }
            { name = "Jellyfin";       url = "http://localhost:8096"; }
            { name = "Proton Mail";    url = "https://mail.proton.me"; }
            { name = "Proton Calendar"; url = "https://calendar.proton.me"; }
            { name = "Claude";         url = "https://claude.ai"; }
            { name = "DeepSeek";       url = "https://chat.deepseek.com"; }
          ];
        }
      ];
    };
  };
}
