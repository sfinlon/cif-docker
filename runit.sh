#!/bin/bash
C=$(docker run --name cifv3 -it -d -p 5000:5000 cif-docker)

echo "Getting a shell into the container..."
docker exec -it $C /bin/bash
