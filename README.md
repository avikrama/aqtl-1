# Automated Query Tool

## What 
Automated query reporting, using `nodejs` as a scripting language.

Similar to an `ETL` app, except the `load` phase is an email/csv of the data.

Database agnostic. Configurable support for `MS SQL` OR `postgres`.

## Why
What other tools exist to schedule a nightly KPI metrics report?

## Install
- `git clone git@github.com:skilbjo/aqtl.git ; cd aqtl`
- `npm install`

## Workflow
- Write & parameterize the SQL query of the data to extract, ie:
		````declare @start as date
		set @date = getdate()
		select * from [Transaction] where date = @date````
- Save the file in the directory path `sql/Finance` as `myquery.sql`
- Create a `myquery.js` file in the corresponding `jobs/Finance` path,
		````extract(db, folder, file, subfolder, function(data){
			transform(data, function(data){
				load(data, folder, file, subfolder, html);
			});
		});````
- Create an email distribution list in `lib/email/finance.js`: `myquery: [ skilbjo@yapstone.com ]`
- Schedule the report via cron in `lib/crontab`: `0 12 * * 2-6 skilbjo cd $FINANCE ; node myquery.js >/dev/null`
- Enjoy!

## Misc
### Local Postgres DB
- Start `postgres` locally! `$ postgres -D /usr/local/var/postgres9.5/ &`

## In case sensitive data checked into repo:
Find the full path of the file: `pwd | awk '{print $1"/Cms_Domestic_HA.sql"}'`

Run this command:
		git filter-branch --force --index-filter \
		'git rm --cached --ignore-unmatch aqtl/sql/Dimension/MPR/*.sql' \
		--prune-empty --tag-name-filter cat -- --all

Add the file to `.gitignore`: `sql/Finance/HA/Cms_Domestic_HA.sql`