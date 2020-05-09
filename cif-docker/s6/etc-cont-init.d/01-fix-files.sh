#!/usr/bin/with-contenv bash

set -e
rm -f /tmp/cif_httpd.pid
rm -f /tmp/cif_router.pid

if [[ -d /db-sqlite ]]
then
  cp /db-sqlite/cif.yml /var/lib/cif/.cif.yml
  cp /db-sqlite/cif.yml /home/cif/.cif.yml
  cp /db-sqlite/csirtg-smrt.yml /var/lib/cif/
  cp /db-sqlite/csirtg-smrt.yml /etc/cif/
  cp /db-sqlite/cif-router.yml /var/lib/cif/
  cp /db-sqlite/cif-router.yml /etc/cif/
  cp /db-sqlite/cif.db /var/lib/cif/cif.db
else
  cp /var/lib/cif/.cif.yml /home/cif/
  cp /var/lib/cif/csirtg-smrt.yml /etc/cif/
  cp /var/lib/cif/cif-router.yml /etc/cif/
fi

