# Main Entrypoint for all HAL Development Environment Profiles
function load_script() {
  SCRIPT_NAME=$1
  [ -x "$SCRIPT_NAME" ] && . "$SCRIPT_NAME"
}

load_script "$HOME/.hal_aliases.sh"
load_script "$HOME/.hal_functions.sh"
load_script "$HOME/.hal_kubectl.sh"
