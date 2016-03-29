with dates as ( 
	select '2016-02-29'::DATE date
 )

drop table if exists COGS;
create temp table COGS as (
	select 'Dues' Vertical,	1.9 Credit,	0.35 Debit,	1.09 Blend,	2.29 Amex,	0.03 ACH union
	select 'Inn',	1.91,	0.47,	1.63,	2.29,	0.03 	union
	select 'Rent',	2.01,	0.38,	1.12,	2.29,	0.03 union
	select 'VRP',	1.88,	0.37,	1.55,	2.29,	0.03 union
	select 'SRP',	2.1,	0.73,	1.17,	2.29,	0.03 union
	select 'NonProfit',	2.49,	1.05,	2.27,	2.29,	0.03 union
	select 'HA',	1.88,	0.4,	1.44,	2.29,	0.03 union
	select 'HA-Intl',	2.34,	0.42,	null,	null,	null
);

drop table if exists Allocable_Card_Volume;
create temp table Allocable_Card_Volume as (
	select MPR.Date, sum(MPR.Card_Volume_Net_USD)  Allocable_Card_Volume
	from  mpr_base MPR  
	where MPR.Gateway in ('YapProcessing') and MPR.Vertical not in ('HA-Intl','HA')
	group by MPR.Date
)
;

drop table if exists COGS_Financials_Base;
	select '2013-01-31' , 4334559 , 765895, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2013-01-31') )
	select '2013-02-28' , 3953897 , 731973, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2013-02-28') )
	select '2013-03-31' , 3913363 , 721878, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2013-03-31') )
	select '2013-04-30' , 3928581 , 777925, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2013-04-30') )
	select '2013-05-31' , 5044537 , 1018972, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2013-05-31') )
	select '2013-06-30' , 5522725 , 1110487, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2013-06-30') )
	select '2013-07-31' , 5457970 , 1196230, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2013-07-31') )
	select '2013-08-31' , 3965201 , 873302, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2013-08-31') )
	select '2013-09-30' , 3460856 , 860966, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2013-09-30') )
	select '2013-10-31' , 3764626 , 882692, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2013-10-31') )
	select '2013-11-30' , 4055276 , 974769, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2013-11-30') )
	select '2013-12-31' , 4195839 , 1137395, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2013-12-31') )
	select '2014-01-31' , 6173394 , 1719081, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2014-01-31') )
	select '2014-02-28' , 5255634 , 1596313, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2014-02-28') )
	select '2014-03-31' , 5740891 , 1782774, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2014-03-31') )
	select '2014-04-30' , 5309589 , 1689962, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2014-04-30') )
	select '2014-05-31' , 6702025 , 2131137, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2014-05-31') )
	select '2014-06-30' , 7670034 , 2476637, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2014-06-30') )
	select '2014-07-31' , 6970573 , 2277938, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2014-07-31') )
	select '2014-08-31' , 4975568 , 1698512, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2014-08-31') )
	select '2014-09-30' , 5012709 , 1830178, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2014-09-30') )
	select '2014-10-31' , 5223066 , 1775187, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2014-10-31') )
	select '2014-11-30' , 5080146 , 1920112, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2014-11-30') )
	select '2014-12-31' , 6342268 , 2369502, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2014-12-31') )
	select '2015-01-31' , 8204391 , 3372823, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2015-01-31') )
	select '2015-02-28' , 7263639 , 3017642, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2015-02-28') )
	select '2015-03-31' , 8013648 , 3315023, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2015-03-31') )
	select '2015-04-30' , 7342937 , 3000951, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2015-04-30') )
	select '2015-05-31' , 8717660 , 3503107, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2015-05-31') )
	select '2015-06-30' , 10721203 , 4363967, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2015-06-30') )
	select '2015-07-31' , 9287115 , 3672875, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2015-07-31') )
	select '2015-08-31' , 7186661 , 2889690, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2015-08-31') )
	select '2015-09-30' , 6386660 , 2661722, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2015-09-30') )
	select '2015-10-31' , 6560096 , 2731206, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2015-10-31') )
	select '2015-11-30' , 7485626 , 3187536, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2015-11-30') )
	select '2015-12-31' , 7849861 , 3301992, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2015-12-31') )
	select '2016-01-31' , 10455477 , 4733567, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2016-01-31') )
	select '2016-02-29' , 10059903 , 4741161, (select Allocable_Card_Volume from Allocable_Card_Volume where Date in ('2016-02-29') )


select * from COGS