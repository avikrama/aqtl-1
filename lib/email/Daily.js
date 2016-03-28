var 
	e = require('./emails.js')
	;

module.exports = {
	// Daily_Card_Volume: [ e.finance, e.corpdev, e.rent , e.risk , e.product, e.dba, e.marketing, e.vrp , e.management, e.accounting ],
	// Daily_TPV: [ e.finance, e.corpdev, e.rent, e.risk , e.product, e.dba, e.marketing, e.vrp, e.management, e.accounting ],

	Daily_Card_Volume: [ e.work ],
	Daily_Card_Volume_2: [ e.work ],
	Daily_TPV: [ e.work ],

	Daily_Cash: [ e.finance, e.accounting ],		
	YapDM_Records: [ e.data, e.risk ],

};

