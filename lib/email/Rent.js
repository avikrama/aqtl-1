var 
	e = require('./emails.js')
	;

module.exports = {

	Tricity: [ e.accountmanagers , e.work ],
	JerseyCentral: [ e.accountmanagers , e.work ],		
	ConvFeeRentAnalytics : [ e.rent, e.work ],
	PenetrationRate: [ e.data, 'cmacrae@yapstone.com' ],
	PenetrationRate_Card: [ e.data, 'cmacrae@yapstone.com' ],
	PeopleTransacting: [ e.data, 'cmacrae@yapstone.com' ],
	VisaPilot: [ e.data, 'cmacrae@yapstone.com', 'sbayoumi@visa.com' ],
	Low_Cost_Debit: [ e.data, 'cmacrae@yapstone.com' ],
	
};

