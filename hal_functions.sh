# Create a folder and move into it in one command
function mkcd() { mkdir -p "$@" && \cd "$_"; }

function vault_oidc() {
  local VAULT_ADDR=$1
  local VAULT_NAME=$2

  safe target --no-strongbox $VAULT_ADDR $VAULT_NAME
  safe vault token lookup

  if [ $? -ne 0 ]
  then
    VAULT_TOKEN=$( safe vault login -token-only -method=oidc )
    echo $VAULT_TOKEN | safe auth token
    safe vault token lookup
    safe renew &
  fi
  eval $(safe env --bash)
}
