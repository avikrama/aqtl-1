var 
	e = require('./emails.js')
	;

module.exports = {

	/* Rent */
	Tricity: [ e.accountmanagers , e.work ],
	JerseyCentral: [ e.accountmanagers , e.work ],		
	ConvFeeRentAnalytics : [ e.rent, e.work ],
	PenetrationRate: [ e.data, 'cmacrae@yapstone.com' ],
	PenetrationRate_Card: [ e.data, 'cmacrae@yapstone.com' ],
	PeopleTransacting: [ e.data, 'cmacrae@yapstone.com' ],
	VisaPilot: [ e.data, 'cmacrae@yapstone.com', 'sbayoumi@visa.com' ],
	Low_Cost_Debit: [ e.data, 'cmacrae@yapstone.com' ],
	
	/* Corp Dev */
	HA_Active_Listings_Gross_All: [ e.data, e.corpdev ],
	HA_Model_Net: [ e.work, e.corpdev ],

	/* Marketing */
	HA_Promotion_Monthly: [ e.data, 'ksato@yapstone.com' ]



};

