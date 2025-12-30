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
            pkgs.zsh
          ];

          shellHook = ''
            # Create a temp file for the config to prevent modification of the original
            export OMP_THEME_CONFIG=$(mktemp --suffix=.omp.json)
            cp ./mocha.omp.json "$OMP_THEME_CONFIG"

            # Setup a temporary ZDOTDIR to load our configuration on top of user's
            export ZDOTDIR=$(mktemp -d)

            # Create .zshrc that sources user's config and adds our theme
            echo "if [ -f $HOME/.zshrc ]; then source $HOME/.zshrc; fi" > "$ZDOTDIR/.zshrc"
            echo 'eval "$(oh-my-posh init zsh --config "$OMP_THEME_CONFIG")"' >> "$ZDOTDIR/.zshrc"

            echo "Initializing Catppuccin Mocha theme in ZSH..."
            exec zsh
          '';
        };
      }
    );
}
