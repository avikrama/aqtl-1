declare @now date, @start date, @end date, @CommissionsRate as decimal(18,2), @Software as nvarchar(max)

set @now = getdate()
set @start = dateadd(mm,(year(@now)- 1900) * 12 + month(@now) - 1 -1 , 0)
set @end   = dateadd(d,-1 , dateadd(mm,(year(@now)- 1900) * 12 + month(@now)- 1 , 0))  

set @CommissionsRate = 0.23

set @Software = 'Easy Storage'
	
select
	Date , SoftwareName, ParentName ,
	sum(Txn_Count) Txn_Count, sum(Card_Volume_Net_USD) Card_Volume, 
	sum(Revenue_Net_USD) Revenue ,@CommissionsRate Commissions_Rate, sum(Txn_Count) * @CommissionsRate Total_Commissions
from
	ETLStaging..FinanceMPR MPR
where
	MPR.Date in (@end)
	and MPR.PaymentTypeGroup in ('Card')
	and SoftwareName in (@Software)
group by
	Date, SoftwareName, ParentName
