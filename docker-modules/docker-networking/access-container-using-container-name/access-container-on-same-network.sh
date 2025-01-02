$ docker network create my-network
$ docker run --net my-network busybox:latest ping test
