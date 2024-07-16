{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.anyrun;
in
{
  inputs.anyrun.url = "github:anyrun-org/anyrun";

  hmImports = [ inputs.anyrun.homeManagerModules.default ];

  options.anyrun.enable = mkEnableOption "docs";

  config.hm.programs.anyrun = mkIf cfg.enable {
    enable = true;

    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        rink
        shell
      ];
      y.absolute = 30;
      width.fraction = 0.3;
      hidePluginInfo = true;
      closeOnClick = true;
    };

    extraCss = ''
      #window {
        background: transparent;
        /*font-size: 12pt;*/
      }

      list#main {
        margin-top: 0.5rem;
        /*border: 1.5px solid @accent_color;*/
        /*border-radius: 6px;
        border: 1px solid rgba(0, 0, 0, 0);
        outline: 1px dashed rgba(213, 196, 161, 0.3);
        outline-offset: -3px;

        background-color: transparent;
        padding-left: 8px;
        padding-right: 8px;*/

        /*box-shadow: 0 0 0 1px rgba(131, 165, 152, 0.5);*/
        border: 2px solid alpha(@accent_color, 0.5);
        border-radius: 6px;

        /*outline: 10px solid red;*/
        /*border: 2px solid alpha(@accent_color, 0.3);*/
      }

      /*
      #match.activatable {
          border-radius: 16px;
          padding: 0.3rem 0.9rem;
          margin-top: 0.01rem;
      }
      #match.activatable:first-child {
          margin-top: 0.0rem;
      }
      #match.activatable:last-child {
          margin-bottom: 0.6rem;
      }

      #entry {
          border: 1px solid #0b0f10;
          border-radius: 16px;
          margin: 0.5rem;
          padding: 0.3rem 1rem;
      }

      list > #plugin {
          margin: 0 0.3rem;
      }
      list > #plugin:first-child {
          margin-top: 0.3rem;
      }
      list > #plugin:last-child {
          margin-bottom: 0.3rem;
      }
      */
    '';
  };
}
