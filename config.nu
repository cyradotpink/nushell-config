# Nushell Config File

overlay new nuconfig
let clr = $env.THEME_COLORS
# I made everything red that I don't understand the effect of yet, so every time i see something red
# i know i need to check which of these values its controlled by
let good_theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { fg: "#505050", attr: s } # no fg, no bg, attr none effectively turns this off
    header: $clr.main_color_bold
    empty: red # .. isnt empty, in non-syntax-contexts, just nothing? i havent found cases where its displayed as "null" or something
    bool: $clr.literalish
    int: $clr.literalish
    filesize: $clr.literalish
    duration: $clr.literalish
    date: $clr.literalish
    range: $clr.literalish
    float: $clr.literalish
    string: white
    nothing: $clr.literalish
    binary: $clr.literalish
    cell_path: red
    row_index: $clr.main_color_bold
    record: red
    list: red
    block: red
    hints: dark_gray
    search_result: { bg: red fg: white }
    shape_and: $clr.operatorish_bold
    shape_binary: $clr.literalish_faint
    shape_block: $clr.structure
    shape_bool: $clr.literalish
    shape_closure: $clr.structure
    shape_custom: red
    shape_datetime: $clr.literalish
    shape_directory: $clr.literalish_faint
    shape_external: $clr.main_color
    shape_externalarg: $clr.literalish_faint
    shape_external_resolved: $clr.main_color_bold
    shape_filepath: $clr.literalish_faint
    shape_flag: $clr.main_color
    shape_float: $clr.literalish
    shape_garbage: { fg: white, bg: red, attr: b}
    shape_globpattern: $clr.literalish_faint
    shape_int: $clr.literalish
    shape_internalcall: $clr.main_color_bold
    shape_keyword: $clr.operatorish_bold  # turns out this is stuff like the `=` in `alias cmd = expr
    shape_list: $clr.structure
    shape_literal: red
    shape_match_pattern: $clr.main_color_faint
    shape_matching_brackets: { attr: u }
    shape_nothing: $clr.literalish
    shape_operator: $clr.operatorish_bold
    shape_or: $clr.operatorish_bold
    shape_pipe: $clr.structure_bold
    shape_range: $clr.operatorish_bold
    shape_record: $clr.structure
    shape_redirection: $clr.operatorish_bold
    shape_signature: $clr.nameish
    shape_string: $clr.literalish_faint
    shape_string_interpolation: $clr.literalish_faint
    shape_table: $clr.structure
    shape_variable: $clr.nameish
    shape_vardecl: $clr.nameish
    shape_raw_string: $clr.literalish_faint
}
overlay use zero


# External completer example
# let carapace_completer = {|spans|
#     carapace $spans.0 nushell ...$spans | from json
# }

# The default config record. This is where much of your global configuration is setup.
$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup

    rm: {
        always_trash: true # always act as if -t was given. Can be overridden with -p
    }

    error_style: "fancy" # "fancy" or "plain" for screen reader-friendly error messages

    # datetime_format determines what a datetime rendered in the shell would look like.
    # Behavior without this configuration point will be to "humanize" the datetime display,
    # showing something like "a day ago."
    datetime_format: {
        normal: '%a, %d %b %Y %H:%M:%S %z'    # shows up in displays of variables or other datetime's outside of tables
        table: '%Y-%m-%d %H:%M:%S %z'        # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
    }

    history: {
        max_size: 100_000 # Session has to be reloaded for this to take effect
        sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
        file_format: "sqlite" # "sqlite" or "plaintext"
        isolation: true # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
    }

    completions: {
        use_ls_colors: true # set this to true to enable file/path/directory completions using LS_COLORS
    }

    filesize: {
        metric: false # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
        format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, auto
    }

    cursor_shape: {
        emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
        vi_insert: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
        vi_normal: underscore # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
    }

    color_config: $good_theme # if you want a more interesting theme, you can replace the empty record with `$dark_theme`, `$light_theme` or another custom record
    buffer_editor: "" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
    highlight_resolved_externals: true # true enables highlighting of external commands in the repl resolved by which.

    plugins: {} # Per-plugin configuration. See https://www.nushell.sh/contributor-book/plugins.html#configuration.

    plugin_gc: {
        # Configuration for plugin garbage collection
        default: {
            enabled: true # true to enable stopping of inactive plugins
            stop_after: 10sec # how long to wait after a plugin is inactive to stop it
        }
        plugins: {
            # alternate configuration for specific plugins, by name, for example:
            #
            # gstat: {
            #     enabled: false
            # }
        }
    }

    menus: [
        # Configuration for default nushell menus
        # Note the lack of source parameter
        {
            name: completion_menu
            only_buffer_difference: false
            marker: $"(ansi $clr.main_color)| "
            type: {
                layout: columnar
                columns: 4
                col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                col_padding: 2
            }
            style: {
                text: $clr.main_color
                selected_text: { attr: r }
                description_text: $clr.main_color_faint
                match_text: { attr: u }
                selected_match_text: { attr: ur }
            }
        }
        {
            name: ide_completion_menu
            only_buffer_difference: false
            marker: $"(ansi $clr.main_color)| "
            type: {
                layout: ide
                min_completion_width: 0,
                max_completion_width: 50,
                max_completion_height: 10, # will be limited by the available lines in the terminal
                padding: 0,
                border: true,
                cursor_offset: 0,
                description_mode: "prefer_right"
                min_description_width: 0
                max_description_width: 50
                max_description_height: 10
                description_offset: 1
                # If true, the cursor pos will be corrected, so the suggestions match up with the typed text
                #
                # C:\> str
                #      str join
                #      str trim
                #      str split
                correct_cursor_pos: false
            }
            style: {
                text: $clr.main_color
                selected_text: { attr: r }
                description_text: $clr.main_color_faint
                match_text: { attr: u }
                selected_match_text: { attr: ur }
            }
        }
        {
            name: history_menu
            only_buffer_difference: false
            marker: $"(ansi $clr.main_color)? "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: $clr.main_color
                selected_text: $clr.main_color_reverse
                description_text: $clr.main_color_faint
            }
        }
        {
            name: help_menu
            only_buffer_difference: true
            marker: $"(ansi $clr.main_color)? "
            type: {
                layout: description
                columns: 4
                col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                col_padding: 2
                selection_rows: 4
                description_rows: 10
            }
            style: {
                text: $clr.main_color
                selected_text: $clr.main_color_reverse
                description_text: $clr.main_color_faint
            }
        }
    ]

    keybindings: []
}

source ~/.zoxide.nu

overlay hide nuconfig
