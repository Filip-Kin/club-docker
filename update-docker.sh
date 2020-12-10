docker_user=filip96

docker_deploy() {
  name=$1
  version=$2

  printf 'Building %s\n' "$name:$version"

  cd $name.$version
  docker build --tag $docker_user/$name:$version .
  docker push $docker_user/$name:$version
  cd ..
}

docker_deploy club-nodejs 15
docker_deploy club-web basic
