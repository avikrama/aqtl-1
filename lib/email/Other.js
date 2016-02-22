var 
	e = require('./emails.js')
	;

module.exports = {

	/* Rent */
	Rent_Tricity: [ e.accountmanagers , e.work ],
	Rent_JerseyCentral: [ e.accountmanagers , e.work ],		
	Rent_ConvFeeRentAnalytics : [ e.rent, e.work ],
	Rent_PenetrationRate: [ e.data, 'cmacrae@yapstone.com' ],
	Rent_PenetrationRateCard: [ e.data, 'cmacrae@yapstone.com' ],
	Rent_PeopleTransacting: [ e.data, 'cmacrae@yapstone.com' ],
	Rent_VisaPilot: [ e.data, 'cmacrae@yapstone.com', 'sbayoumi@visa.com' ],
	Rent_LowCostDebit: [ e.data, 'cmacrae@yapstone.com' ],
	
	/* Corp Dev */
	HA_Active_Listings_Gross_All: [ e.data, e.corpdev ],
	HA_Model_Net: [ e.work, e.corpdev ],

	/* Marketing */
	HA_Promotion_Monthly: [ e.data, 'ksato@yapstone.com' ]


};

