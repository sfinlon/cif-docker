# cif-docker Version 3.0.8
Docker container for CIFv3 (Bearded Avenger)

https://github.com/csirtgadgets/bearded-avenger-deploymentkit/wiki

https://github.com/csirtgadgets/bearded-avenger-deploymentkit/releases

This will create look for and create 'cif-config' 'cif-logs' and 'cif-db' volumes to store persistent data.
This will allow the tokens/indicators to be stored across container rebuilds.

# Build the container by running:
```bash
docker-compose build
```

# Start the container
```bash
docker-compose up -d
```

# Get an interactive shell if the container is already running:
```bash
docker-compose exec cif /bin/bash
```

# Test Setup
Once you have a shell, become the cif user:
```bash
# su cif
```

You can check the tokens to make sure your access is setup correctly
```bash
$ cif-tokens
```

Ping the router to ensure connectivity
```bash
$ cif -p
```

# Docker Volumes/Overrides
- configuration
```bash
cif-config:/etc/cif
```
- logs
```bash
cif-logs:/var/log/cif
```
- CIF SQLite database
```bash
cif-db:/var/lib/cif
```

# s6 init

## docker-compose.override.yml

    ---

    version: '3'

    services:
      cif:
        build:
          dockerfile: Dockerfile.s6
        image: cif-docker-s6
        #volumes:
        #  - ./db-sqlite:/db-sqlite

- build the image "cif-docker-s6"
```bash
docker-compose build
```

## s6 - import sqlite cif.db

This imports cif.db and api keys into the container at runtime.
* changes to the db will not persist across sessions
* this only works for sqlite based installs (no Elastic support)

1. get the following files from an existing install:
    ```
    /var/lib/cif/cif.db
    /var/lib/cif/cif-router.yml
    /var/lib/cif/csirtg-smrt.yml
    /home/cif/.cif.yml
    ```

1. create the folder db-sqlite and uncomment the volumes section of
  docker-compose.override.yml

1. place the files in the db-sqlite folder (and rename .cif.yml to cif.yml)


# Docker Maintainer:

Scott Finlon (@sfinlon)

# COPYRIGHT AND LICENSE

Copyright (C) 2017-2020 [the CSIRT Gadgets Foundation](http://csirtgadgets.org)

See: [LICENSE](https://github.com/ventz/docker-cif/blob/master/LICENSE)
