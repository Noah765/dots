{
  pkgs,
  osConfig,
  lib,
  options,
  config,
  ...
}:
with lib;
let
  cfg = config.hyprland;
in
{
  options.hyprland = {
    enable = mkEnableOption "hyprland";
    settings = options.wayland.windowManager.hyprland.settings;
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.hyprland.enable;
        message = "The NixOS hyprland module is required for the home manager hyprland module.";
      }
    ];

    home.sessionVariables.NIXOS_OZONE_WL = 1;

    wayland.windowManager.hyprland = {
      enable = true;

      plugins = [ pkgs.hyprlandPlugins.hy3 ];

      settings = {
        general = {
          gaps_in = 4;
          gaps_out = 5;
          layout = "hy3";
          no_focus_fallback = true;
          resize_on_border = true;
          # TODO allow_tearing
        };

        decoration = {
          rounding = 20;
          # TODO shadows
          # TODO dimming
          # TODO blur
        };

        animations = { }; # TODO

        input = {
          repeat_rate = 35;
          repeat_delay = 250;
          special_fallthrough = true;
        };

        # TODO groups (configure the layout first)

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
          # TODO vrr
          disable_autoreload = true;
          # TODO window swallowing
          focus_on_activate = true;
          new_window_takes_over_fullscreen = 2;
          # TODO initial_workspace_tracking
        };

        binds = {
          scroll_event_delay = 0;
          # TODO workspace settings
          # TODO focus_preferred_method
        };

        cursor = {
          # TODO persistent_warps
          # TODO warp_on_change_workspace
        };

        monitor = [
          ", highres, auto, 1"
          "Unknown-1, disable"
        ];

        plugin.hy3 = {
          # TODO
        };

        bindm = [
          "Super, mouse:272, movewindow"
          "Super, mouse:273, resizewindow"
        ];

        bind = [
          "Super, Up, hy3:movefocus, u"
          "Super, Right, hy3:movefocus, r"
          "Super, Down, hy3:movefocus, d"
          "Super, Left, hy3:movefocus, l"

          "Super+Shift, Up, hy3:movewindow, u"
          "Super+Shift, Right, hy3:movewindow, r"
          "Super+Shift, Down, hy3:movewindow, d"
          "Super+Shift, Left, hy3:movewindow, l"

          "Super, Q, hy3:killactive"

          "Super, T, exec, kitty"
        ];
      } // cfg.settings;
    };
  };
}
