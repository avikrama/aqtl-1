var 
	e = require('./emails.js')
	;

module.exports = {

	TPV_PaymentType_m_ytd_v: [ e.data ],
	TPV_Vertical_m_ytd_v: [ e.data ],
	TPV_CardVolume_v: [ e.data ],
	TPV_p: [ e.data ],
	TPV_avg_t1: [ e.data ],
	TPV_avg_t2: [ e.data ],
	HA_Gross: [ e.data, e.corpdev ],
	HA_Net: [ e.data, e.corpdev ],
	IntlMix: [ e.data ],
	FinanceAnalytics: [ e.data ],
	Software_Rent: [ e.data ],
	Software_VRP: [ e.data ],
	Software_SRP: [ e.data ],
	Software_Inn: [ e.data ],
	Software_Dues: [ e.data ],
	Software_NonProfit: [ e.data ],	
	
};

