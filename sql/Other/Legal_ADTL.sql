
declare @start as date = '2016-10-01', @end as date = '2016-10-31', @stateFilter as nvarchar(max)

set @stateFilter = 'CA'

if object_id('tempdb..##Person') is not null drop table ##Person
if object_id('tempdb..#Incoming') is not null drop table #Incoming
if object_id('tempdb..#Refunds') is not null drop table #Refunds
if object_id('tempdb..#Outgoing') is not null drop table #Outgoing
if object_id('tempdb..#Report') is not null drop table #Report

select * into ##Person from (
	select 1 as PlatformId, BusinessEntity_companyId as CompanyId, id as PersonId, State
	from  rpReportsTemp.rp.Person
	where state in (@stateFilter) and country in ('US')
	group by BusinessEntity_companyId , id , State
	union all
	select 2 as PlatformId, BusinessEntity_companyId as CompanyId, id as PersonId, State
	from  ipReportsTemp..Person ip
	where state in (@stateFilter) and country in ('US')
	group by BusinessEntity_companyId , id , State	
	union all
	select 3 as PlatformId, BusinessEntity_companyId as CompanyId, id as PersonId, State
	from  haReportsTemp..Person ha 
	where state in (@stateFilter) and country in ('US')
	group by BusinessEntity_companyId , id , State
	union all
	select 4 as PlatformId, BusinessEntity_companyId as CompanyId, id as PersonId, State
	from  GD1ReportsTemp..Person gd1 
	where state in (@stateFilter) and country in ('US')
	group by BusinessEntity_companyId , id , State	
) src join #states s on s.SState = src.State
       

select
	txn.PostDate_R ,sum(txn.Amount - txn.AmtNetConvFee -txn.AmtNetPropFee) Incoming , count(*) Incoming_Count
	into #Incoming
from
	YapstoneDM..[Transaction] txn
	join ETLStaging..FinanceParentTable c on txn.PlatformId = c.PlatformId and txn.Ref_CompanyId = c.ChildCompanyId
	join ##Person Person on  txn.PlatformId = Person.PlatformId and Person.CompanyId = c.ChildCompanyId and Person.PersonId = txn.Ref_PersonId
where
	txn.TransactionCycleId in (1)
	and txn.PostDate_R between @start and @end
	and txn.ProcessorId not in (14,16)
	and txn.Ref_BatchTypeId in (1)
group by 
	txn.PostDate_R
	

select
	txn.PostDate_R ,sum(txn.Amount) Refunds , count(*) Refunds_Count
	into #Refunds
from
	YapstoneDM..[Transaction] txn
	join ETLStaging..FinanceParentTable c on txn.PlatformId = c.PlatformId and txn.Ref_CompanyId = c.ChildCompanyId
	join ##Person Person on  txn.PlatformId = Person.PlatformId and Person.CompanyId = c.ChildCompanyId and Person.PersonId = txn.Ref_PersonId
where
	txn.TransactionCycleId in (9)
	and txn.PostDate_R between @start and @end
	and txn.ProcessorId not in (14,16)
	and txn.Ref_BatchTypeId in (1)
group by 
	txn.PostDate_R
	
	
-- // this will likely be something different
select
	txn.PostDate_R ,sum(txn.Amount) Outgoing, , count(*) Outgoing_Count
	into #Outgoing
from
	YapstoneDM..[Transaction] txn
	join ETLStaging..FinanceParentTable c on txn.PlatformId = c.PlatformId and txn.Ref_CompanyId = c.ChildCompanyId
	join ##Person Person on  txn.PlatformId = Person.PlatformId and Person.CompanyId = c.ChildCompanyId and Person.PersonId = txn.Ref_PersonId
where
	txn.TransactionCycleId in (2)
	and txn.PostDate_R between @start and @end
	and txn.ProcessorId not in (14,16)
	and txn.Ref_BatchTypeId in (1)
group by 
	txn.PostDate_R
	
	
select
	coalesce(i.Date,r.Date,o.Date) Date , 
	sum(i.Incoming) Incoming, sum(r.Refunds) Refunds, sum(o.Outgoing) Outgoing
	into #Report
from
	#Incoming i
	full outer join #Refunds r on i.Date = r.Date
	full outer join #Outgoing o on o.Date = i.Date
group by 
	coalesce(i.Date,r.Date,o.Date) 

