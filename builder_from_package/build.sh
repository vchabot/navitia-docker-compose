#!/bin/bash

function show_help() {
    cat << EOF
Usage: ${0##*/} [-lr] [-b branch] [-u user] [-p password]
    -b      git branch to build
    -l      tag images as lastest
    -r      push images to a docker registry
    -u      username for authentication on docker registry
    -p      password for authentication on docker registry
    -i      number of processors to ignore while compiling
EOF
}

#we want to be able to interupt the build, see: http://veithen.github.io/2014/11/16/sigterm-propagation.html
function run() {
    trap 'kill -TERM $PID' TERM INT
    $@ &
    PID=$!
    wait $PID
    trap - TERM INT
    wait $PID
    return $?
}

branch=dev
tag_latest=0
push=0
user=''
password=''
components='jormungandr kraken tyr-beat tyr-worker tyr-web instances-configurator'
navitia_local=0
nb_procs_to_ignore=0

while getopts "lrnb:u:p:i:" opt; do
    case $opt in
        b)
            branch=$OPTARG
            ;;
        p)
            password=$OPTARG
            ;;
        u)
            user=$OPTARG
            ;;
        l)
            tag_latest=1
            ;;
        r)
            push=1
            ;;
        i)
            nb_procs_to_ignore=$OPTARG
            ;;
        h|\?)
            show_help
            exit 1
            ;;
    esac
done

tag=test

for component in $components; do
    echo "*********  Building $component ***************"
    run docker build --no-cache -t navitia/$component:$tag -f  Dockerfile-${component}_debian8_dev .
    #     docker tag navitia/$component:$version navitia/$component:$branch
    # if [ $tag_latest -eq 1 ]; then
    #     docker tag navitia/$component:$version navitia/$component:latest
    # fi
done

# if [ $push -eq 1 ]; then
#     if [ -n $user ]; then docker login -u $user -p $password; fi
#     for component in $components; do
#         docker push navitia/$component:$version
#         docker push navitia/$component:$branch
#     if [ $tag_latest -eq 1 ]; then
#         docker push navitia/$component:latest
#     fi
#     done
#     if [ -n $user ]; then docker logout; fi
# fi

