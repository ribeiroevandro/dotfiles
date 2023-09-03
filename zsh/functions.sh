function vega() {
  cd ~/www/work/vegacheckout
}

function remove() {
  rm -rf $1
}

function app() {
  case $1 in
    "--aab")
      msg_init "Generating .aab file"
      cd android && ./gradlew bundleRelease && cd ..
      msg_ok ".aab file generated successfully"
      ;;
    "--apk")
      msg_init "Generating .apk file"
      cd android && ./gradlew assembleRelease && cd ..
      msg_ok ".apk file generated successfully"    
      ;;
    "--clean")
      msg_init "Cleaning build folder on Android"
      cd android && ./gradlew clean && cd ../
      msg_ok "Successfully clean build folder"
      ;;
    *)
      msg_error "Informe o comando"
      ;;
  esac
}

function valet_link() {
  project=$1
  full_directory=$(pwd)

  if [[ -z "$project" ]]; then
    project=$(basename "$PWD")
  fi

  eval "ln -s $full_directory ~/www/valet/$project"
  valet secure $project
  open "https://$project.dev"
}

function push () {
  git push origin $(git_current_branch) $@
}

function pull () {
  git pull origin $(git_current_branch) $@
}

function delete-branches () {
   for i in $(git branch | grep -v -E -w '(main|develop)$'); do
    git branch -D "$i"
  done
}

