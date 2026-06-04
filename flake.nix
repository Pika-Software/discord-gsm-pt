{
  description = "Python development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
        pkgs = import nixpkgs {
          inherit system;
        };

      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            python313
            python313Packages.pip
          ];

          shellHook = ''
            echo "🐍 Python: $(python --version)"
            echo "📦 Pip: $(pip --version)"

            if [ ! -d .venv ]; then
              python -m venv .venv
            fi

            source .venv/bin/activate
            pip install -r requirements.txt

            while true; do
              echo "🔄 GSM is running. Press Ctrl+C to restart or double to stop."
              python main.py
              sleep 1
            done
          '';
        };
      }
    );
}
