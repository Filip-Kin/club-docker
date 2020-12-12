docker_user=filip96

docker_deploy() {
  tag=$1
  folder=$1
  if [ -n "$2" ]; then
    tag="$1:$2"
    folder="$1.$2"
  fi

  printf 'Building %s\n' "$tag"

  cd $folder
  docker build --tag $docker_user/$tag .
  docker push $docker_user/$tag
  cd ..
}

docker_deploy club-base
docker_deploy club-nodejs 15
docker_deploy club-go 1.15
docker_deploy club-web basic
