source default_config.nu

$env.config.color_config = do {||
    let c = $env.kira.colors
    {
        separator: white
        leading_trailing_space_bg: { fg: "#505050", attr: s }
        header: $c.main_color_bold
        empty: red
        int: $c.literalish
        filesize: $c.literalish
        duration: $c.literalish
        date: $c.literalish
        range: $c.literalish
        float: $c.literalish
        string: white
        nothing: $c.literalish
        binary: $c.literalish
        cell_path: red
        row_index: $c.main_color_bold
        record: red
        list: red
        block: red
        hints: dark_gray
        search_result: { bg: red fg: white }
        shape_and: $c.operatorish_bold
        shape_binary: $c.literalish_faint
        shape_block: $c.structure
        shape_bool: $c.literalish
        shape_closure: $c.structure
        shape_custom: red
        shape_datetime: $c.literalish
        shape_directory: $c.literalish_faint
        shape_external: $c.main_color
        shape_externalarg: $c.literalish_faint
        shape_external_resolved: $c.main_color_bold
        shape_filepath: $c.literalish_faint
        shape_flag: $c.main_color
        shape_float: $c.literalish
        shape_garbage: { fg: white, bg: red, attr: b}
        shape_glob_interpolation: $c.literalish_faint
        shape_globpattern: $c.literalish_faint
        shape_int: $c.literalish
        shape_internalcall: $c.main_color_bold
        shape_keyword: $c.operatorish_bold
        shape_list: $c.structure
        shape_literal: red
        shape_match_pattern: $c.main_color_faint
        shape_matching_brackets: { attr: u }
        shape_nothing: $c.literalish
        shape_operator: $c.operatorish_bold
        shape_or: $c.operatorish_bold
        shape_pipe: $c.structure_bold
        shape_range: $c.operatorish_bold
        shape_record: $c.structure
        shape_redirection: $c.operatorish_bold
        shape_signature: $c.nameish
        shape_string: $c.literalish_faint
        shape_string_interpolation: $c.literalish_faint
        shape_table: $c.structure
        shape_variable: $c.nameish
        shape_vardecl: $c.nameish
        shape_raw_string: $c.literalish_faint
    }
}

$env.config.show_banner = false

$env.config.datetime_format.normal = '%a, %d %b %Y %H:%M:%S %z'
$env.config.datetime_format.table = '%Y-%m-%d %H:%M:%S %z'

$env.config.history.file_format = "sqlite"
$env.config.history.isolation = true

$env.config.highlight_resolved_externals = true

$env.config.menus = do {||
    let c = $env.kira.colors

    mut menus = $env.config.menus | reduce -f {} {|it, acc| $acc | insert $it.name $it }

    $menus.completion_menu.marker = $"(ansi $c.main_color)| (ansi reset)"
    $menus.completion_menu.style.text = $c.main_color
    $menus.completion_menu.style.description_text = $c.main_color_faint

    $menus.ide_completion_menu.marker = $"(ansi $c.main_color)| (ansi reset)"
    $menus.ide_completion_menu.style = $menus.completion_menu.style

    $menus.history_menu.marker = $"(ansi $c.main_color)? (ansi reset)"
    $menus.history_menu.style.text = $c.main_color
    $menus.history_menu.style.selected_text = $c.main_color_reverse
    $menus.history_menu.style.description_text = $c.main_color_faint

    $menus.help_menu.marker = $"(ansi $c.main_color)? (ansi reset)"
    $menus.help_menu.style = $menus.history_menu.style

    $menus | values
}

