
# Interactive Docker Containers

When running a script interactively in a Docker container, you may encounter issues with input and output buffering. By default, Docker buffers the output of a container, which can cause delays and unexpected behavior when using interactive scripts that rely on real-time input.

To work around this, you can use the --tty and --interactive options when running the container with the docker run command. The --tty option allocates a pseudo-tty for the container, while the --interactive option keeps the container running in the foreground, allowing you to interact with it in real-time.

Here's an example docker run command that runs a container interactively with a pseudo-tty:

``` bash
docker run --tty --interactive <image-name> <command>
```

To use docker-compose, you can add the following options to your service definition:

``` yaml
services:
  myservice:
    image: <image-name>
    tty: true
    stdin_open: true
```

The tty and stdin_open options are equivalent to the --tty and --interactive options used with docker run.

Once you've started your container with these options, your awk script should be able to use readline and receive real-time input from the user without buffering issues.
