declare @now as date, @start as date, @end as date, 
@PaymentTypeClassifier as nvarchar(max), @PaymentTypeClassifierQuery as nvarchar(max),@PilotStartDate as nvarchar(max),@PilotStartDateQuery as nvarchar(max), @Network as nvarchar(max), @months as nvarchar(max), 
@columns as nvarchar(max), @query as nvarchar(max),
@tpv as nvarchar(max), @count as nvarchar(max) ;

set @now = getdate()
set @start = '2015-09-01'
set @end   = dateadd(d,-1 , dateadd(mm,(year(@now)- 1900) * 12 + month(@now)- 1 , 0))  

select @months = stuff((select ',' + quotename(colName) from (
	select  dateadd(d,-1,dateadd(mm,1,dateadd(month, x.number, @start))) as colName  from	master.dbo.spt_values x where	x.type = 'P' and x.number <= datediff(month, @start, @end) 
) sub order by colName for xml path(''), type).value('.', 'nvarchar(max)'),1,1,'')

-- Temp Tables
if object_id('tempdb..#PaymentTypeClassifier') is not null drop table #PaymentTypeClassifier
create table #PaymentTypeClassifier (PaymentType nvarchar(max), PaymentTypeClassifier nvarchar(max))
if object_id('tempdb..#DesiredParents') is not null drop table #DesiredParents
if object_id('tempdb..#PilotStartDate') is not null drop table #PilotStartDate
create table #PilotStartDate (ParentAccountid nvarchar(max), StartDate date)

select
	c.PlatformId, c.ParentAccountId, c.ParentName
	into #DesiredParents
from
	ETLStaging..FinanceParentTable c
where
	c.Vertical in ('Rent')
	and c.ParentAccountId in (
	'65-12836930',	-- Prometheus Real Estate Group
	'95-26894334',	-- Home Properties MRI
	'95-55693023', 	-- Warren Properties MRI
	--'05-18534018' 	-- Elon Management
	'55-12312695',	--	Village Green
	'75-27206950',	--	Breeden Property Management
	'25-38257142',	--	Mahaffey Company
	'06-11241364',	--	ECI Management Corporation
	'36-13268335'	--	Freeman Webb Company Realtors	
	)
group by
	c.PlatformId, c.ParentAccountId, c.ParentName

if object_id('tempdb..#CapacitySub') is not null drop table #CapacitySub
select year(txn.postdate_r) Year, month(txn.postdate_r) Month , cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R), 0)) as date) as Date,
      c.PlatformId ,  c.ParentAccountId, c.ParentName , yc.Capacity
      into #CapacitySub
from
      YapstoneDM..[Transaction] txn
      inner join ETLStaging..FinanceParentTable c on c.PlatformId = txn.PlatformId and c.ChildCompanyId = txn.Ref_CompanyId 
      inner join YapstoneDM..Company yc on c.PlatformId = yc.PlatformId and c.ChildAccountId = yc.AccountId
      inner join #DesiredParents d on c.PlatformId = d.PlatformId and c.ParentAccountId = d.ParentAccountId
where
      txn.postdate_r between @start and @end
      and c.PlatformId in (1)
      and c.Vertical in ('Rent','Dues')
group by year(txn.postdate_r) , month(txn.postdate_r)  , cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R), 0)) as date),
      c.PlatformId ,  c.ParentAccountId, c.ParentName, yc.Capacity
       
if object_id('tempdb..#Capacity') is not null drop table #Capacity
select cs.Year, cs.Month, cs.Date, cs.PlatformId, cs.ParentAccountId, cs.ParentName, sum(cs.Capacity) Capacity
      into #Capacity
from
      #CapacitySub cs
group by cs.Year, cs.Month, cs.Date, cs.PlatformId, cs.ParentAccountId, cs.ParentName

set @PaymentTypeClassifierQuery = '
insert into #PaymentTypeClassifier select ''Discover'',''Other Card Brand''
insert into #PaymentTypeClassifier select ''NYCE'',''Other Card Brand''
insert into #PaymentTypeClassifier select ''Master Card'',''Other Card Brand''
insert into #PaymentTypeClassifier select ''Visa'',''Visa Credit''
insert into #PaymentTypeClassifier select ''American Express'',''Other Card Brand''
insert into #PaymentTypeClassifier select ''Pulse'',''Other Card Brand''
insert into #PaymentTypeClassifier select ''Visa Debit'',''Visa Debit''
insert into #PaymentTypeClassifier select ''eCheck'',''ACH''
insert into #PaymentTypeClassifier select ''Star'',''Other Card Brand''
insert into #PaymentTypeClassifier select ''Scan'',''ACH''
insert into #PaymentTypeClassifier select ''Debit Card'',''Other Card Brand''
insert into #PaymentTypeClassifier select ''MC Debit'',''Other Card Brand'''
exec(@PaymentTypeClassifierQuery)

select @PaymentTypeClassifier = stuff((select ',' + quotename(colName) from (
	select  distinct(PaymentTypeClassifier) as colName from #PaymentTypeClassifier 
) sub order by colName desc for xml path(''), type).value('.', 'nvarchar(max)'),1,1,'')

set @PilotStartDateQuery = '
insert into #PilotStartDate  select ''65-12836930'',''11/01/2015''
insert into #PilotStartDate  select ''95-26894334'',''11/01/2015''
insert into #PilotStartDate  select ''95-55693023'',''11/01/2015''
insert into #PilotStartDate  select ''55-12312695'',''04/01/2016''
insert into #PilotStartDate  select ''75-27206950'',''03/01/2016''
insert into #PilotStartDate  select ''25-38257142'',''03/01/2016''
insert into #PilotStartDate  select ''06-11241364'',''03/01/2016''
insert into #PilotStartDate  select ''36-13268335'',''03/01/2016'''
exec(@PilotStartDateQuery)

select @PilotStartDate = stuff((select ',' + quotename(colName) from (
	select  distinct(StartDate) as colName from #PilotStartDate
) sub order by colName desc for xml path(''), type).value('.', 'nvarchar(max)'),1,1,'')

--select * from #PilotStartDate

if object_id('tempdb..#Table') is not null drop table #Table
select * into #Table from (
select
	cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R), 0)) as date) as Date ,
	c.ParentName, capacity.Capacity,
	ptc.PaymentTypeClassifier,
	sum(txn.Amount) as TPV,
	count(*) as Txn_Count
from
	YapstoneDM..[Transaction] txn
	join ETLStaging..FinanceParentTable c on txn.PlatformId = c.PlatformId and txn.Ref_CompanyId = c.ChildCompanyId
	join YapstoneDM..PaymentType pt on txn.PaymentTypeId = pt.PaymentTypeId
	left join #PaymentTypeClassifier ptc on pt.Name = ptc.PaymentType
	join #PilotStartDate psd on psd.ParentAccountid = c.ParentAccountId and psd.StartDate <=txn.PostDate_R
	join #DesiredParents dp on dp.PlatformId = c.PlatformId and dp.ParentAccountId = c.ParentAccountId
	join #Capacity capacity on capacity.ParentAccountId = c.ParentAccountId and capacity.PlatformId = c.PlatformId 
		and cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R), 0)) as date) = capacity.Date
where
	txn.PostDate_R between @start and @end
	and txn.TransactionCycleId in (1)
	and txn.ProcessorId not in (14,16)
	and txn.PaymentTypeId not in (14)
	and txn.PlatformId in (1)
group by
	cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R), 0)) as date) ,
	c.ParentName, capacity.Capacity,
	ptc.PaymentTypeClassifier
) src


select @columns = stuff((select distinct ',' + quotename(PaymentTypeClassifier+'_'+c.col) from #Table
  cross apply ( select 'Volume' col union all select 'Count') c
  order by 1 desc
for xml path (''), type).value('.', 'nvarchar(max)'),1,1,'')

set @query = '
select 
	Date, ParentName, Capacity, '+@columns+'
from
	( 
	select 
		Date, ParentName, Capacity, PaymentTypeClassifier+''_''+col col, Value
	from (
		select Date, ParentName, Capacity, PaymentTypeClassifier ,
			cast(TPV as decimal(10,2)) Volume ,
			cast(Txn_Count as decimal(10,2)) Count
		from #Table
	) src
	unpivot (
		value
		for col in (Volume, Count)
	) up
	) src
	pivot (
		sum(Value)
		for col in ('+@columns+')
	) pt
'

if object_id('tempdb..#Report') is not null drop table #Report
create table #Report (Date date, ParentName nvarchar(max), Capacity nvarchar(max), 
	[Visa Debit Volume] nvarchar(max), [Visa Debit Count] nvarchar(max), 
	[Visa Credit Volume] nvarchar(max), [Visa Credit Count] nvarchar(max),
	[Other Card Brand Volume] nvarchar(max), [Other Card Brand Count] nvarchar(max), 
	[ACH Volume] nvarchar(max), 	[ACH Count] nvarchar(max)
	)
insert #Report
exec(@query)

select *, [Avg Ticket]*Capacity as 'Potential Volume' from (
select *, [Total Volume]/[Total Count] 'Avg Ticket' from (
select *,  
	isnull(cast([Visa Credit Volume] as numeric),0)+isnull(cast([Visa Debit Volume] as numeric),0)+isnull(cast([Other Card Brand Volume] as numeric),0)+isnull(cast([ACH Volume] as numeric),0) 'Total Volume' ,
	isnull(cast([Visa Credit Count]  as numeric),0)+isnull(cast([Visa Debit Count]  as numeric),0)+isnull(cast([Other Card Brand Count]  as numeric),0)+isnull(cast([ACH Count]  as numeric),0)  'Total Count' 
from #Report
) src
) src


