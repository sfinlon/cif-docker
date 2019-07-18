# cif-docker Version 3.0.4
Docker container for CIFv3 (Bearded Avenger)

https://github.com/csirtgadgets/bearded-avenger-deploymentkit/wiki

https://github.com/csirtgadgets/bearded-avenger-deploymentkit/releases

This will create look for and create a 'cif-data' volume to store the cif.db database.
This will allow the tokens/indicators to be persistent across container rebuilds.

# Build the container by running:
```
bash buildit.sh
```

# Run the container and enter the interactive shell:
```
bash runit.sh
```

# Get an interactive shell if the container is already running:
```
docker exec -it cifv3 /bin/bash
```

# Test Setup
Once you have a shell, become the cif user:
```
# su cif
```

You can check the tokens to make sure your access is setup correctly
```
$ cif-tokens
```

Ping the router to ensure connectivity
```
$ cif -p
```

# Docker Volumes/Overrides
```
Configuration Data:
/etc/cif
```

```
Log Files:
/var/log/cif
```

```
SQLite DB and all run-paths:
/var/lib/cif
```

# Docker Maintainer:

Scott Finlon (@sfinlon)

# COPYRIGHT AND LICENSE

Copyright (C) 2017-2019 [the CSIRT Gadgets Foundation](http://csirtgadgets.org)

See: [LICENSE](https://github.com/ventz/docker-cif/blob/master/LICENSE)
