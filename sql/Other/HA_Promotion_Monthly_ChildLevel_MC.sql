-- HA MC Promotion Query 

declare @now as date, @start as date, @end as date ,
 @promoStart as date, @promoEnd as date
 
set @promoStart	= '2015-11-09' 
set @promoEnd = '2015-12-07'

set @now = getdate()
set @start = '2015-01-01'	--dateadd(mm,(year(@now)- 1900) * 12 + month(@now) - 1 -1 , 0) 
set @end = dateadd(d,-1 , dateadd(mm,(year(@now)- 1900) * 12 + month(@now)- 1 , 0))  



if object_id('tempdb..#AllPropertyOwners') is not null drop table #AllPropertyOwners
select 
	c.PlatformId,
	ct.ext1 HomeAwayExternalId, c.AccountId PropertyOwnerAccountId, c.Name PropertyOwnerName, 
	case when ct.createdOn >= @promoStart then 'Sign Up During Promotion' else 'HA Payment Enabled Prior to Promotion' end SignUpType ,
	(isnull(c.Address_Street1, ' ')+' '+isnull(c.Address_Street2,' ')) StreetAddress, isnull(c.Address_City,' ') City, isnull(c.Address_StateProvince,' ') State, isnull(c.Address_PostalCode,' ') Zip, isnull(Person.email,' ') Email
	into #AllPropertyOwners	
from 
	YapstoneDM..Company c
	inner join haReportsTemp..Community ct on c.PlatformId = 3 and c.CompanyId = ct.Id and ct.classId in (19)
	left join HAReportsTemp..Person with (nolock) on ct.id = Person.BusinessEntity_companyId and ct.classId = Person.BusinessEntity_companyClassId	
where 1=1
	and c.PlatformId = 3
	and c.AggregateId like '1|2|1001|______'  -- Property Owner level only
group by
	c.PlatformId,
	ct.ext1 , c.AccountId, c.Name,
	case when ct.createdOn >= @promoStart then 'Sign Up During Promotion' else 'HA Payment Enabled Prior to Promotion' end  ,
	(isnull(c.Address_Street1, ' ')+' '+isnull(c.Address_Street2,' ')) , isnull(c.Address_City,' ') ,isnull(c.Address_StateProvince,' '),isnull(c.Address_PostalCode,' '),  isnull(Person.email,' ')
	
--select * from #AllPropertyOwners where PropertyOwnerAccountId = '56-32989893
	
--select * from #AllPropertyOwners where PropertyOwnerAccountId = '56-32989893'	
	
if object_id('tempdb..#NotEligible')is not null drop table #NotEligible     
select
	c.PlatformId, c.PropertyOwnerAccountId, c.PropertyOwnerName
	into #NotEligible
from
	ETLStaging..FinanceHAPropertyOwners c
	inner join YapstoneDM..[Transaction] txn on txn.PlatformId = c.PlatformId and txn.Ref_CompanyId = c.ChildCompanyId
where
	c.PlatformId = 3
	and txn.TransactionCycleId = 1
	and txn.ProcessorId not in (14,16)
	and txn.PostDate_R < @promoStart
group by
	c.PlatformId, c.PropertyOwnerAccountId, c.PropertyOwnerName

--select  * from #NotEligible  where PropertyOwnerAccountId = '56-32989893'	

if object_id('tempdb..#Eligible')is not null drop table #Eligible     
select 
	AllPropertyOwners.PlatformId,
	AllPropertyOwners.PropertyOwnerAccountId, AllPropertyOwners.PropertyOwnerName, AllPropertyOwners.SignUpType , 
	AllPropertyOwners.StreetAddress, AllPropertyOwners.City,AllPropertyOwners.State, AllPropertyOwners.Zip, AllPropertyOwners.Email
	into #Eligible
from 
	#AllPropertyOwners AllPropertyOwners 
	left join #NotEligible NotEligible on NotEligible.PropertyOwnerAccountId = AllPropertyOwners.PropertyOwnerAccountId and NotEligible.PlatformId = AllPropertyOwners.PlatformId
where
	NotEligible.PlatformId is null
group by
	AllPropertyOwners.PlatformId,
	AllPropertyOwners.PropertyOwnerAccountId, AllPropertyOwners.PropertyOwnerName, AllPropertyOwners.SignUpType ,
	AllPropertyOwners.StreetAddress, AllPropertyOwners.City,AllPropertyOwners.State, AllPropertyOwners.Zip , AllPropertyOwners.Email

--select * from #Eligible where PropertyOwnerAccountId = '56-32989893'	


if object_id('tempdb..#Report') is not null drop table #Report
select 
	txn.PlatformId,
	Eligible.PropertyOwnerAccountId, Eligible.PropertyOwnerName, Eligible.SignUpType ,
	Eligible.StreetAddress, Eligible.City,Eligible.State, Eligible.Zip, Eligible.Email ,
	c.ChildAccountId as ListingAccountId, 
	sum(txn.Amount) TPV ,
	sum(case when txn.PaymentTypeId = 2 then txn.Amount else 0 end) MC_Credit ,
	sum(case when txn.PaymentTypeId = 12 then txn.Amount else 0 end) MC_Debit
	into #Report
from 
	#Eligible Eligible
	inner join ETLStaging..FinanceHAPropertyOwners c on c.PlatformId = Eligible.PlatformId and c.PropertyOwnerAccountId = Eligible.PropertyOwnerAccountId
	inner join YapstoneDM..[Transaction] txn on txn.PlatformId = c.PlatformId and txn.Ref_CompanyId = c.ChildCompanyId
	inner join ETLStaging..FinanceHAProductType hapt on hapt.IdClassId = txn.IdClassId and txn.PlatformId = 3
where
	txn.TransactionCycleId = 1
	and txn.PostDate_R between @promoStart and @promoEnd
	and txn.PlatformId = 3	
	and hapt.ProductType = 'PPS'
group by 
	txn.PlatformId,
	Eligible.PropertyOwnerAccountId, Eligible.PropertyOwnerName, Eligible.SignUpType , 
	Eligible.StreetAddress, Eligible.City,Eligible.State, Eligible.Zip, Eligible.Email ,
	c.ChildAccountId
	
	
if object_id('tempdb..#MonthlyReport') is not null drop table #MonthlyReport			
select 
	c1.PropertyOwnerAccountId, c1.PropertyOwnerName, c1.SignUpType, c1.Email , c1.StreetAddress, c1.City,c1.State, c1.Zip, 
	c.ChildAccountId ListingAccountId, c.ChildName ListingName ,
	sum(txn.Amount) TPV , count(*) Txn_Count, count(distinct(c.ChildAccountId)) #of_UniqueListings,
	sum(case when txn.PaymentTypeId = 2 then txn.Amount else 0 end) MC_Credit ,
	sum(case when txn.PaymentTypeId = 12 then txn.Amount else 0 end) MC_Debit

	into #MonthlyReport
from 
	YapstoneDM..[Transaction] txn
	inner join ETLStaging..FinanceHAPropertyOwners c on c.PlatformId = txn.PlatformId and txn.Ref_CompanyId = c.ChildCompanyId
	inner join #Report c1 on c1.PlatformId = c.PlatformId and c1.ListingAccountId = c.ChildAccountId
	inner join ETLStaging..FinanceHAProductType hapt on  hapt.PlatformId =  txn.PlatformId and hapt.IdClassId = txn.IdClassId 
where
	txn.TransactionCycleId in (1)
	and txn.ProcessorId not in (14,16)
	and txn.PostDate_R between @start and @end
	and txn.PlatformId = 3	
	and hapt.ProductType in ('PPS')
group by  	
	c1.PropertyOwnerAccountId, c1.PropertyOwnerName, c1.SignUpType ,c1.Email , c1.StreetAddress, c1.City,c1.State, c1.Zip,
	c.ChildAccountId , c.ChildName  
	
select * from #MonthlyReport
	

	

	
	
	
	