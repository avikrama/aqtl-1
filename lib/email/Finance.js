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
	Cms_BuyRate: [ e.commissions ],
	Cms_Count: [ e.commissions ],
	Cms_Profit_PaymentType: [ e.commissions ],
	Cms_Profit: [ e.commissions ],
	Cms_Revenue: [ e.commissions ],			
	Cms_Revenue_PaymentType: [ e.commissions ],		

/* Homeaway */
	Cms_Domestic_HA: [ e.commissions ],
	Cms_Intl_HA_PPS: [ e.commissions ],
	Cms_Intl_HA_PPB: [ e.commissions ],
	Cms_Intl_Other: [ e.commissions ],


/* COGS DB */
	COGS_Model: [ e.work ],

/* MPR Reporting */
	MPR_Revenue: [ e.work ],
	MPR_Financials: [ e.work ],

/* Other COGS */
	Vantiv_Bucket_Analysis: [ e.work ],
	MIDs_Upload: [ e.work ]

};

