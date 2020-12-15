# About

This project aims at building a set of docker images for navitia.

This will create 6 images :

 - navitia/kraken:version
 - navitia/jormungandr:version
 - navitia/tyr-beat:version
 - navitia/tyr-web:version
 - navitia/tyr-worker:version
 - navitia/instances-configurator:version

The images are based on the navitia/debian8_dev docker image defined in https://github.com/CanalTP/navitia_docker_images.

In order to build the different images, the navitia debian packages are retreived from github using (https://github.com/CanalTP/core_team_ci_tools).

The `version` tag is determined from `git describe` called on the navitia source code used for building the images.

The script `build.sh` retreive the navitia source code along with the debian packages, and then launch docker build on each Dockerfile-*.


# Usage 

Note : you need an internet access, and an access to the internal canaltp apt repository http://apt.canaltp.local/debian/repositories (works when on VPN)

Usage
```
./build.sh -o github_oauth_token -b branch [-t tag] [-r -u dockerhub_user -p dockerhub_password] 

```
where :

 - `github_oauth_token` is an oauth token to access github repositories with the `repo` scope. See https://docs.github.com/en/free-pro-team@latest/github/extending-github/git-automation-with-oauth-tokens
 - `branch` is either `dev` or `release`. It will fetch code and packages from the head of CanalTP/navitia branch dev\release to build the images
 - if the optional `tag` is provided, then the images will also be tagged as `navitia/component:tag` besides the default tag `navitia/component:version` 
 - if the optional `-r -u dockerhub_user -p dockerhub_password` is given, the built images will be push to dockerhub. Note that if `-t tag` is present, then the `navitia/component:tag` images will be pushed to dockerhub along with the `navitia/component:version` ones.