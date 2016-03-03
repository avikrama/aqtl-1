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
	Cms_Domestic_HA: [ e.commissions ],
	Cms_Intl_HA_PPS: [ e.commissions ],
	Cms_Intl_HA_PPB: [ e.commissions ],
	Cms_Intl_Other: [ e.commissions ],
	Cms_Intl_Other: [ e.commissions ],
	Cms_Software: [ e.commissions ],

/* COGS DB */
	COGS_Model: [ e.finance ],

/* Other COGS */
	Vantiv_Bucket_Analysis: [ e.work ],
	MIDs_Upload: [ e.work ]

};

