{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.nvim.dag) entryAnywhere;
  inherit (lib.strings) optionalString;
  inherit (lib.trivial) boolToString;

  cfg = config.vim.autopairs;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = ["nvim-autopairs"];

    vim.luaConfigRC.autopairs = entryAnywhere ''
      require("nvim-autopairs").setup{}
      ${optionalString (config.vim.autocomplete.type == "nvim-compe") ''
        -- nvim-compe integration
        require('nvim-autopairs.completion.compe').setup({
          map_cr = ${boolToString cfg.nvim-compe.map_cr},
          map_complete = ${boolToString cfg.nvim-compe.map_complete},
          auto_select = ${boolToString cfg.nvim-compe.auto_select},
        })
      ''}
    '';
  };
}
