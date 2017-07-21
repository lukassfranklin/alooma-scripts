# Alooma Utility Scripts

These are scripts we have used in order to help maintain our Alooma setup.
There is information that is available in their API that is hard to find in the interface.

We are utilizing [Alooma.py](https://support.alooma.com/hc/en-us/articles/115000686229-Accessing-Alooma-programmatically) for these scripts.

This is built in a way that you can just use the `make` commands directly, it will automatically setup the virtual environment and install requirements.

## Configuration

The scripts work by connecting to your Alooma instance.
To do so, it requires the following environment variables:

`ALOOMA_HOST` - defaults  to `app.alooma.com`
`ALOOMA_PORT` - defaults to `443`
`ALOOMA_USERNAME` - Username to authenticate
`ALOOMA_PASSWORD` - Password to authenticate

You can either `export` them or setup a file name `.aloomarc` in the root of this repository with this format:
```
ALOOMA_HOST=app.alooma.com
ALOOMA_PORT=443
ALOOMA_USERNAME=user@email.com
ALOOMA_PASSWORD=password
```

## Scripts

To get a full list of all available scripts, you can run `make help`.

### Check for Mappings without Consolidation Queries

This will go through all of your mappings and see if there is an associated consolidation query and output the mappings without one.

It allows you to identify if mappings are valid, but not updating any table in Redshift.

Usage:
```
make check-mapping-consolidations
```

### Check Mapping

This is to get a detailed view of the mappings internal settings.
This is a powerful way to debug a mapping that is not behaving correctly or missing fields.

Usage:
```
make check-mapping MAPPING=mapping_name
```

### Fix Mapping

This script is used to fix a mapping that is going to the wrong table.

For example, we ran into a scenario with a few mappings that were manually created where the mapping was going to the `[table_name]` rather than `[table_name]_log` table.

So, in order to fix this, we had to change the mapping and make sure the consolidation was going to the correct place as well.

NOTE: You *must* rename the table before running this script. You can do so by running the following SQL statement:

```sql
drop table if exists {schema}.{table}_log cascade;
alter table {schema}.{table} rename to {table}_log;
create table {schema}.{table} (like {schema}.{table}_log);
```

Usage:
```bash
make check-mapping MAPPING=mapping_name SCHEMA=schema_name TABLE=table_name
```

### Get Notifications

Get notifications from Alooma from a certain amount of minutes ago until now.

Usage:
```bash
# Get notifications for last hour in pretty format (human readable)
make get-notifications MINUTES=60

# Get notifications for last hour in raw object output
make get-notifications MINUTES=60 NOTIFICATIONS_RAW=true
```
