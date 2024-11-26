source default_env.nu

mut kira = {}

$kira.colors = {}
$kira.colors.main_color = "#fdbb4b"
$kira.colors.main_color_faint = "#fcdca4"
$kira.colors.literalish = "#45e8cf"
$kira.colors.literalish_faint = $kira.colors.main_color_faint
$kira.colors.operatorish = "#ff6696"
$kira.colors.structure = "#ffccdc"
$kira.colors.nameish = "#f67300"
$kira.colors.main_color_bold = { fg: $kira.colors.main_color, attr: b }
$kira.colors.main_color_faint_bold = { fg: $kira.colors.main_color_faint, attr: b }
$kira.colors.main_color_reverse = { bg: $kira.colors.main_color, fg: "#000000" }
$kira.colors.main_color_reverse_bold = { bg: $kira.colors.main_color, fg: "#000000", attr: b }
$kira.colors.main_color_veryfaint_reverse = { bg: "#fce9c9", fg: "#000000"}
$kira.colors.literalish_faint_bold = { fg: $kira.colors.literalish_faint, attr: b }
$kira.colors.operatorish_bold = { fg: $kira.colors.operatorish, attr: b }
$kira.colors.literalish_bold = { fg: $kira.colors.literalish, attr: b }
$kira.colors.structure_bold = { fg: $kira.colors.structure, attr: b }
$kira.colors.nameish_bold = { fg: $kira.colors.nameish, attr: b }

let kira = $kira

use ~/Documents/code/nucmds/startup.nu *

$env.NU_DEPTH = if (procfs exe (procfs status $nu.pid | get p_pid)) == (procfs exe $nu.pid) {
    try { ($env.NU_DEPTH | into int) + 1 } catch { 0 }
} else {
    0
}
$env.EDITOR = "nvim"
$env.SCCACHE = $env.HOME + "/.cargo/bin/sccache"

# $env.JAVA_HOME = /usr/lib/jvm/java-17-openjdk
$env.PATH = ($env.PATH | append ($env.HOME + "/.local/opt/bin"))
$env.PATH = ($env.PATH | append ($env.HOME + "/.deno/bin"))
$env.PATH = ($env.PATH | append ($env.HOME + "/opt/gradle/bin"))
$env.PATH = ($env.PATH | append ($env.HOME + "/.local/share/JetBrains/Toolbox/scripts"))
$env.PATH = ($env.PATH | append ($env.HOME + "/.ghcup/bin"))
$env.PATH = ($env.PATH | prepend ($env.HOME + "/.cargo/bin"))
$env.PATH = ($env.PATH | prepend ($env.HOME + "/opt/texlive/2023/bin/x86_64-linux"))
$env.PATH = ($env.PATH | prepend ((pyenv root) + "/shims"))
$env.PATH = ($env.PATH | prepend ($env.HOME + "/.local/share/fnm"))
load-env (fnm env --json | from json)
$env.PATH = ($env.PATH | prepend $"($env.FNM_MULTISHELL_PATH)/bin")

def create_left_prompt_custom [] {
    let time = date now
    let time_segment = $"(ansi $kira.colors.main_color_veryfaint_reverse) ($time | format date '%H:%M:%S') (timezone | get name) (ansi reset)"

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi bg_red)
        "["
        ($env.LAST_EXIT_CODE)
        "]"
        (ansi reset)
    ] | str join)
    } else { "" }

    let pwd = $env.PWD | path split | skip 1
    let home = $env.HOME | path split | skip 1
    let is_inhome = ($pwd | first ($home | length)) == $home
    let path_nodes = (if $is_inhome { $pwd | skip ($home | length) } else { $pwd }) | each {|it| $"(ansi reset)(ansi $kira.colors.main_color_reverse_bold)($it)"}
    let path_parts = 0..<($path_nodes | length) | each { $"(ansi reset)(ansi $kira.colors.main_color_reverse)/" } | zip $path_nodes | flatten
    let dir = $"(ansi $kira.colors.main_color_reverse_bold) (if $is_inhome { "~" } else { "" })($path_parts | str join) (ansi reset)"

    # let path_color = (if (is-admin) { ansi red_bold } else { ansi $kira.colors.main_color_reverse_bold })
    # let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi $kira.colors.main_color_reverse })
    # let path_segment = $"($path_color) ($dir) "

    let depth_indicator = if $env.NU_DEPTH > 0 {
        $"(ansi $kira.colors.main_color_veryfaint_reverse)(char -u '203A')($env.NU_DEPTH | into string)(char -u '2039')(ansi reset)"
    } else { '' }

    (
        (ansi reset) +
        $depth_indicator +
        $last_exit_code +
        $time_segment +
        $dir +
        $"(ansi reset)" +
        $"\n(char -u '200B')"
    )
}

def create_right_prompt_custom [] {
    let time = date now
    mut time_string = ""
    mut time_segment = ['%Y', '%m', '%d', '%H', '%M', '%S']
        | each {|it| $time | format date $it }
        | zip [(char -u '00B7'), (char -u '00B7'), ' ', ':', ':', $" \(($time | timezone | get name))"]
        | each {|it| $"(ansi reset)(ansi $kira.colors.main_color_reverse_bold)($it.0)(ansi reset)(ansi $kira.colors.main_color_reverse)($it.1)"}
        | str join

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi reset)
        (ansi bg_red)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

$env.PROMPT_COMMAND = {|| create_left_prompt_custom }
$env.PROMPT_COMMAND_RIGHT = {|| }

$env.PROMPT_INDICATOR = {|| $"(ansi {fg: $kira.colors.main_color, attr: b})(char -u "203A") (ansi reset)" }
$env.PROMPT_INDICATOR_VI_INSERT = {|| $"(ansi $kira.colors.main_color): (ansi reset)" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| $"(ansi $kira.colors.main_color)> (ansi reset)" }
$env.PROMPT_MULTILINE_INDICATOR = {|| $"(ansi $kira.colors.main_color)::: (ansi reset)" }

