# docker-baseimage-xenial-x

This is a Docker base image based on xenial. It allows a user called *abc* to run X programs with video and audio from within a container.

## Prerequisites
* X server installed on host OS (must be with a window manger)
* Allow connections to the X server. Either by running *xhost +* as the user starting the X session on the host OS from cli, or by entering *xhost +* into the *~/.xsessionrc* file as the user starting the X session on the host OS (create the file if it doesn't exist)

## Supported GFX drivers
* nvidia, nouveau, radeon, i810, i815, i830, i845, i855, i865, i915, i945, i965
* Other drivers are probably supported too. If your driver is not listed above, try to run the container without the GFX_DRIVER parameter and report back if it works.

## Usage
```
docker run -d --privileged -v /tmp:/tmp -e GFX_DRIVER=<driver> --name=gui nicjo814/docker-baseimage-xenial-x
```

Optionally a folder on the host OS may be mounted to the /config folder in the container by adding the parameter -v /path/to/host/folder:/config

## Example how to get handbrake-gtk running
* Start a new container according to the instructions above
* Start up a bash shell within the container via ```docker exec -it gui bash```
* Run the following commands within the new shell
```
apt-get update
apt-get install software-properties-common python-software-properties
add-apt-repository ppa:stebbins/handbrake-releases
apt-get update
apt-get install handbrake-gtk
ghb
```
