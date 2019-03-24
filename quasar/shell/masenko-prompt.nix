
# fish prompt maserano

{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "masenko-prompt";
  src = ./prompt;
  installPhase = ''
    ${pkgs.coreutils}/bin/mkdir $out

    ${pkgs.coreutils}/bin/cp $src/fish_prompt.fish $out/fish_prompt.fish
    ${pkgs.coreutils}/bin/cp $src/git_branch_name.fish $out/git_branch_name.fish
    ${pkgs.coreutils}/bin/cp $src/git_is_repo.fish $out/git_is_repo.fish
    ${pkgs.coreutils}/bin/cp $src/git_is_stashed.fish $out/git_is_stashed.fish
    ${pkgs.coreutils}/bin/cp $src/segment_close.fish $out/segment_close.fish
    ${pkgs.coreutils}/bin/cp $src/segment_right.fish $out/segment_right.fish
    ${pkgs.coreutils}/bin/cp $src/fish_right_prompt.fish $out/fish_right_prompt.fish
    ${pkgs.coreutils}/bin/cp $src/git_is_dirty.fish $out/git_is_dirty.fish
    ${pkgs.coreutils}/bin/cp $src/git_is_staged.fish $out/git_is_staged.fish
    ${pkgs.coreutils}/bin/cp $src/git_is_touched.fish $out/git_is_touched.fish
    ${pkgs.coreutils}/bin/cp $src/segment.fish $out/segment.fish
  '';
}



















