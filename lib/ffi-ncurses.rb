# ruby-ffi wrapper for ncurses
# Sean O'Halpin
# version 0.1.0 - 2008-12-04
# version 0.2.0 - 2009-01-18
# version 0.3.0 - 2009-01-31
# - added stdscr, newscr, curscr
# requires ruby-ffi >= 0.2.0 or jruby >= 1.1.6
# tested with ruby 1.8.6, jruby 1.1.6 on Ubuntu 8.04, Mac OS X 10.4
# ncurses 5.x

require 'ffi'

# would like to check FFI version here rather than use gem but there
# doesn't appear to be a version specified in the ffi lib

module FFI
  module NCurses
    VERSION = "0.3.2"
    extend FFI::Library

    # use RUBY_FFI_NCURSES_LIB to specify exactly which lib you want, e.g. ncursesw, XCurses (from PDCurses)
    if ENV["RUBY_FFI_NCURSES_LIB"].to_s != ""
      LIB_HANDLE = ffi_lib( ENV["RUBY_FFI_NCURSES_LIB"] ).first
    else
      LIB_HANDLE = ffi_lib( ['ncurses', 'libncurses.so.5', 'XCurses'] ).first
    end

    begin
            
      if LIB_HANDLE.respond_to?(:find_symbol)
        # these symbols are defined in ncurses.h
        symbols = [ "stdscr", "curscr", "newscr" ]
        SYMBOLS = Hash[*symbols.map { |sym| [sym, LIB_HANDLE.find_symbol(sym)]}.compact.flatten ]
        SYMBOLS.keys.each do |sym|
          # note that the symbol table entry in a dll for an exported
          # variable contains a ~pointer to the address~ of the variable
          # which will be initialized in the process's bss (uninitialized)
          # data segment when the process is initialized

          # this is unlike methods, where the symbol table entry points to
          # the entry point of the method itself

          # variables need another level of indirection because they are
          # ~not~ shared between process instances - the sharing is of
          # code only
          # p SYMBOLS[sym]
          define_method sym do
            SYMBOLS[sym].read_pointer
          end
          module_function sym
        end
      else
      end
    rescue Object => e
    end
    
    # this list of function signatures was generated by the file
    # generate-ffi-ncurses-function-signatures.rb and inserted here by hand
    # then edited a bit :)
    functions =
      [
       [:COLOR_PAIR, [:int], :int],
       [:PAIR_NUMBER, [:int], :int],
       # these functions are only in the debug version of ncurses
       #       [:_nc_tracebits, [], :string],
       #       [:_nc_visbuf, [:string], :string],
       #       [:_traceattr2, [:int, :uint], :string],
       #       [:_traceattr, [:uint], :string],
       #       [:_tracecchar_t2, [:int, :pointer], :string],
       #       [:_tracecchar_t, [:pointer], :string],
       #       [:_tracechar, [:int], :string],
       #       [:_tracechtype2, [:int, :uint], :string],
       #       [:_tracechtype, [:uint], :string],
       #       [:_tracedump, [:string, :pointer], :void],
       #       [:_tracef, [:string, :varargs], :void],
       #       [:_tracemouse, [:pointer], :string],
       [:add_wchnstr, [:pointer, :int], :int],
       [:add_wch, [:pointer], :int],
       [:add_wchstr, [:pointer], :int],
       [:addchnstr, [:pointer, :int], :int],
       [:addchstr, [:pointer], :int],
       [:addch, [:uint], :int],
       [:addnstr, [:string, :int], :int],
       [:addstr, [:string], :int],
       [:assume_default_colors, [:int, :int], :int],
       [:attr_get, [:pointer, :pointer, :pointer], :int],
       [:attr_off, [:uint, :pointer], :int],
       [:attr_on, [:uint, :pointer], :int],
       [:attr_set, [:uint, :short, :pointer], :int],
       [:attroff, [:uint], :int],
       [:attron, [:uint], :int],
       [:attrset, [:uint], :int],
       [:baudrate, [], :int],
       [:beep, [], :int],
       [:bkgdset, [:uint], :void],
       [:bkgd, [:uint], :int],
       [:bkgrnd, [:pointer], :int],
       [:bkgrndset, [:pointer], :void],
       [:border_set, [:pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int],
       [:border, [:uint, :uint, :uint, :uint, :uint, :uint, :uint, :uint], :int],
       [:box_set, [:pointer, :pointer, :pointer], :int],
       [:box, [:pointer, :uint, :uint], :int],
       [:can_change_color, [], :int],
       [:cbreak, [], :int],
       [:chgat, [:int, :uint, :short, :pointer], :int],
       [:clear, [], :int],
       [:clearok, [:pointer, :int], :int],
       [:clrtobot, [], :int],
       [:clrtoeol, [], :int],
       [:color_content, [:short, :pointer, :pointer, :pointer], :int],
       [:color_set, [:short, :pointer], :int],
       [:copywin, [:pointer, :pointer, :int, :int, :int, :int, :int, :int, :int], :int],
       [:curs_set, [:int], :int],
       [:curses_version, [], :string],
       [:def_prog_mode, [], :int],
       [:def_shell_mode, [], :int],
       [:define_key, [:string, :int], :int],
       [:delay_output, [:int], :int],
       [:delch, [], :int],
       [:deleteln, [], :int],
       [:delscreen, [:pointer], :void],
       [:delwin, [:pointer], :int],
       [:derwin, [:pointer, :int, :int, :int, :int], :pointer],
       [:doupdate, [], :int],
       [:dupwin, [:pointer], :pointer],
       [:echo_wchar, [:pointer], :int],
       [:echochar, [:uint], :int],
       [:echo, [], :int],
       [:endwin, [], :int],
       [:erasechar, [], :char],
       [:erase, [], :int],
       [:filter, [], :void],
       [:flash, [], :int],
       [:flushinp, [], :int],
       [:getbkgd, [:pointer], :uint],
       [:getbkgrnd, [:pointer], :int],
       [:getch, [], :int],

       [:getattrs, [:pointer], :int],
       [:getcurx, [:pointer], :int],
       [:getcury, [:pointer], :int],
       [:getbegx, [:pointer], :int],
       [:getbegy, [:pointer], :int],
       [:getmaxx, [:pointer], :int],
       [:getmaxy, [:pointer], :int],
       [:getparx, [:pointer], :int],
       [:getpary, [:pointer], :int],

       # this is defined in mouse.rb
       #      [:getmouse, [:pointer], :int],
       [:getnstr, [:string, :int], :int],
       [:getstr, [:string], :int],
       [:getwin, [:pointer], :pointer],
       [:halfdelay, [:int], :int],
       [:has_colors, [], :int],
       [:has_ic, [], :int],
       [:has_il, [], :int],
       [:has_key, [:int], :int],
       [:hline_set, [:pointer, :int], :int],
       [:hline, [:uint, :int], :int],
       [:idcok, [:pointer, :int], :void],
       [:idlok, [:pointer, :int], :int],
       [:immedok, [:pointer, :int], :void],
       [:in_wchnstr, [:pointer, :int], :int],
       [:in_wch, [:pointer], :int],
       [:in_wchstr, [:pointer], :int],
       [:inchnstr, [:pointer, :int], :int],
       [:inchstr, [:pointer], :int],
       [:inch, [], :uint],
       [:init_color, [:short, :short, :short, :short], :int],
       [:init_pair, [:short, :short, :short], :int],
       # need to intercept this to get stdscr for JRuby (for the moment)
       ["_initscr", :initscr, [], :pointer],
       [:innstr, [:string, :int], :int],
       [:ins_wch, [:pointer], :int],
       [:insch, [:uint], :int],
       [:insdelln, [:int], :int],
       [:insertln, [], :int],
       [:insnstr, [:string, :int], :int],
       [:insstr, [:string], :int],
       [:instr, [:string], :int],
       [:intrflush, [:pointer, :int], :int],
       [:is_linetouched, [:pointer, :int], :int],
       [:is_term_resized, [:int, :int], :int],
       [:is_wintouched, [:pointer], :int],
       [:isendwin, [], :int],
       [:key_defined, [:string], :int],
       [:keybound, [:int, :int], :string],
       [:keyname, [:int], :string],
       [:keyok, [:int, :int], :int],
       [:keypad, [:pointer, :int], :int],
       [:killchar, [], :char],
       [:leaveok, [:pointer, :int], :int],
       [:longname, [], :string],
       [:mcprint, [:string, :int], :int],
       [:meta, [:pointer, :int], :int],
       [:mouse_trafo, [:pointer, :pointer, :int], :int],
       [:mouseinterval, [:int], :int],
       [:mousemask, [:uint, :pointer], :uint],
       [:move, [:int, :int], :int],
       [:mvadd_wch, [:int, :int, :pointer], :int],
       [:mvadd_wchnstr, [:int, :int, :pointer, :int], :int],
       [:mvadd_wchstr, [:int, :int, :pointer], :int],
       [:mvaddch, [:int, :int, :uint], :int],
       [:mvaddchnstr, [:int, :int, :pointer, :int], :int],
       [:mvaddchstr, [:int, :int, :pointer], :int],
       [:mvaddnstr, [:int, :int, :string, :int], :int],
       [:mvaddstr, [:int, :int, :string], :int],
       [:mvchgat, [:int, :int, :int, :uint, :short, :pointer], :int],
       [:mvcur, [:int, :int, :int, :int], :int],
       [:mvdelch, [:int, :int], :int],
       [:mvderwin, [:pointer, :int, :int], :int],
       [:mvgetch, [:int, :int], :int],
       [:mvgetnstr, [:int, :int, :string, :int], :int],
       [:mvgetstr, [:int, :int, :string], :int],
       [:mvhline_set, [:int, :int, :pointer, :int], :int],
       [:mvhline, [:int, :int, :uint, :int], :int],
       [:mvin_wch, [:int, :int, :pointer], :int],
       [:mvin_wchnstr, [:int, :int, :pointer, :int], :int],
       [:mvin_wchstr, [:int, :int, :pointer], :int],
       [:mvinch, [:int, :int], :uint],
       [:mvinchnstr, [:int, :int, :pointer, :int], :int],
       [:mvinchstr, [:int, :int, :pointer], :int],
       [:mvinnstr, [:int, :int, :string, :int], :int],
       [:mvins_wch, [:int, :int, :pointer], :int],
       [:mvinsch, [:int, :int, :uint], :int],
       [:mvinsnstr, [:int, :int, :string, :int], :int],
       [:mvinsstr, [:int, :int, :string], :int],
       [:mvinstr, [:int, :int, :string], :int],
       [:mvprintw, [:int, :int, :string, :varargs], :int],
       [:mvscanw, [:int, :int, :string, :varargs], :int],
       [:mvvline_set, [:int, :int, :pointer, :int], :int],
       [:mvvline, [:int, :int, :uint, :int], :int],
       [:mvwadd_wchnstr, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwadd_wch, [:pointer, :int, :int, :pointer], :int],
       [:mvwadd_wchstr, [:pointer, :int, :int, :pointer], :int],
       [:mvwaddchnstr, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwaddch, [:pointer, :int, :int, :uint], :int],
       [:mvwaddchstr, [:pointer, :int, :int, :pointer], :int],
       [:mvwaddnstr, [:pointer, :int, :int, :string, :int], :int],
       [:mvwaddstr, [:pointer, :int, :int, :string], :int],
       [:mvwchgat, [:pointer, :int, :int, :int, :uint, :short, :pointer], :int],
       [:mvwdelch, [:pointer, :int, :int], :int],
       [:mvwgetch, [:pointer, :int, :int], :int],
       [:mvwgetnstr, [:pointer, :int, :int, :string, :int], :int],
       [:mvwgetstr, [:pointer, :int, :int, :string], :int],
       [:mvwhline_set, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwhline, [:pointer, :int, :int, :uint, :int], :int],
       [:mvwin_wchnstr, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwin_wch, [:pointer, :int, :int, :pointer], :int],
       [:mvwin_wchstr, [:pointer, :int, :int, :pointer], :int],
       [:mvwinchnstr, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwinch, [:pointer, :int, :int], :uint],
       [:mvwinchstr, [:pointer, :int, :int, :pointer], :int],
       [:mvwinnstr, [:pointer, :int, :int, :string, :int], :int],
       [:mvwin, [:pointer, :int, :int], :int],
       [:mvwins_wch, [:pointer, :int, :int, :pointer], :int],
       [:mvwinsch, [:pointer, :int, :int, :uint], :int],
       [:mvwinsnstr, [:pointer, :int, :int, :string, :int], :int],
       [:mvwinsstr, [:pointer, :int, :int, :string], :int],
       [:mvwinstr, [:pointer, :int, :int, :string], :int],
       [:mvwprintw, [:pointer, :int, :int, :string, :varargs], :int],
       [:mvwscanw, [:pointer, :int, :int, :string, :varargs], :int],
       [:mvwvline_set, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwvline, [:pointer, :int, :int, :uint, :int], :int],
       [:napms, [:int], :int],
       [:newpad, [:int, :int], :pointer],
       [:newterm, [:string, :pointer, :pointer], :pointer],
       [:newwin, [:int, :int, :int, :int], :pointer],
       [:nl, [], :int],
       [:nocbreak, [], :int],
       [:nodelay, [:pointer, :int], :int],
       [:noecho, [], :int],
       [:nonl, [], :int],
       [:noqiflush, [], :void],
       [:noraw, [], :int],
       [:notimeout, [:pointer, :int], :int],
       [:overlay, [:pointer, :pointer], :int],
       [:overwrite, [:pointer, :pointer], :int],
       [:pair_content, [:short, :pointer, :pointer], :int],
       [:pecho_wchar, [:pointer, :pointer], :int],
       [:pechochar, [:pointer, :uint], :int],
       [:pnoutrefresh, [:pointer, :int, :int, :int, :int, :int, :int], :int],
       [:prefresh, [:pointer, :int, :int, :int, :int, :int, :int], :int],
       [:printw, [:string, :varargs], :int],
       [:putp, [:string], :int],
       [:putwin, [:pointer, :pointer], :int],
       [:qiflush, [], :void],
       [:raw, [], :int],
       [:redrawwin, [:pointer], :int],
       [:refresh, [], :int],
       [:reset_prog_mode, [], :int],
       [:reset_shell_mode, [], :int],
       [:resetty, [], :int],
       [:resize_term, [:int, :int], :int],
       [:resizeterm, [:int, :int], :int],
       [:ripoffline, [:int, :pointer], :int],
       [:savetty, [], :int],
       [:scanw, [:string, :varargs], :int],
       [:scr_dump, [:string], :int],
       [:scr_init, [:string], :int],
       [:scr_restore, [:string], :int],
       [:scr_set, [:string], :int],
       [:scrl, [:int], :int],
       [:scrollok, [:pointer, :int], :int],
       [:scroll, [:pointer], :int],
       [:set_term, [:pointer], :pointer],
       [:setscrreg, [:int, :int], :int],
       [:slk_attr_off, [:uint, :pointer], :int],
       [:slk_attr_on, [:uint, :pointer], :int],
       [:slk_attr_set, [:uint, :short, :pointer], :int],
       [:slk_attroff, [:uint], :int],
       [:slk_attron, [:uint], :int],
       [:slk_attrset, [:uint], :int],
       [:slk_attr, [], :uint],
       [:slk_clear, [], :int],
       [:slk_color, [:short], :int],
       [:slk_init, [:int], :int],
       [:slk_label, [:int], :string],
       [:slk_noutrefresh, [], :int],
       [:slk_refresh, [], :int],
       [:slk_restore, [], :int],
       [:slk_set, [:int, :string, :int], :int],
       [:slk_touch, [], :int],
       [:standend, [], :int],
       [:standout, [], :int],
       [:start_color, [], :int],
       [:subpad, [:pointer, :int, :int, :int, :int], :pointer],
       [:subwin, [:pointer, :int, :int, :int, :int], :pointer],
       [:syncok, [:pointer, :int], :int],
       [:term_attrs, [], :uint],
       [:termattrs, [], :uint],
       [:termname, [], :string],
       [:tigetflag, [:string], :int],
       [:tigetnum, [:string], :int],
       [:tigetstr, [:string], :string],
       [:timeout, [:int], :void],
       [:touchline, [:pointer, :int, :int], :int],
       [:touchwin, [:pointer], :int],
       [:tparm, [:string, :varargs], :string],
       #       [:trace, [:uint], :void],
       [:typeahead, [:int], :int],
       [:ungetch, [:int], :int],
       # moved into mouse
       #       [:ungetmouse, [:pointer], :int],
       [:untouchwin, [:pointer], :int],
       [:use_default_colors, [], :int],
       [:use_env, [:int], :void],
       [:use_extended_names, [:int], :int],
       [:vid_attr, [:uint, :short, :pointer], :int],
       [:vid_puts, [:uint, :short, :pointer, :pointer], :int],
       [:vidattr, [:uint], :int],
       [:vidputs, [:uint, :pointer], :int],
       [:vline_set, [:pointer, :int], :int],
       [:vline, [:uint, :int], :int],
       [:wadd_wchnstr, [:pointer, :pointer, :int], :int],
       [:wadd_wch, [:pointer, :pointer], :int],
       [:wadd_wchstr, [:pointer, :pointer], :int],
       [:waddchnstr, [:pointer, :pointer, :int], :int],
       [:waddch, [:pointer, :uint], :int],
       [:waddchstr, [:pointer, :pointer], :int],
       [:waddnstr, [:pointer, :string, :int], :int],
       [:waddstr, [:pointer, :string], :int],
       [:wattr_get, [:pointer, :pointer, :pointer, :pointer], :int],
       [:wattr_off, [:pointer, :uint, :pointer], :int],
       [:wattr_on, [:pointer, :uint, :pointer], :int],
       [:wattr_set, [:pointer, :uint, :short, :pointer], :int],
       [:wattroff, [:pointer, :int], :int],
       [:wattron, [:pointer, :int], :int],
       [:wattrset, [:pointer, :int], :int],
       [:wbkgd, [:pointer, :uint], :int],
       [:wbkgdset, [:pointer, :uint], :void],
       [:wbkgrnd, [:pointer, :pointer], :int],
       [:wbkgrndset, [:pointer, :pointer], :void],
       [:wborder_set, [:pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int],
       [:wborder, [:pointer, :uint, :uint, :uint, :uint, :uint, :uint, :uint, :uint], :int],
       [:wchgat, [:pointer, :int, :uint, :short, :pointer], :int],
       [:wclear, [:pointer], :int],
       [:wclrtobot, [:pointer], :int],
       [:wclrtoeol, [:pointer], :int],
       [:wcolor_set, [:pointer, :short, :pointer], :int],
       [:wcursyncup, [:pointer], :void],
       [:wdelch, [:pointer], :int],
       [:wdeleteln, [:pointer], :int],
       [:wecho_wchar, [:pointer, :pointer], :int],
       [:wechochar, [:pointer, :uint], :int],
       [:wenclose, [:pointer, :int, :int], :int],
       [:werase, [:pointer], :int],
       [:wgetbkgrnd, [:pointer, :pointer], :int],
       [:wgetch, [:pointer], :int],
       [:wgetnstr, [:pointer, :string, :int], :int],
       [:wgetstr, [:pointer, :string], :int],
       [:whline_set, [:pointer, :pointer, :int], :int],
       [:whline, [:pointer, :uint, :int], :int],
       [:win_wchnstr, [:pointer, :pointer, :int], :int],
       [:win_wch, [:pointer, :pointer], :int],
       [:win_wchstr, [:pointer, :pointer], :int],
       [:winchnstr, [:pointer, :pointer, :int], :int],
       [:winch, [:pointer], :uint],
       [:winchstr, [:pointer, :pointer], :int],
       [:winnstr, [:pointer, :string, :int], :int],
       [:wins_wch, [:pointer, :pointer], :int],
       [:winsch, [:pointer, :uint], :int],
       [:winsdelln, [:pointer, :int], :int],
       [:winsertln, [:pointer], :int],
       [:winsnstr, [:pointer, :string, :int], :int],
       [:winsstr, [:pointer, :string], :int],
       [:winstr, [:pointer, :string], :int],
       [:wmove, [:pointer, :int, :int], :int],
       [:wnoutrefresh, [:pointer], :int],
       [:wprintw, [:pointer, :string, :varargs], :int],
       [:wredrawln, [:pointer, :int, :int], :int],
       [:wrefresh, [:pointer], :int],
       [:wresize, [:pointer, :int, :int], :int],
       [:wscanw, [:pointer, :string, :varargs], :int],
       [:wscrl, [:pointer, :int], :int],
       [:wsetscrreg, [:pointer, :int, :int], :int],
       [:wstandend, [:pointer], :int],
       [:wstandout, [:pointer], :int],
       [:wsyncdown, [:pointer], :void],
       [:wsyncup, [:pointer], :void],
       [:wtimeout, [:pointer, :int], :void],
       [:wtouchln, [:pointer, :int, :int, :int], :int],
       [:wvline_set, [:pointer, :pointer, :int], :int],
       [:wvline, [:pointer, :uint, :int], :int]
      ]
    # end of autogenerated function list

    @unattached_functions = []
    class << self
      def unattached_functions
        @unattached_functions
      end
    end

    # attach functions
    functions.each do |func|
      begin
        attach_function(*func)
      rescue Object => e
        # for debugging
        unattached_functions << func[0]
      end
    end

    module Colour
      COLOR_BLACK   = BLACK   = 0
      COLOR_RED     = RED     = 1
      COLOR_GREEN   = GREEN   = 2
      COLOR_YELLOW  = YELLOW  = 3
      COLOR_BLUE    = BLUE    = 4
      COLOR_MAGENTA = MAGENTA = 5
      COLOR_CYAN    = CYAN    = 6
      COLOR_WHITE   = WHITE   = 7
    end
    Color = Colour
    include Colour

    # FIXME: remove this code when JRuby gets find_sym
    # fixup for JRuby 1.1.6 - doesn't have find_sym
    # can hack for stdscr but not curscr or newscr (no methods return them)
    # this will all be removed when JRuby 1.1.7 is released
    module FixupInitscr
      if !NCurses.respond_to?(:stdscr)
        def initscr
          @stdscr = NCurses._initscr
        end
        def stdscr
          @stdscr
        end
      else
        def initscr
          NCurses._initscr
        end
      end
    end
    include FixupInitscr
    
    module Attributes
      # following definitions have been copied (almost verbatim) from ncurses.h
      NCURSES_ATTR_SHIFT = 8
      def self.NCURSES_BITS(mask, shift)
        ((mask) << ((shift) + NCURSES_ATTR_SHIFT))
      end

      WA_NORMAL     = A_NORMAL     = (1 - 1)
      WA_ATTRIBUTES = A_ATTRIBUTES = NCURSES_BITS(~(1 - 1),0)
      WA_CHARTEXT   = A_CHARTEXT   = (NCURSES_BITS(1,0) - 1)
      WA_COLOR      = A_COLOR      = NCURSES_BITS(((1) << 8) - 1,0)
      WA_STANDOUT   = A_STANDOUT   = NCURSES_BITS(1,8)  # best highlighting mode available
      WA_UNDERLINE  = A_UNDERLINE  = NCURSES_BITS(1,9)  # underlined text
      WA_REVERSE    = A_REVERSE    = NCURSES_BITS(1,10) # reverse video
      WA_BLINK      = A_BLINK      = NCURSES_BITS(1,11) # blinking text
      WA_DIM        = A_DIM        = NCURSES_BITS(1,12) # half-bright text
      WA_BOLD       = A_BOLD       = NCURSES_BITS(1,13) # extra bright or bold text
      WA_ALTCHARSET = A_ALTCHARSET = NCURSES_BITS(1,14)
      WA_INVIS      = A_INVIS      = NCURSES_BITS(1,15)
      WA_PROTECT    = A_PROTECT    = NCURSES_BITS(1,16)
      WA_HORIZONTAL = A_HORIZONTAL = NCURSES_BITS(1,17)
      WA_LEFT       = A_LEFT       = NCURSES_BITS(1,18)
      WA_LOW        = A_LOW        = NCURSES_BITS(1,19)
      WA_RIGHT      = A_RIGHT      = NCURSES_BITS(1,20)
      WA_TOP        = A_TOP        = NCURSES_BITS(1,21)
      WA_VERTICAL   = A_VERTICAL   = NCURSES_BITS(1,22)
    end
    include Attributes

    module Constants
      FALSE = 0
      TRUE = 1

      ERR = -1
      OK = 0
    end
    include Constants

    require 'ffi-ncurses/winstruct'
    include WinStruct
    
    module EmulatedFunctions
      
      # these 'functions' are implemented as macros in ncurses
      
      # I'm departing from the NCurses API here - makes no sense to
      # force people to use pointer return values when these are
      # implemented as macros to make them easy to use in C when we have
      # multiple return values in Ruby for that exact same purpose
      def getyx(win)
        [NCurses.getcury(win), NCurses.getcurx(win)]
      end
      def getbegyx(win)
        [NCurses.getbegy(win), NCurses.getbegx(win)]
      end
      def getparyx(win)
        [NCurses.getpary(win), NCurses.getparx(win)]
      end
      def getmaxyx(win)
        [NCurses.getmaxy(win), NCurses.getmaxx(win)]
      end

      # transliterated from ncurses.h
      # note: had to spell out NCurses::TRUE - will look into this
      def getsyx
        if (is_leaveok(newscr) == NCurses::TRUE)
			    [-1, -1]
        else
          getyx(newscr)
        end
      end
      def setsyx(y, x)
        if y == -1 && x == -1
			    leaveok(newscr, NCurses::TRUE)
        else
			    leaveok(newscr, NCurses::FALSE)
			    wmove(newscr, y, x)
        end
      end
      
      def self.fixup(function, &block)
        if NCurses.unattached_functions.include?(function)
          block.call
        end
      end

      # hack for XCurses (PDCurses 3.3) - many more to come I suspect :)
      fixup :getch do
        def getch
          wgetch(stdscr)
        end
      end
    end
    include EmulatedFunctions

    # fixes for Mac OS X (mostly macros directly referencing the WINDOW struct)
    if ::FFI::Platform::OS == "darwin"
      require 'ffi-ncurses/darwin'
      include NCurses::Darwin
    end

    # make all those instance methods module methods too
    extend self

  end
end

