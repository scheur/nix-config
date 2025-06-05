# Nushell Environment Config File
# This file is loaded before config.nu

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

def create_right_prompt [] {
    # Empty right prompt for now
    ""
}

# Set up the prompt
$env.STARSHIP_SHELL = "nu"
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
$env.PROMPT_INDICATOR = {|| "" }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "〉" }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running commands (to_string)
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
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
    ($nu.data-dir | path join 'completions')
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

# Add common paths
$env.PATH = ($env.PATH | 
    split row (char esep) | 
    prepend /opt/homebrew/bin |
    prepend /usr/local/bin |
    prepend ~/.cargo/bin |
    append ~/.local/bin |
    uniq)

# Shell indicator for starship
$env.SHELL_ICON = "🦀"

# Editor
$env.EDITOR = "vim"
$env.VISUAL = "vim"

# Source vendor scripts (already initialized)
source ($nu.data-dir | path join "vendor/autoload/starship.nu")
source ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
source ($nu.data-dir | path join "vendor/autoload/atuin.nu")
source ($nu.data-dir | path join "vendor/autoload/carapace.nu")

# Load custom modules
source ($nu.default-config-dir | path join 'scripts' 'parallel-dev.nu')
