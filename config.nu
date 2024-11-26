source default_config.nu

mut kira = $kira

$kira.scratch = {}

$kira.theme = {
    separator: white
    leading_trailing_space_bg: { fg: "#505050", attr: s } # no fg, no bg, attr none effectively turns this off
    header: $kira.colors.main_color_bold
    empty: red # .. isnt empty, in non-syntax-contexts, just nothing? i havent found cases where its displayed as "null" or something
    bool: $kira.colors.literalish
    int: $kira.colors.literalish
    filesize: $kira.colors.literalish
    duration: $kira.colors.literalish
    date: $kira.colors.literalish
    range: $kira.colors.literalish
    float: $kira.colors.literalish
    string: white
    nothing: $kira.colors.literalish
    binary: $kira.colors.literalish
    cell_path: red
    row_index: $kira.colors.main_color_bold
    record: red
    list: red
    block: red
    hints: dark_gray
    search_result: { bg: red fg: white }
    shape_and: $kira.colors.operatorish_bold
    shape_binary: $kira.colors.literalish_faint
    shape_block: $kira.colors.structure
    shape_bool: $kira.colors.literalish
    shape_closure: $kira.colors.structure
    shape_custom: red
    shape_datetime: $kira.colors.literalish
    shape_directory: $kira.colors.literalish_faint
    shape_external: $kira.colors.main_color
    shape_externalarg: $kira.colors.literalish_faint
    shape_external_resolved: $kira.colors.main_color_bold
    shape_filepath: $kira.colors.literalish_faint
    shape_flag: $kira.colors.main_color
    shape_float: $kira.colors.literalish
    shape_garbage: { fg: white, bg: red, attr: b}
    shape_glob_interpolation: $kira.colors.literalish_faint
    shape_globpattern: $kira.colors.literalish_faint
    shape_int: $kira.colors.literalish
    shape_internalcall: $kira.colors.main_color_bold
    shape_keyword: $kira.colors.operatorish_bold  # turns out this is stuff like the `=` in `alias cmd = expr
    shape_list: $kira.colors.structure
    shape_literal: red
    shape_match_pattern: $kira.colors.main_color_faint
    shape_matching_brackets: { attr: u }
    shape_nothing: $kira.colors.literalish
    shape_operator: $kira.colors.operatorish_bold
    shape_or: $kira.colors.operatorish_bold
    shape_pipe: $kira.colors.structure_bold
    shape_range: $kira.colors.operatorish_bold
    shape_record: $kira.colors.structure
    shape_redirection: $kira.colors.operatorish_bold
    shape_signature: $kira.colors.nameish
    shape_string: $kira.colors.literalish_faint
    shape_string_interpolation: $kira.colors.literalish_faint
    shape_table: $kira.colors.structure
    shape_variable: $kira.colors.nameish
    shape_vardecl: $kira.colors.nameish
    shape_raw_string: $kira.colors.literalish_faint
}

$env.config.show_banner = false

$env.config.datetime_format.normal = '%a, %d %b %Y %H:%M:%S %z'
$env.config.datetime_format.table = '%Y-%m-%d %H:%M:%S %z'

$env.config.history.file_format = "sqlite"
$env.config.history.isolation = true

$env.config.color_config = $kira.theme

$env.config.highlight_resolved_externals = true

$kira.scratch.menus = $env.config.menus | reduce -f {} {|it, acc| $acc | insert $it.name $it }

$kira.scratch.menus.completion_menu.marker = $"(ansi $kira.colors.main_color)| (ansi reset)"
$kira.scratch.menus.completion_menu.style.text = $kira.colors.main_color
$kira.scratch.menus.completion_menu.style.description_text = $kira.colors.main_color_faint

$kira.scratch.menus.ide_completion_menu.marker = $"(ansi $kira.colors.main_color)| (ansi reset)"
$kira.scratch.menus.ide_completion_menu.style = $kira.scratch.menus.completion_menu.style

$kira.scratch.menus.history_menu.marker = $"(ansi $kira.colors.main_color)? (ansi reset)"
$kira.scratch.menus.history_menu.style.text = $kira.colors.main_color
$kira.scratch.menus.history_menu.style.selected_text = $kira.colors.main_color_reverse
$kira.scratch.menus.history_menu.style.description_text = $kira.colors.main_color_faint

$kira.scratch.menus.help_menu.marker = $"(ansi $kira.colors.main_color)? (ansi reset)"
$kira.scratch.menus.help_menu.style = $kira.scratch.menus.history_menu.style

$env.config.menus = $kira.scratch.menus | values

let kira = $kira

