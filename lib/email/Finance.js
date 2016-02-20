var 
	e = require('./emails.js')
	;

module.exports = {

/* Regular Reports */
	MPR: [ e.work ],
	Revenue: [ e.work ],
	Misc: [ e.work ],
	Misc2: [ e.work ],

/* Commissions */
	Domestic_HA: [ e.commissions ],
	Intl_HA_PPS: [ e.commissions ],
	Intl_HA_PPB: [ e.commissions ],
	Intl_NonHA: [ e.commissions ],
	
/* COGS DB */
	COGS_Model: [ e.finance ]

};

