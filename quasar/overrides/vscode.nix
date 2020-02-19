
{ pkgs, ... }:

pkgs.vscode-with-extensions.override {
  vscodeExtensions = with pkgs.vscode-extensions; [
    bbenoist.Nix
    alanz.vscode-hie-server
    justusadam.language-haskell
  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "ayu-one-dark";
      publisher = "faceair";
      version = "1.1.0";
      sha256 = "1ig7w6xfzqpmjb6ynm5ylssqacrrb320idajsazb9p3dbsw48zwr";
    } { 
      name = "flatui";
      publisher = "lkytal";
      version = "1.4.9";
      sha256 = "1lkqrd89b0srwskpxirk25x88yczalh64hnvjcsn97h16q5r9v4y"; 
    } {
      name = "git-graph";
      publisher = "mhutchie";
      version = "1.21.0";
      sha256 = "0prj1ymv5f9gwm838jwdi2gbqh40gc0ndpi17yysngcyz9fzym98";
    } {
      name = "gitlens";
      publisher = "eamodio";
      version = "10.2.1";
      sha256 = "1bh6ws20yi757b4im5aa6zcjmsgdqxvr1rg86kfa638cd5ad1f97";
    } {
      name = "markdown-all-in-one";
      publisher = "yzhang";
      version = "2.7.0";
      sha256 = "1hrxw4ilm2r48kd442j2i7ar43w463612bx569pdhz80mapr1z9k";
    } {
      name = "fish-vscode";
      publisher = "skyapps";
      version = "0.2.1";
      sha256 = "0y1ivymn81ranmir25zk83kdjpjwcqpnc9r3jwfykjd9x0jib2hl";
    }
  ];
}