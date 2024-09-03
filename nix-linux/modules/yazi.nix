
{ ... }:

{
  programs.yazi.enableZshIntegration = true;

  programs.yazi = {
    enable = true;

    settings =  {
      manager = {
        ratio          = [ 1 4 3 ];
        sort_by        = "alphabetical";
        sort_sensitive = false;
        sort_reverse   = false;
        sort_dir_first = false;
        linemode       = "none";
        show_hidden    = false;
        show_symlink   = true;
        scrolloff      = 5;
      };

      preview = {
        tab_size        = 2;
        max_width       = 600;
        max_height      = 900;
        cache_dir       = "";
        image_filter    = "triangle";
        image_quality   = 75;
        sixel_fraction  = 15;
        ueberzug_scale  = 1;
        ueberzug_offset = [ 0 0 0 0 ];
      };

      opener = {
        view_pdf = [
          { run = "zathura \"$@\""; orphan = true; }
        ];
        edit = [
                { run = "\${EDITOR:=vi} \"$@\""; desc = "$EDITOR"; block = true; for = "unix"; }
        ];
        open = [
                { run = "xdg-open \"$@\""; desc = "Open"; for = "linux"; }
        ];
        extract = [
                { run = "unar \"$1\""; desc = "Extract here"; for = "unix"; }
        ];
        play = [
                { run = "mpv \"$@\""; orphan = true; for = "unix"; }
        ];
      };

      open = {
        rules = [
          { name = "*.pdf"; use = [ "view_pdf" ]; }

          { name = "*/"; use = [ "edit" "open" "reveal" ]; }

          { mime = "text/*";  use = [ "edit" "reveal" ]; }
          { mime = "image/*"; use = [ "open" "reveal" ]; }
          { mime = "video/*"; use = [ "play" "reveal" ]; }
          { mime = "audio/*"; use = [ "play" "reveal" ]; }
          { mime = "inode/x-empty"; use = [ "edit" "reveal" ]; }

          { mime = "application/json"; use = [ "edit" "reveal" ]; }
          { mime = "*/javascript";     use = [ "edit" "reveal" ]; }

          { mime = "application/zip";             use = [ "extract" "reveal" ]; }
          { mime = "application/gzip";            use = [ "extract" "reveal" ]; }
          { mime = "application/x-tar";           use = [ "extract" "reveal" ]; }
          { mime = "application/x-bzip";          use = [ "extract" "reveal" ]; }
          { mime = "application/x-bzip2";         use = [ "extract" "reveal" ]; }
          { mime = "application/x-7z-compressed"; use = [ "extract" "reveal" ]; }
          { mime = "application/x-rar";           use = [ "extract" "reveal" ]; }
          { mime = "application/xz";              use = [ "extract" "reveal" ]; }


          { mime = "*"; use = [ "open" "reveal" ]; }
        ];
      };
    };
  };
}

