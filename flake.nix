{
  description = "ROS messages which correspond to the loco-3d/linear-feedback-controller package.";

  inputs = {
    gazebros2nix.url = "github:nim65s/gazebros2nix/nixos-unstable";
    gazebros2nix.inputs.flakoboros.follows = "flakoboros";
    flakoboros.url = "github:gepetto/flakoboros/nixos-unstable";
    flake-parts.follows = "gazebros2nix/flake-parts";
    nixpkgs.follows = "gazebros2nix/nixpkgs";
    systems.follows = "gazebros2nix/systems";
    treefmt-nix.follows = "gazebros2nix/treefmt-nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        debug = true;
        systems = import inputs.systems;
        imports = [
          inputs.gazebros2nix.flakeModule
          {
            flakoboros.rosOverrideAttrs.linear-feedback-controller-msgs = _: _: {
              version = "9.9.9";
              src = lib.fileset.toSource {
                root = ./.;
                fileset = lib.fileset.unions [
                  ./CMakeLists.txt
                  ./include
                  ./linear_feedback_controller_msgs_py
                  ./msg
                  ./package.xml
                  ./tests
                ];
              };
            };
          }
        ];
      }
    );
}
