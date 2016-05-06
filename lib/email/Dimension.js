var 
	e = require('./emails.js')
	;

module.exports = {

	/* Validation tables */
	val_AggregationTables: [ e.data ],	
	val_AggregationTables_Postgres: [ e.data ],		
	val_DimensionTables: [ e.data ],
	val_HADimensionTables: [ e.data ],
	val_Issuer: [ e.data ],
	val_SurchargeType: [ e.data ],	
	val_COGSDatabase: [ e.data ],
	val_Revenue: [ e.data ]
	
};

