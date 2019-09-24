#!/bin/bash

## Check to see if the 'cif-data' volume exists and create it if not
if [[ ! $(docker volume ls | grep cif-data) ]]; then
  echo "Creatings cif-data volume"
  docker volume create cif-data 2>&1
fi


## Check to see if 'cif.db' exists on the 'cif-data' volume
DB=$(docker run --rm -i -v=cif-data:/tmp/myvolume busybox find /tmp/myvolume/cif.db 2>&1)

if [[ $DB ]]; then
  if [[ $DB == "/tmp/myvolume/cif.db" ]]; then
    DBEXISTS=1
  else
    DBEXISTS=0
  fi
else
  DBEXISTS=0
fi

## Check to see if '.cif.yml' exists on the 'cif-data' volume
YML=$(docker run --rm -i -v=cif-data:/tmp/myvolume busybox find /tmp/myvolume/.cif.yml 2>&1)

if [[ $YML ]]; then
  if [[ $YML == "/tmp/myvolume/.cif.yml" ]]; then
    YMLEXISTS=1
  else
    YMLEXISTS=0
  fi
else
  YMLEXISTS=0
fi

## Check to see if 'csirtg-smrt.yml' exists on the 'cif-data' volume
SMRT=$(docker run --rm -i -v=cif-data:/tmp/myvolume busybox find /tmp/myvolume/csirtg-smrt.yml 2>&1)

if [[ $SMRT ]]; then
  if [[ $SMRT == "/tmp/myvolume/csirtg-smrt.yml" ]]; then
    SMRTEXISTS=1
  else
    SMRTEXISTS=0
  fi
else
  SMRTEXISTS=0
fi

## Check to see if 'cif-router.yml' exists on the 'cif-data' volume
RTR=$(docker run --rm -i -v=cif-data:/tmp/myvolume busybox find /tmp/myvolume/cif-router.yml 2>&1)

if [[ $RTR ]]; then
  if [[ $RTR == "/tmp/myvolume/cif-router.yml" ]]; then
    RTREXISTS=1
  else
    RTREXISTS=0
  fi
else
  RTREXISTS=0
fi

## If 'cif.db' or '.cif.yml' or 'csirtg-smrt.yml' or 'cif-router.yml'  does not exists on the volume, mount it to a temp comtainer and copy it over
if [[ ($DBEXISTS == 0) || ($YMLEXISTS == 0) || ($SMRTEXISTS == 0) || ($RTREXISTS == 0) ]]; then
  C=$(docker run --name cifv3-initial -it -d -p 5000:5000 -v cif-data:/cif-data cif-docker)
  if [[ $DBEXISTS == 0 ]]; then
    echo "cif.db does not exist on external volume, let's copy it over"
    docker exec -it $C cp /var/lib/cif/cif.db /cif-data
  fi
  if [[ $YMLEXISTS == 0 ]]; then  
    echo ".cif.yml does not exist on external volume, let's copy it over"
    docker exec -it $C cp /var/lib/cif/.cif.yml /cif-data
  fi
  if [[ $SMRTEXISTS == 0 ]]; then
    echo "csirtg-smrt.yml does not exist on external volume, let's copy it over"
    docker exec -it $C cp /var/lib/cif/csirtg-smrt.yml /cif-data
  fi
  if [[ $RTREXISTS == 0 ]]; then
    echo "cif-router.yml does not exist on external volume, let's copy it over"
    docker exec -it $C cp /var/lib/cif/cif-router.yml /cif-data
  fi
  docker stop cifv3-initial 2>&1
  docker rm cifv3-initial 2>&1
fi

D=$(docker run --name cifv3 -v cif-data:/var/lib/cif/ -it -d -p 5000:5000 cif-docker)

echo "Getting a shell into the cifv3 container..."
docker exec -it $D /bin/bash
