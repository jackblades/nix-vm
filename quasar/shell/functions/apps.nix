{ lib, pkgs, config, ... }:
with lib;
let constants = config.constants; in
{
  shellAliases = {
    nnops = "${pkgs.ranger}/bin/ranger ${constants.qsr-user-storage-quasar}/notes/_ops";
    nnkb = "${pkgs.ranger}/bin/ranger ${constants.qsr-user-storage-quasar}/notes/kb";

  };
  shellInit =
    ''
      function nn
        set notesdir "${constants.qsr-user-storage-quasar}/notes"
        
        if test -d $notesdir
          # ${pkgs.vscode}/bin/code $notesdir
          igrun /usr/bin/env PWD=$notesdir ${pkgs.typora}/bin/typora $notesdir/_ops/_TODO.md
          ${pkgs.ranger}/bin/ranger $notesdir
        else
          # initialize the notes directory
          ${pkgs.coreutils}/bin/mkdir -p "$notesdir/_ops"
          ${pkgs.coreutils}/bin/touch "$notesdir/_ops/_TODO.md" 
          ${pkgs.coreutils}/bin/touch "$notesdir/_ops/NEED.md" 
          ${pkgs.coreutils}/bin/touch "$notesdir/_ops/WANT.md" 

          ${pkgs.coreutils}/bin/mkdir -p "$notesdir/kb"
          ${pkgs.coreutils}/bin/echo '# DESCRIPTION' > "$notesdir/kb/README.md" 
          ${pkgs.coreutils}/bin/echo '- Knowledge Base' >> "$notesdir/kb/README.md"

          cd "$notesdir"; and ${pkgs.gitAndTools.gitFull}/bin/git init
        end
      end
      
      # TODO nnmkrecord yyyy mm col1 col2 ... coln
      function nnmkrecord
        echo '| date       | diet-p | diet-f | diet-r | gym  |'
        echo '| ---------- | ------ | ------ | ------ | ---- |'

        for i in (seq 1 9)
          echo "| $argv[1]/0$i |        |        |        |      |"
        end

        for i in (seq 10 31)
          echo "| $argv[1]/$i |        |        |        |      |"
        end
      end

      # TODO
      function nnmktodo                                              
        # pad all output 10 chars                                    
                                                                    
        ### read title                                               
        read -P 'TITLE     ' -l title                                
                                                                    
        ### read date, time, day                                     
        set cyear (date +"%Y")                                       
        set cmonth (date +"%m")                                      
        set cdate (date +"%d")                                       
        set cdatestamp (date +"%Y/%m/%d")                            
                                                                    
        set cday (date +"%a")                                        
                                                                    
        set chour (date +"%H")                                       
        set cmin (date +"%M")                                        
        set csec (date +"%S")                                        
        set ctimestamp (date +"%H:%M:%S")                            
                                                                    
        ### read type                                                
        set ptype "ONESHOT\nRECURRING"                               
        echo -e $ptype | fzfr --height 30% | read -P -l ttype        
                                                                    
        ### read description                                         
        echo DESCRIPTION                                             
        set desc (read -P '          ')                              
        while read -P '          ' -l line                           
          set desc $desc $line                                    
        end                                                          
                                                                    
        ### read status                                              
        set pstatus "UNSCHEDULED\nSCHEDULED\nRUNNING\nBLOCKED\nDONE" 
        echo -e $pstatus | fzfr --height 30% | read -l tstatus       
                                                                    
        ### print todo                                               
        echo "TITLE     " $title                                     
        echo "TYPE      " $ttype                                     
        echo "DATETIME  " $cday $cdatestamp $ctimestamp              
        echo "DESCRIPTION"                                           
        for line in $desc                                                
          echo '          ' $line
        end
        echo "STATUS    " $tstatus                                   
      end

    '';
}