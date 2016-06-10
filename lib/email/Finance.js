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
	Cms_BuyRate: [ e.commissions, e.risk ],
	Cms_BuyRate_Count: [ e.commissions , e.risk ],	
	Cms_Count: [ e.commissions , e.risk ],
	Cms_Profit_PaymentType: [ e.commissions , e.risk ],
	Cms_Profit: [ e.commissions , e.risk ],
	Cms_Revenue: [ e.commissions , e.risk ],			
	Cms_Revenue_PaymentType: [ e.commissions , e.risk ],		
	Cms_All_Commissions: [ e.data ],			

/* Homeaway */
	Cms_Domestic_HA: 	[ e.commissions, e.corpdev ],
	Cms_Intl_HA_PPS: 	[ e.commissions, e.corpdev ],
	Cms_Intl_HA_PPB: 	[ e.commissions, e.corpdev ],
	Cms_Intl_HA_PPB_noTF: 	[ e.commissions, e.corpdev ],	
	Cms_Intl_HA_PPS_noTF: 	[ e.commissions, e.corpdev ],		
	Cms_Intl_Other: 	[ e.commissions, e.corpdev ],


/* COGS DB */
	COGS_Model: [ e.work ],

/* MPR Reporting */
	MPR_Revenue: [ e.work ],
	MPR_Financials: [ e.work ],

/* Other COGS */
	Vantiv_Bucket_Analysis: [ e.work ],
	MIDs_Upload: [ e.work ]

};

