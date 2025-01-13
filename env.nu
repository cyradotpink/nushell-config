source default_env.nu

$env.kira = {}
$env.kira.colors = do {
    mut c = {}
    $c.main_color = "#fdbb4b"
    $c.main_color_faint = "#fcdca4"
    $c.literalish = "#45e8cf"
    $c.literalish_faint = $c.main_color_faint
    $c.operatorish = "#ff6696"
    $c.structure = "#ffccdc"
    $c.nameish = "#f67300"
    $c.main_color_bold = { fg: $c.main_color, attr: b }
    $c.main_color_faint_bold = { fg: $c.main_color_faint, attr: b }
    $c.main_color_reverse = { bg: $c.main_color, fg: "#000000" }
    $c.main_color_reverse_bold = { bg: $c.main_color, fg: "#000000", attr: b }
    $c.main_color_veryfaint_reverse = { bg: "#fce9c9", fg: "#000000"}
    $c.literalish_faint_bold = { fg: $c.literalish_faint, attr: b }
    $c.operatorish_bold = { fg: $c.operatorish, attr: b }
    $c.literalish_bold = { fg: $c.literalish, attr: b }
    $c.structure_bold = { fg: $c.structure, attr: b }
    $c.nameish_bold = { fg: $c.nameish, attr: b }
    $c
}

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
$env.PATH = ($env.PATH | append ($env.HOME + "/.cargo/bin"))
$env.PATH = ($env.PATH | append ($env.HOME + "/opt/texlive/2023/bin/x86_64-linux"))
$env.PATH = ($env.PATH | append ((pyenv root) + "/shims"))
$env.PATH = ($env.PATH | append ($env.HOME + "/.local/share/fnm"))
load-env (fnm env --json | from json)
$env.PATH = ($env.PATH | append $"($env.FNM_MULTISHELL_PATH)/bin")

$env.PROMPT_COMMAND = {||
    let c = $env.kira.colors
    let time = date now
    let time_segment = $"(ansi $c.main_color_veryfaint_reverse) ($time | format date '%H:%M:%S') (timezone | get name) (ansi reset)"

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
    let path_nodes = (if $is_inhome { $pwd | skip ($home | length) } else { $pwd }) | each {|it| $"(ansi reset)(ansi $c.main_color_reverse_bold)($it)"}
    let path_parts = 0..<($path_nodes | length) | each { $"(ansi reset)(ansi $c.main_color_reverse)/" } | zip $path_nodes | flatten
    let dir = $"(ansi $c.main_color_reverse_bold) (if $is_inhome { "~" } else { "" })($path_parts | str join) (ansi reset)"

    let depth_indicator = if $env.NU_DEPTH > 0 {
        $"(ansi $c.main_color_veryfaint_reverse)(char -u '203A')($env.NU_DEPTH | into string)(char -u '2039')(ansi reset)"
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

# $env.PROMPT_COMMAND_RIGHT = {||
#     let c = $env.kira.colors
#     let time = date now
#     mut time_string = ""
#     mut time_segment = ['%Y', '%m', '%d', '%H', '%M', '%S']
#         | each {|it| $time | format date $it }
#         | zip [(char -u '00B7'), (char -u '00B7'), ' ', ':', ':', $" \(($time | timezone | get name))"]
#         | each {|it| $"(ansi reset)(ansi $c.main_color_reverse_bold)($it.0)(ansi reset)(ansi $c.main_color_reverse)($it.1)"}
#         | str join
#
#     let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
#         (ansi reset)
#         (ansi bg_red)
#         ($env.LAST_EXIT_CODE)
#     ] | str join)
#     } else { "" }
#
#     ([$last_exit_code, (char space), $time_segment] | str join)
# }
$env.PROMPT_COMMAND_RIGHT = {|| ''}

$env.PROMPT_INDICATOR = {|| $"(ansi $env.kira.colors.main_color_bold)(char -u "21AA") (ansi reset)" }
$env.PROMPT_INDICATOR_VI_INSERT = {|| $"(ansi $env.kira.colors.main_color_bold): (ansi reset)" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| $"(ansi $env.kira.colors.main_color_bold)> (ansi reset)" }
$env.PROMPT_MULTILINE_INDICATOR = {|| $"(ansi $env.kira.colors.main_color_bold)::: (ansi reset)" }

