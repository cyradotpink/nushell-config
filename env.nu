# Nushell Environment Config File
#
# version = "0.95.0"

overlay new nuconfig
mut clr = {}
$clr.main_color = "#fdbb4b"
$clr.main_color_faint = "#fcdca4"
$clr.literalish = "#45e8cf"
# $clr.literalish_faint = "#8be8da"
$clr.literalish_faint = $clr.main_color_faint
$clr.operatorish = "#ff6696"
# $clr.structure = "#fcdca4"
$clr.structure = "#ffccdc"
# $clr.structure = $clr.operatorish
$clr.nameish = "#f67300"
$clr.main_color_bold = { fg: $clr.main_color, attr: b }
$clr.main_color_faint_bold = { fg: $clr.main_color_faint, attr: b }
$clr.main_color_reverse = { bg: $clr.main_color, fg: "#000000" }
$clr.main_color_reverse_bold = { bg: $clr.main_color, fg: "#000000", attr: b }
$clr.main_color_veryfaint_reverse = { bg: "#fce9c9", fg: "#000000"}
$clr.literalish_faint_bold = { fg: $clr.literalish_faint, attr: b }
$clr.operatorish_bold = { fg: $clr.operatorish, attr: b }
$clr.literalish_bold = { fg: $clr.literalish, attr: b }
$clr.structure_bold = { fg: $clr.structure, attr: b }
$clr.nameish_bold = { fg: $clr.nameish, attr: b }
let clr = $clr
$env.THEME_COLORS = $clr
overlay use zero

use /home/cyra/Documents/code/nucmds/startup.nu *

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
# use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

$env.NU_DEPTH = (try { ($env.NU_DEPTH | into int) + 1 } catch { 0 })
$env.EDITOR = "nano"
$env.SCCACHE = "/home/cyra/.cargo/bin/sccache"
# $env.JAVA_HOME = /usr/lib/jvm/java-17-openjdk

$env.PATH = ($env.PATH | append "/home/cyra/opt/binsyms")
$env.PATH = ($env.PATH | append "/home/cyra/.deno/bin")
$env.PATH = ($env.PATH | prepend "/home/cyra/.cargo/bin")
$env.PATH = ($env.PATH | prepend "/home/cyra/opt/texlive/2023/bin/x86_64-linux")
$env.PATH = ($env.PATH | append "/home/cyra/opt/gradle/bin")
$env.PATH = ($env.PATH | append "/home/cyra/.local/share/JetBrains/Toolbox/scripts")

$env.PATH = ($env.PATH | prepend "/home/cyra/.local/share/fnm")
load-env (fnm env --json | from json)
$env.PATH = ($env.PATH | prepend $"($env.FNM_MULTISHELL_PATH)/bin")

zoxide init --cmd y nushell | save -f ~/.zoxide.nu


def create_left_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi $clr.main_color_reverse_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi $clr.main_color_reverse })
    let path_segment = $"($path_color)($dir)"
    let depth_indicator = if $env.NU_DEPTH > 0 {
        $"(ansi $clr.main_color_veryfaint_reverse)(char -u '203A')($env.NU_DEPTH | into string)(char -u '2039')(ansi reset)"
    } else { '' }

    (
        $"(ansi reset)" +
        $depth_indicator +
        ($path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)") +
        $"(ansi reset)"
    )
}

def create_right_prompt [] {
    let time = date now
    mut time_string = ""
    mut time_segment = ['%Y', '%m', '%d', '%H', '%M', '%S']
        | each {|it| $time | format date $it }
        | zip [(char -u '00B7'), (char -u '00B7'), ' ', ':', ':', $" \(($time | timezone | get name))"]
        | each {|it| $"(ansi reset)(ansi $clr.main_color_reverse_bold)($it.0)(ansi reset)(ansi $clr.main_color_reverse)($it.1)"}
        | str join

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi reset)
        (ansi bg_red)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| $"(ansi {fg: $clr.main_color, attr: b})(char -u "203A") " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| $"(ansi $clr.main_color): " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| $"(ansi $clr.main_color)> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| $"(ansi $clr.main_color)::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

overlay hide nuconfig
