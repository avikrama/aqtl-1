# Automated Query Tool

## What 
Automated query reporting, using `nodejs` as a scripting language.

Similar to an `ETL` app, except the `load` phase is an email/`csv` of the data.

Configurable database support (`MS SQL` OR `postgres`) agnostic for the `extract` phase, configurable in the script's `db` variable.

## Get started
- Write & parameterize the SQL query of the data to extract. 
- Create a `sql` file with your SQL query, and an identical `job` file that you can then schedule with `cron`

## Misc
- Start `postgres` locally! `$ postgres -D /usr/local/var/postgres9.5/ &`

## In case sensitive data checked into repo:
Find the full path of the file: `pwd | awk '{print $1"/Cms_Domestic_HA.sql"}'`

Run this command:
````
git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch aqtl/sql/Dimension/MPR/*.sql' \
--prune-empty --tag-name-filter cat -- --all
````

Add the file to `.gitignore`: `sql/Finance/HA/Cms_Domestic_HA.sql`