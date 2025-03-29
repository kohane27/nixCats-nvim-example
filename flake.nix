{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesn't have an extra build step.
    # Then you should name it "plugins-something"

    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };

    # NOTE: If input as plugins-hlargs, add it with `pkgs.neovimPlugins.hlargs` (Do not add `-nvim`)
    "plugins-hlargs" = {
      url = "github:m-demare/hlargs.nvim";
      flake = false;
    };

    "plugins-nvim-tree-preview" = {
      url = "github:b0o/nvim-tree-preview.lua";
      flake = false;
    };

    "plugins-vim-caser" = {
      url = "github:arthurxavierx/vim-caser";
      flake = false;
    };

    "plugins-log-highlight" = {
      url = "github:fei6409/log-highlight.nvim";
      flake = false;
    };

    "plugins-reticle" = {
      url = "github:tummetott/reticle.nvim";
      flake = false;
    };

    "plugins-telescope-egrepify" = {
      url = "github:fdschmidt93/telescope-egrepify.nvim";
      flake = false;
    };

    "plugins-nap" = {
      url = "github:liangxianzhe/nap.nvim";
      flake = false;
    };

    "plugins-incline" = {
      url = "github:b0o/incline.nvim";
      flake = false;
    };

    "plugins-code_runner" = {
      url = "github:CRAG666/code_runner.nvim";
      flake = false;
    };

    "plugins-nvim-recorder" = {
      url = "github:chrisgrieser/nvim-recorder";
      flake = false;
    };

    "plugins-cutlass" = {
      url = "github:gbprod/cutlass.nvim";
      flake = false;
    };

    "plugins-stay-in-place" = {
      url = "github:gbprod/stay-in-place.nvim";
      flake = false;
    };

    # NOTE: codecompanion-nvim is available but I need latest
    "plugins-codecompanion" = {
      url = "github:olimorris/codecompanion.nvim";
      flake = false;
    };

    "plugins-jq-playground" = {
      url = "github:yochem/jq-playground.nvim";
      flake = false;
    };

  };

  # see :help nixCats.flake.outputs
  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (inputs.nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      # the following extra_pkg_config contains any values
      # which you want to pass to the config set of nixpkgs
      # import nixpkgs { config = extra_pkg_config; inherit system; }
      # will not apply to module imports
      # as that will have your system values
      extra_pkg_config = { allowUnfree = true; };
      # System variables get resolved within the builder itself,
      # and then passed to your # categoryDefinitions and packageDefinitions
      # This allows you to use `${pkgs.system}`

      # sometimes our overlays require a ${system} to access the overlay.
      # Your dependencyOverlays can either be lists
      # in a set of ${system}, or simply a list.
      # the nixCats builder function will accept either.
      # see :help nixCats.flake.outputs.overlays
      dependencyOverlays = # (import ./overlays inputs) ++
        [
          # This overlay grabs all the inputs named in the format
          # `plugins-<pluginName>`
          # Once we add this overlay to our nixpkgs, we are able to
          # use `pkgs.neovimPlugins`, which is a set of our plugins.
          (utils.standardPluginOverlay inputs)
          # add any other flake overlays here.

          # when other people mess up their overlays by wrapping them with system,
          # you may instead call this function on their overlay.
          # it will check if it has the system in the set, and if so return the desired overlay
          # (utils.fixSystemizedOverlay inputs.codeium.overlays
          #   (system: inputs.codeium.overlays.${system}.default)
          # )
        ];

      # :help nixCats.flake.outputs.categories
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions = { pkgs, settings, categories, extra, name
        , mkNvimPlugin, ... }@packageDef: {
          # to define and use a new category, add a new list to a set here,
          # and include `categoryname = true;` in `packageDefinitions.nvim.categories`
          # NOTE: :help nixCats.flake.outputs.packageDefinitions

          # dependencies available at RUN TIME for plugins.
          # Will be available to PATH within neovim terminal including LSPs
          lspsAndRuntimeDeps = with pkgs; {
            runtime = [
              nodePackages_latest.typescript
              universal-ctags
              stdenv.cc.cc
              fd
              fzf
              zoxide
              gnused
              gnugrep
              ripgrep
              jq
              gojq
              jqp
            ];

            lsp = [
              lua-language-server
              vscode-langservers-extracted
              nodePackages_latest.typescript-language-server
              nodePackages_latest.yaml-language-server
              nodePackages_latest.bash-language-server
              nodePackages_latest.dockerfile-language-server-nodejs

              # sql-language-server
              (pkgs.fetchFromGitHub {
                owner = "joe-re";
                repo = "sql-language-server";
                rev = "release";
                sha256 = "A73coX1zS5PPXGwEgbLcBsg3lvJD1IXiEiyKX68620w=";
              })

              nixd
              terraform-ls
              emmet-ls
              docker-ls
              lemminx
              pyright
              ruff
            ];

            tools = [
              nodePackages_latest.prettier
              nodePackages_latest.eslint # instead of `tsserver` for better linting

              stylua
              lua5_1
              luarocks
              selene

              nix-doc
              nixfmt-classic
              shellcheck
              shellharden
              shfmt

              nodePackages_latest.sql-formatter
              treefmt
              rustfmt
              markdownlint-cli
              terraform
            ];
          };

          startupPlugins = {
            startup = with pkgs.vimPlugins; {
              lazy = [ lze ];
              colorscheme = [ kanagawa-nvim ];
              lib = [
                vim-repeat
                plenary-nvim
                dressing-nvim
                nui-nvim
                nvim-web-devicons
                nvim-nio
              ];
              lsp = [ SchemaStore-nvim ];
            };
            # You can retreive information from package packageDefinitions
            # :help nixCats.flake.outputs.categoryDefinitions.scheme
          };

          # NOTE: `:NixCats pawsible` to get the name packadd expects
          optionalPlugins = {
            optional = {
              cmp = with pkgs.vimPlugins; [
                nvim-cmp
                luasnip
                friendly-snippets
                cmp_luasnip
                cmp-buffer
                cmp-path
                cmp-nvim-lua
                cmp-nvim-lsp
                cmp-cmdline
                cmp-nvim-lsp-signature-help
                cmp-cmdline-history
                lspkind-nvim
              ];

              treesitter = with pkgs.vimPlugins; [
                nvim-treesitter.withAllGrammars
                nvim-treesitter-textobjects
                nvim-ts-autotag
                nvim-ts-context-commentstring
                nvim-autopairs
                rainbow-delimiters-nvim
                ts-comments-nvim
                vim-illuminate
                vim-matchup
              ];

              telescope = with pkgs.vimPlugins; [
                telescope-nvim
                telescope-fzf-native-nvim
                telescope-ui-select-nvim
                telescope-undo-nvim
                pkgs.neovimPlugins.telescope-egrepify
              ];

              lsp = with pkgs.vimPlugins; [
                nvim-lspconfig
                fidget-nvim
                lspsaga-nvim
                tiny-inline-diagnostic-nvim
                nvim-jdtls
                tsc-nvim
              ];

              navigation = with pkgs.vimPlugins; [
                flash-nvim
                tmux-nvim
                hop-nvim
                leap-nvim
                pkgs.neovimPlugins.nap
              ];

              git = with pkgs.vimPlugins; [
                git-conflict-nvim
                diffview-nvim
                lazygit-nvim
                gitsigns-nvim
              ];

              explorer = with pkgs.vimPlugins; [
                nvim-tree-lua
                pkgs.neovimPlugins.nvim-tree-preview
                yazi-nvim
              ];

              ai = with pkgs.vimPlugins; [
                pkgs.neovimPlugins.codecompanion
                avante-nvim
              ];

              filetypes = with pkgs.vimPlugins; [
                csvview-nvim
                mkdnflow-nvim
                pkgs.neovimPlugins.log-highlight
                kulala-nvim
              ];

              persistence = with pkgs.vimPlugins; [
                persisted-nvim
                auto-save-nvim
                undotree
              ];

              test = with pkgs.vimPlugins; [
                neotest
                neotest-jest
                neotest-vitest
                neotest-playwright
                FixCursorHold-nvim
              ];

              ui = with pkgs.vimPlugins; [
                bufferline-nvim
                comment-box-nvim
                helpview-nvim
                nvim-notify
                pkgs.neovimPlugins.hlargs
                lualine-nvim
                noice-nvim
                neoscroll-nvim
                nvim-bqf
                nvim-scrollbar
                nvim-scrollview
                nvim-hlslens
                nvim-ufo
                marks-nvim
                registers-nvim
                todo-comments-nvim
                nvim-highlight-colors
                ccc-nvim
                pkgs.neovimPlugins.incline
                pkgs.neovimPlugins.reticle
                trouble-nvim
                dropbar-nvim
              ];

              lib = with pkgs.vimPlugins; [
                # legendary-nvim
                sqlite-lua

                # avante-nvim
                render-markdown-nvim
              ];

              utils = with pkgs.vimPlugins; [
                legendary-nvim
                nvim-surround
                toggleterm-nvim
                conform-nvim
                grug-far-nvim
                hydra-nvim
                live-command-nvim
                scope-nvim
                sniprun
                snacks-nvim
                dial-nvim
                mini-nvim
                vim-visual-multi
                gx-nvim
                pkgs.neovimPlugins.vim-caser
                pkgs.neovimPlugins.nvim-recorder
                debugprint-nvim
                pkgs.neovimPlugins.cutlass
                pkgs.neovimPlugins.stay-in-place
                pkgs.neovimPlugins.code_runner
                pkgs.neovimPlugins.jq-playground
              ];
            };
          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            general = with pkgs;
              [ # <- this would be included if any of the subcategories of general are
                # libgit2
                # sqlite
              ];
          };

          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            # LIBSQLITE = "${pkgs.sqlite.out}/lib/libsqlite3.dylib";
            test = {
              default = { CATTESTVARDEFAULT = "It worked!"; };
              subtest1 = { CATTESTVAR = "It worked!"; };
              subtest2 = { CATTESTVAR3 = "It didn't work!"; };
            };
          };

          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
            test = [ ''--set CATTESTVAR2 "It worked again!"'' ];
          };

          # lists of the functions you would have passed to
          # python.withPackages or lua.withPackages

          # get the path to this python environment
          # in your lua config via `vim.g.python3_host_prog`
          # or run from nvim terminal via `:!<packagename>-python3`
          extraPython3Packages = { test = (_: [ ]); };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = { general = [ (_: [ ]) ]; };

          # see :help nixCats.flake.outputs.categoryDefinitions.default_values
          # this will enable test.default and debug.default
          # if any subcategory of test or debug is enabled
          # WARNING: use of categories argument in this set will cause infinite recursion
          # The categories argument of this function is the FINAL value.
          # You may use it in any of the other sets.
          extraCats = {
            test = [[ "test" "default" ]];
            debug = [[ "debug" "default" ]];
            go = [[ "debug" "go" ] # yes it has to be a list of lists
              ];
          };
        };

      # packageDefinitions:

      # Now build a package with specific categories from above
      # All categories you wish to include must be marked true,
      # but false may be omitted.
      # This entire set is also passed to nixCats for querying within the lua.
      # It is directly translated to a Lua table, and a get function is defined.
      # The get function is to prevent errors when querying subcategories.

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = {
        # NOTE: the name needs to be the same as `defaultPackageName`
        nvim = { pkgs, ... }@misc: {
          categories = {
            runtime = true;
            lsp = true;
            tools = true;
            startup = true;
            optional = true;
          };
          # NOTE: see :help nixCats.flake.outputs.packageDefinitions
          settings = {
            # package name and default launch name is `nixCats`,
            # or, whatever you named the package definition in the packageDefinitions set.
            aliases = [ ];

            # explained below in the `regularCats` package's definition
            # OR see :help nixCats.flake.outputs.settings for all of the settings available
            wrapRc = true;
            configDirName = "nixCats-nvim";
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          };
          # enable the categories from categoryDefinitions
          extra = {
            # to keep the categories table from being filled with non category things that you want to pass
            # there is also an extra table you can use to pass extra stuff.
            # but you can pass all the same stuff in any of these sets and access it in lua
            nixdExtras = { nixpkgs = nixpkgs; };
          };
        };

        regularCats = { pkgs, ... }@misc: {
          categories = {
            runtime = true;
            lsp = true;
            tools = true;
            startup = true;
            optional = true;
          };
          settings = {
            # IMPURE PACKAGE: normal config reload
            # include same categories as main config,
            # will load from vim.fn.stdpath('config')
            wrapRc = false;
            # or tell it some other place to load
            # unwrappedCfgPath = "/some/path/to/your/config";

            # configDirName: will now look for nixCats-nvim within .config and .local and others
            # this can be changed so that you can choose which ones share data folders for auths
            # :h $NVIM_APPNAME
            configDirName = "nixCats-nvim";

            aliases = [ ];

            # If you wanted nightly, uncomment this, and the flake input.
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          };
          extra = { nixdExtras = { nixpkgs = nixpkgs; }; };
        };
      };

      defaultPackageName = "nvim";

      # defaultPackageName is also passed to utils.mkNixosModules and utils.mkHomeModules
      # and it controls the name of the top level option set.
      # If you made a package named `nvim` your default package as we did here,
      # the modules generated would be set at:
      # config.nvim = {
      #   enable = true;
      #   packageNames = [ "nvim" ]; # <- the packages you want installed
      #   <see :h nixCats.module for options>
      # }
      # In addition, every package exports its own module via passthru, and is overrideable.
      # so you can yourpackage.homeModule and then the namespace would be that packages name.
      # you shouldnt need to change much past here, but you can if you wish.
      # but you should at least eventually try to figure out whats going on here!
      # see :help nixCats.flake.outputs.exports
    in forEachSystem (system:
      let
        # and this will be our builder! it takes a name from our packageDefinitions as an argument, and builds an nvim.
        nixCatsBuilder = utils.baseBuilder luaPath {
          # we pass in the things to make a pkgs variable to build nvim with later
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
          # and also our categoryDefinitions and packageDefinitions
        } categoryDefinitions packageDefinitions;
        # call it with our defaultPackageName
        defaultPackage = nixCatsBuilder defaultPackageName;

        # this pkgs variable is just for using utils such as pkgs.mkShell
        # within this outputs set.
        pkgs = import nixpkgs { inherit system; };
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
      in {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        # this will generate a set of all the packages
        # in the packageDefinitions defined above
        # from the package we give it.
        # and additionally output the original as default.
        packages = utils.mkAllWithDefault defaultPackage;

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = "";
          };
        };

      }) // (let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
        };
      in {

        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      });

}
