
{ pkgs, ... }:
# TODO usability?
pkgs.vscode-with-extensions.overrides {
  vscodeExtensions = with pkgs.vscode-extensions; [
    bbenoist.Nix
  ] ++ vscode-utils.extensionsFromVscodeMarketplace [
    {
    name = "flatui";
    publisher = "lkytal";
    version = "1.4.9";
    sha256 = "1lkqrd89b0srwskpxirk25x88yczalh64hnvjcsn97h16q5r9v4y";
    }
  ];
}