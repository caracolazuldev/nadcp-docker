A conversation with ChatGPT on using watchers in docker containers.

## Run File System Watcher in a Container

Yes, you can run a filesystem watcher in a Docker container. One way to do this is to use a volume with the inotify option, which allows the container to receive filesystem events from the host. Here's an example command to start a container with webpack and a filesystem watcher:

``` bash
docker run -it --rm \
  -v /path/to/local/folder:/app \
  --mount type=bind,source=/path/to/local/folder,target=/app,volume-opt="type=volume,volume-driver=local,volume-opt=o=bind,uid=$(id -u),gid=$(id -g),device=:/path/to/local/folder,inotify=true" \
  node:latest \
  sh -c "npm install && webpack --watch"
```

In this command, the --mount option is used to create a bind mount volume with the inotify=true option. This tells Docker to use the inotify system call to send filesystem events from the host to the container.

Note that the volume-driver=local option is used to specify that the volume should be managed by the local driver, which is used by default on most Docker installations. The o=bind option specifies that the volume should be mounted as a bind mount, which means that changes made in the container will be reflected on the host, and vice versa.

Finally, the uid and gid options are used to specify the user and group IDs of the current user, so that file permissions are properly set in the container. The device= option is used to specify the path to the local folder on the host machine.

Once the container is running, you should be able to make changes to files in the /path/to/local/folder directory on the host, and webpack should automatically rebuild your project whenever a change is detected.

## Docker-Compose Implementation

Yes, you can use docker-compose run to run the shell service with additional arguments to enable inotify. Here's an example command:

``` bash
docker-compose run --rm \
  -e CHOKIDAR_USEPOLLING=false \
  -e CHOKIDAR_INTERVAL=500 \
  -e CHOKIDAR_BINARY=../../node_modules/chokidar-cli/lib/cli.js \
  -v /path/to/local/folder:/app \
  shell sh -c "npm install && webpack --watch"
```

> NB: appears we need to npm require chokidar in our project to use this, at least it is not currently resolved as a dependency that I can see.

In this command, we're using the docker-compose run command to run the shell service with a command to run npm install and webpack --watch. We're also passing in some environment variables that configure the chokidar watcher used by webpack to use polling instead of inotify. This is necessary because inotify doesn't work with bind-mounted directories, but polling does.

Note that we're using the -v option to mount the local folder into the container, just like in the docker run command. Also, the --rm option is used to automatically remove the container when it exits.

If you want to avoid modifying the existing docker-compose.yml file, you can create a new file called docker-compose.watch.yml with a new service definition that includes the necessary options for inotify. For example:

``` yaml
version: "3.9"

services:
  watch:
    image: node:latest
    command: sh -c "cd /app && npm install && webpack --watch"
    volumes:
      - type: bind
        source: /path/to/local/folder
        target: /app
        bind:
          propagation: rshared
        tmpfs:
          - /app/node_modules
    environment:
      - CHOKIDAR_USEPOLLING=false
      - CHOKIDAR_INTERVAL=500
      - CHOKIDAR_BINARY=../../node_modules/chokidar-cli/lib/cli.js
    # Use privileged mode to enable inotify
    privileged: true
```

In this file, we're defining a new service called watch that is based on the node image and includes the necessary options for inotify. We're using a bind mount volume with rshared propagation and a tmpfs mount for the node_modules directory to avoid permission issues. We're also using the privileged mode to enable inotify.

To run this new service, you can use the following command:

``` bash
docker-compose -f docker-compose.yml -f docker-compose.watch.yml up --build --remove-orphans
```

## Bind mounts and `inotify`

You're correct, it is possible to make bind mounts work with inotify, but it requires additional configuration and may not work in all cases.

By default, when a directory is bind-mounted into a Docker container, the container is not able to receive inotify events for that directory. This is because the host's inotify system call only reports events to the process that created the watch, and the container's inotify instance is not aware of the host's inotify events. To work around this, you can pass the inotify=true option when creating the bind mount, which tells Docker to use a custom inotify instance that communicates with the host's inotify events.

However, there are some limitations to this approach. For example, if the bind-mounted directory is on a network filesystem (such as NFS or SMB), inotify may not work correctly, or may not work at all. Additionally, some filesystems (such as ZFS) may have limitations on the number of inotify watches that can be created, which could cause inotify to fail when monitoring a large number of files.

In general, using polling instead of inotify is a more reliable and portable approach, as it doesn't depend on the host's filesystem or inotify implementation. However, if you're sure that your bind-mounted directory will work with inotify, and you're willing to accept the limitations and additional configuration, you can use the inotify option to enable inotify events in your bind-mounted directories.
