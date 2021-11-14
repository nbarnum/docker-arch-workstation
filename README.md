# Docker Arch Workstation

Dockerfile to build an Arch Linux container image with my preferred tools pre-installed.

## Building

```shell
$ docker build -t arch-workstation .
Sending build context to Docker daemon    108kB
Step 1/19 : FROM archlinux:base
...
Successfully built 90600f001c0e
Successfully tagged arch-workstation:latest
```

*_Warning: Docker image is large, > 3 GB unextracted on disk_*

## Running

Run the docker image interactively, creating a bind mount for the home directory to preserve files between runs:

```shell
$ mkdir -p arch-home

$ docker run --rm -it \
    -h arch \
    -v $(pwd)/arch-home:/home/arch \
    arch-workstation:latest
```

The `docker run` above drops us into an interactive zsh shell inside the arch container:

![Arch zsh shell](/images/arch_neofetch.png)
