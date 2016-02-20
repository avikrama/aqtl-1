

-- HA-Intl Commissions
declare @now as date, @start as date, @end as date, @currencies as nvarchar(max), @columns as nvarchar(max), @PPS_query as nvarchar(max), @PPB_query as nvarchar(max)
set @now = getdate()
set @start = dateadd(mm,(year(@now)- 1900) * 12 + month(@now)- 1 - 1, 0)
set @end = dateadd(d,-1 , dateadd(mm,(year(@now)- 1900) * 12 + month(@now)- 1 , 0)) 

if object_id('tempdb..#Report') is not null drop table #Report
select 
	c.Software,
	cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R), 0)) as date) as Date , 
	Currency.CharCode Currency, Product.ProductType ,
	sum(txn.Amount) as Txn_Amount, 
	sum(txn.AmtNetPropFee) as Revenue,
	count(*) as Txn_Count
	into #Report    
from                                             
	YapstoneDM.dbo.[Transaction] txn
	inner join ETLStaging..FinanceHAPropertyOwners c 		on c.PlatformId = txn.PlatformId and c.ChildCompanyId = txn.Ref_CompanyId
	inner join YapstoneDM.dbo.Currency                  	on txn.CurrencyId = Currency.CurrencyId
	inner join ETLStaging..FinanceHAProductType Product 	on Product.PlatformId = txn.PlatformId and Product.IdClassId = txn.IdClassId
where            
	txn.PostDate_R between @start and @end
	and txn.PlatformId in (4)
	and txn.TransactionCycleId in (1,3,4,9,16) 	-- Net
	and c.Merchant in ('Homeaway Inc')
group by
	c.Software,
	cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R), 0)) as date), 
	Currency.CharCode , Product.ProductType 
     
select @currencies = stuff((select ',' + quotename(colName) from (
      select  distinct(Currency) as colName from #Report 
) sub order by colName desc for xml path(''), type).value('.', 'nvarchar(max)'),1,1,'')

select @columns = stuff((
      select 
            distinct ',' + quotename(Currency+'_'+c.col) 
      from #Report
            cross apply ( 
                  select 'Txn_Amount' col union all select 'Revenue'  union all select 'Txn_Count' 
            ) c
for xml path (''), type).value('.', 'nvarchar(max)'),1,1,'')

set @PPS_query = '
select * from (
	select Software, Date, Currency+''_''+col col, Value from (
		select Software, Date, Currency, Txn_Amount, Revenue, cast(Txn_Count as decimal(38,4)) Txn_Count
		from #Report
		where ProductType in (''PPS'')
	) src
	unpivot (
		value
		for col in (Txn_Amount, Revenue, Txn_Count)
	) up
) src
pivot (
	sum(value)
	for col in ('+@columns+')
) pt
'

set @PPB_query = '
select * from (
	select Software, Date, Currency+''_''+col col, Value from (
		select Software, Date, Currency, Txn_Amount, Revenue, cast(Txn_Count as decimal(38,4)) Txn_Count
		from #Report
		where ProductType in (''PPB'')
	) src
	unpivot (
		value
		for col in (Txn_Amount, Revenue, Txn_Count)
	) up
) src
pivot (
	sum(value)
	for col in ('+@columns+')
) pt
'

exec(@PPB_query)
