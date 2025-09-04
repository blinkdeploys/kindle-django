
# env vars
source .env


projectname=$PROJECTNAME

dbuser=$POSTGRES_USER
db=$POSTGRES_DB
dbps=POSTGRES_PASSWORD



# login
sql -U $dbuser -d $db <<EOF
CREATE DATABASE $db;
CREATE USER $dbuser WITH PASSWORD '$dbps';
ALTER ROLE $dbuser SET client_encoding TO 'utf8';
ALTER ROLE $dbuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE $dbuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE $db TO $dbuser;
EOF