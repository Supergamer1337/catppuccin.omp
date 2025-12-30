{
  description = "Catppuccin oh-my-posh theme development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.oh-my-posh
          ];

          shellHook = ''
            echo "Initializing Catppuccin Mocha theme for oh-my-posh..."

            # Create a temp file for the config to prevent modification of the original
            CONFIG_TMP=$(mktemp --suffix=.omp.json)
            cp ./mocha.omp.json "$CONFIG_TMP"

            # Detect shell and initialize
            if [ -n "$ZSH_VERSION" ]; then
              eval "$(oh-my-posh init zsh --config "$CONFIG_TMP")"
            elif [ -n "$BASH_VERSION" ]; then
              eval "$(oh-my-posh init bash --config "$CONFIG_TMP")"
            elif [ -n "$FISH_VERSION" ]; then
              eval "$(oh-my-posh init fish --config "$CONFIG_TMP")"
            else
              echo "Could not detect shell (zsh/bash/fish). Please run 'oh-my-posh init <shell> --config ./mocha.omp.json' manually."
            fi

            echo "Environment ready! Use 'oh-my-posh init <shell> --config <file>' to switch themes."
          '';
        };
      }
    );
}
