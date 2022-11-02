# hs_postgis
A datbase for Hydroshare based on official images.

1. Open port 5432 on the host's firewall to the subnets making connections.
1. Set `PGPASSWORD` in `.env`.
1. `docker-compose up -d`
1. Place a SQL dump to load into the database in /var/scratch/pg.deploy.sql on the host.
1. `./loaddb.sh`
1. The default postgres user password is configured in two places in the Hydroshare codebase:
   1. `hydroshare/hydroshare/local_settings.py`
   1. `hydroshare/config/hydroshare-config.yaml`
