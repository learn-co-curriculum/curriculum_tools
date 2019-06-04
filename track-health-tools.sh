# Written for Bash, usable in Zsh
# By Robert Cobb (robert.cobb@flatironschool.com)

function hub-gh-token() {
  local token=$(cat ~/.config/hub | grep token | cut -d ' ' -f 4)
  [ -n "$token" ] && echo "$token" || >&2 echo "No hub token found, need to configure hub's token"
}

function gh-rate-limit-check() {
  command -v jq
  if [ $? -ne 0 ]
  then
    echo "Must have the `jq` program installed exist" >&2
  fi
  curl -s -H "Authorization: token $(hub-gh-token)" -X GET https://api.github.com/rate_limit | jq '.rate.remaining'
}

function git-check-remote() {
  local UPSTREAM=${1:-'@{u}'}
  local LOCAL=$(git rev-parse @)
  local REMOTE=$(git rev-parse "$UPSTREAM")
  local BASE=$(git merge-base @ "$UPSTREAM")

  if [ $LOCAL = $REMOTE ]; then
    true
  elif [ $LOCAL = $BASE ]; then
    echo "Need to pull"
  elif [ $REMOTE = $BASE ]; then
    echo "Need to push"
  else
    echo "Diverged"
  fi
}

function git-check-status() {
  git remote update &>/dev/null
  local status=$(git-check-remote)
  local pwd=$(pwd)
  local dir=$(basename "$pwd")
  [ -n "$status" ] && echo "$dir: $status";
}

function check-track-git-status() {
  local pwd=$(pwd)
  for f in $(ls);
  do
    cd $f && git-check-status;
    cd "$pwd";
  done
  cd "$pwd";
}
