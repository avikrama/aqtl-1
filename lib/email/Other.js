var 
	e = require('./emails.js')
	;

module.exports = {

	/* Rent */
	Rent_ConvFeeRentAnalytics : [ e.rent, e.work ],
	Rent_PenetrationRate: [ e.data, 'cmacrae@yapstone.com' ],
	Rent_PenetrationRateCard: [ e.data, 'cmacrae@yapstone.com' ],
	Rent_PeopleTransacting: [ e.data, 'cmacrae@yapstone.com' ],
	Rent_VisaPilot: [ e.data, 'cmacrae@yapstone.com', 'sbayoumi@visa.com' ],
	Rent_LowCostDebit: [ e.data, 'cmacrae@yapstone.com' ],
	

	/* Corp Dev */
	HA_Active_Listings_Gross_All: [ e.data, e.corpdev ],
	HA_Model_Net: [ e.work, e.corpdev ],

	'2015-01-31': [ e.work, e.corpdev ],
	'2015-02-28': [ e.work, e.corpdev ],
	'2015-03-31': [ e.work, e.corpdev ],
	'2015-04-30': [ e.work, e.corpdev ],
	'2015-05-31': [ e.work, e.corpdev ],
	'2015-06-30': [ e.work, e.corpdev ],
	'2015-07-31': [ e.work, e.corpdev ],
	'2015-08-31': [ e.work, e.corpdev ],
	'2015-09-30': [ e.work, e.corpdev ],
	'2015-10-31': [ e.work, e.corpdev ],
	'2015-11-30': [ e.work, e.corpdev ],
	'2015-12-31': [ e.work, e.corpdev ],

	'2016-01-31': [ e.work, e.corpdev ],	
	'2016-02-29': [ e.work, e.corpdev ],	
	'2016-03-31': [ e.work, e.corpdev ],	
	'2016-04-30': [ e.work, e.corpdev ],	


	/* Marketing */
	HA_Promotion_Monthly_ParentLevel: [ e.data, 'ksato@yapstone.com' , 'fgottardo@yapstone.com' ],
	HA_Promotion_Monthly_ChildLevel: [ e.data, 'ksato@yapstone.com', 'fgottardo@yapstone.com' ],


	/* Batch Rent */
	Rent_Mer_Tricity: [ e.accountmanagers , e.work ],	
	Rent_Mer_Cammebys: [ e.accountmanagers , e.work ],
	Rent_Mer_JerseyCentral: [ e.accountmanagers , e.work ],	
	Rent_Mer_AlmaRealtyCorpResidential: [ e.accountmanagers , e.work ],
	Rent_Mer_DePaulMgmt: [ e.accountmanagers , e.work ],
	Rent_Mer_FDCMgmt: [ e.accountmanagers , e.work ],
	Rent_Mer_KettlerMgmt: [ e.accountmanagers , e.work ],
	Rent_Mer_LyonMgmtGroup: [ e.accountmanagers , e.work ],
	Rent_Mer_OlentangyVillage: [ e.accountmanagers , e.work ],
	Rent_Mer_Queens: [ e.accountmanagers , e.work ],
	Rent_Mer_TwoTreesCommercial: [ e.accountmanagers , e.work ],
	Rent_Mer_TwoTreesMgmt: [ e.accountmanagers , e.work ],
	Rent_Mer_UniversityCity: [ e.accountmanagers , e.work ],

};

