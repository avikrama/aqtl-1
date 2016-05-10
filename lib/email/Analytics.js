var 
	e = require('./emails.js')
	;

module.exports = {

	TPV_PaymentType_m_ytd_v: [ e.data ],
	TPV_Vertical_m_ytd_v: [ e.data ],
	TPV_CardVolume_v: [ e.data ],

	ODLN: [ e.data ],
	ODLN_parents: [ e.data ],
	Merchant_counts: [ e.data ],	
	Merchant_counts_child: [ e.data ],	

	HA_Gross: [ e.data, e.corpdev ],
	HA_Net: [ e.data, e.corpdev ],

	IntlMix: [ e.data ],
	Analytics: [ e.data ],
	Software_Rent: [ e.data ],
	Software_VRP: [ e.data ],
	Software_SRP: [ e.data ],
	Software_Inn: [ e.data ],
	Software_Dues: [ e.data ],
	Software_NonProfit: [ e.data ],	

	HA_Listings: [ e.data ],
	HA_Listings_Month: [ e.data ],
	HA_Listings_PaymentType: [ e.data ],
	HA_Listings_Month_PaymentType: [ e.data ]
	
};

