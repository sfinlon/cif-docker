#!/bin/bash

## Check to see if the 'cif-data' volume exists and create it if not
if [[ ! $(docker volume ls | grep cif-data) ]]; then
  echo "Creatings cif-data volume"
  docker volume create cif-data 2>&1
fi


## Check to see if 'cif.db' exists on the 'cif-data' volume
RESULT=$(docker run --rm -i -v=cif-data:/tmp/myvolume busybox find /tmp/myvolume/cif.db 2>&1)

if [[ $RESULT ]]; then
  if [[ $RESULT == "/tmp/myvolume/cif.db" ]]; then
    EXISTS=1
  else
    EXISTS=0
  fi
else
  EXISTS=0
fi

## If 'cif.db' does not exists on the volume, mount it to a temp comtainer and copy it over
if [[ $EXISTS == 0 ]]; then
  echo "cif.db does not exist on external volume, let's copy it over"
  C=$(docker run --name cifv3-initial -it -d -p 5000:5000 -v cif-data:/cif-data cif-docker)
  docker exec -it $C cp /var/lib/cif/cif.db /cif-data
  docker stop cifv3-initial 2>&1
  docker rm cifv3-initial 2>&1
fi

D=$(docker run --name cifv3 -v cif-data:/var/lib/cif/ -it -d -p 5000:5000 cif-docker)

echo "Getting a shell into the cifv3 container..."
docker exec -it $D /bin/bash
