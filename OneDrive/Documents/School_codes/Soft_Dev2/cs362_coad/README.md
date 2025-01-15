# Getting the Docker Container Running

## Installation and Setup (Docker Compose)

1. Build the docker image. This will take a while, 10-20 minutes.

   Mac and Windows:

   ```
   docker compose build
   ```

   Linux:

   ```
   MYUID=$(id -u) MYGID=$(id -g) docker compose build
   ```

2. Clone your fork of the `cs362-coad-resources` repo in the same
   directory as the `Dockerfile`.

## Running

Run the container.

```
docker compose run --service-ports --rm coad bash
```

Any edits you make outside the container in your `cs362-coad-resources`
directory will be reflected inside the container, and the other way
around. (`vim` and `nano` are installed in the container.)

Any edits you make to other files in `/home/user`, but **not** in the
COAD directory will persist from run to run.

You can exit the container by typing `exit` or hitting `CTRL-D` at the
shell prompt.

At this point, you can follow the README in the COAD repo, running those
commands in the container.

## Hints on Getting It All Working

As you follow the README in the COAD repo, there might be some hitches.

* Maybe the bundler version doesn't work out. Examine the output for
  hints.

* If `rails` isn't found, it might be because the rbenv environment
  manager hasn't set up its "shim" yet. Try `rbenv rehash` then run
  Rails again.

* When the server is running on port 3000, if you try to get there with
  [`http://localhost:3000/`](http://localhost:3000/) , you might get a
  "connection reset" error message. When you run the rails server, you
  have to do this to get the port exported from the container correctly:

  ```
  rails server -b 0.0.0.0
  ```

* Does running `rspec` give warnings? [See if this
  helps.](https://stackoverflow.com/questions/67773514/getting-warning-already-initialized-constant-on-assets-precompile-at-the-time)
  <!-- TLDR add `gem 'net-http'` to the Gemfile then `bundle install` -->

## Getting it Running Manually

You don't need this section if you're using Docker Compose, above. And
you should use Docker Compose. But read on if you want to see some of
the Docker commands Compose is using behind the scenes.

### Installation and Setup (Manual)

1. Build the docker image.

   Mac and Linux:

   ```
   docker build \
       --build-arg MYUID=$(id -u) \
       --build-arg MYGID=$(id -g) \
       -t ubuntu_lunar .
   ```

   Windows:

   ```
   docker build \
       -t ubuntu_lunar .
   ```

2. Create a Volume for the home directory.

   ```
   docker volume create ubuntu_lunar_home
   ```

3. Clone your fork of the `cs362-coad-resources` repo.

### Running (Manual)

Run the container. Modify this command line so that `ABSOLUTE_PATH_TO`
is replaced by the full path to get to `cs362-coad-resources`:

```
docker run \
    --mount source=ubuntu_lunar_home,target=/home/user \
    --mount type=bind,source=ABSOLUTE_PATH_TO/cs362-coad-resources,target=/home/user/cs362-coad-resources \
    -p 3000:3000 \
    -it ubuntu_lunar /bin/bash
```

