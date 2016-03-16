declare @date as date='2016-02-29'

select 
	Vertical, 
	sum(Convenience_Fee_Net_USD) Conv_Fee, 
	sum(Net_Settled_Fee_Net_USD) Net_Settled, 
	sum(Property_Fee) Property_Paid,
	sum(Property_Fee)+sum(Convenience_Fee_Net_USD)+sum(Net_Settled_Fee_Net_USD) Total
from ETLStaging..FinanceBaseMPR 
where
Date in(@date)
and Vertical not in('HA-Intl')
group by
Vertical
union all

select 
'Total' Vertical, 
	sum(Convenience_Fee_Net_USD) Conv_Fee, 
	sum(Net_Settled_Fee_Net_USD) Net_Settled, 
	sum(Property_Fee) Property_Paid,
	sum(Property_Fee)+sum(Convenience_Fee_Net_USD)+sum(Net_Settled_Fee_Net_USD) Total
from ETLStaging..FinanceBaseMPR 
where
Date in(@date)
and Vertical not in('HA-Intl')
