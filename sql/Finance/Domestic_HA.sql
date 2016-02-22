
declare @now as date, @start as date, @end as date, 
@PPS_Commission as decimal(18,3), @Discount_Pricing_Commission as decimal(18,2),
@PPB_Commission as decimal(18,3),  
@ACH_Cost as decimal(18,2),  @ACH_Share_Rate as decimal(18,2), @ACH_Commission as decimal(18,3),
@Intl_Surcharge_Commission as decimal(18,3)

set @now = getdate()
set @start = dateadd(mm,(year(@now)- 1900) * 12 + month(@now) - 1 -1 , 0)
set @end = dateadd(d,-1 , dateadd(mm,(year(@now)- 1900) * 12 + month(@now)- 1 , 0))  

set @PPS_Commission = 0.47 
set @PPB_Commission = 0.35
set @Discount_Pricing_Commission = 0.30
set @ACH_Cost = 0.19
set @ACH_Share_Rate = 0.5
set @ACH_Commission = @ACH_Cost * @ACH_Share_Rate
set @Intl_Surcharge_Commission = 0.625
 
if object_id('tempdb..#Intl_Surcharge_Ids') is not null drop table #Intl_Surcharge_Ids
select 
	3 as PlatformId, cast(t.id as varchar) + ':' + cast(t.classId as varchar) IdClassId 
	into #Intl_Surcharge_Ids
from 
   HAReportsTemp.dbo.Transfer t                                                                                                                                                                                  
   inner join HAReportsTemp.dbo.Invoice i on t.invoiceID = i.Id and t.invoiceClassID = i.classId           
   inner join HAReportsTemp.dbo.Propertyfee pf on pf.invoiceID = i.Id and pf.invoiceClassId = i.classId 
where
	t.posted between @start and  dateadd(s,-1,dateadd(d,1,cast(@end as datetime)))
	and pf.propertyFeeCategoryId in (2) -- Intl Surcharge
group by 
	cast(t.id as varchar) + ':' + cast(t.classId as varchar) 
 
 
if object_id('tempdb..#Intl_Surcharge') is not null drop table #Intl_Surcharge
select cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R) , 0)) as date) Date ,
	c.PropertyOwnerAccountId , c.PropertyOwnerName ,
	sum(txn.Amount) as Card_Volume_USD, sum(txn.AmtNetPropFee) as Revenue_USD, count(*) as Txn_Count
	into #Intl_Surcharge
from                                           
   YapstoneDM.dbo.[Transaction] txn
   inner join ETLStaging..FinanceHAPropertyOwners c on txn.PlatformId = c.Platformid and txn.Ref_CompanyId = c.ChildCompanyId
   inner join YapstoneDM.dbo.Company c1             on txn.PlatformId = c1.PlatformId and txn.Ref_CompanyId = c1.CompanyId 
   inner join ETLStaging..FinanceHAProductType Product on txn.IdClassId = Product.IdClassId and txn.PlatformId = Product.PlatformId
   left join #Intl_Surcharge_Ids Intl on txn.PlatformId = Intl.PlatformId and txn.IdClassId = Intl.IdClassId
where txn.PostDate_R between @start and @end
	and txn.TransactionCycleId in (1,3,4,9,16) -- Net
	and txn.PlatformId in (3) and txn.ProcessorId not in (14,16)
	and ( case when txn.PaymentTypeId in (1,2,3,11,12) then 1 
		when txn.PaymentTypeId in (10) and txn.ProcessorId in (22) and txn.Ref_BatchTypeId in (1) then 1 else 0 end
	) = 1  -- Card Volume
	--and Product.ProductType in ('PPS')  // Weird thing where there are Intl Surcharge on both PPS and PPB
	and Intl.PlatformId is not null
group by 
	year(txn.PostDate_R) , month(txn.PostDate_R) , cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R) , 0)) as date),  
	c.PropertyOwnerAccountId,c.PropertyOwnerName

if object_id('tempdb..#Intl_Surcharge_Commission') is not null drop table #Intl_Surcharge_Commission
select 
	Date,
	sum(Card_Volume_USD) Card_Volume , @Intl_Surcharge_Commission as Commission_Rate, @Intl_Surcharge_Commission/100 * sum(Card_Volume_USD) Commission 
	into #Intl_Surcharge_Commission
from #Intl_Surcharge
group by
	Date 
 
if object_id('tempdb..#PPB') is not null drop table #PPB
select cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R) , 0)) as date) Date ,
	sum(txn.Amount) as Card_Volume_USD, sum(txn.AmtNetPropFee) as Revenue_USD, count(*) as Txn_Count
	into #PPB
from                                           
   YapstoneDM.dbo.[Transaction] txn
   inner join ETLStaging..FinanceHAProductType Product on txn.IdClassId = Product.IdClassId and txn.PlatformId = Product.PlatformId
   left join #Intl_Surcharge_Ids Intl on txn.PlatformId = Intl.PlatformId and txn.IdClassId = Intl.IdClassId
where txn.PostDate_R between @start and @end
	and txn.TransactionCycleId in (1,3,4,9,16) -- Net
	and txn.PlatformId in (3) and txn.ProcessorId not in (14,16)
	and ( case when txn.PaymentTypeId in (1,2,3,11,12) then 1 
		when txn.PaymentTypeId in (10) and txn.ProcessorId in (22) and txn.Ref_BatchTypeId in (1) then 1 else 0 end
	) = 1  -- Card Volume
	and Product.ProductType in ('PPB')
	and Intl.PlatformId is null  -- don't count Intl volume because that will be in Intl Surcharge section
group by 
	year(txn.PostDate_R) , month(txn.PostDate_R) , cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R) , 0)) as date)  

if object_id('tempdb..#PPB_Commission') is not null drop table #PPB_Commission
select 
	Date,
	sum(Card_Volume_USD) Card_Volume , @PPB_Commission as Commission_Rate, @PPB_Commission/100 * sum(Card_Volume_USD) Commission 
	into #PPB_Commission
from #PPB
group by
	Date


if object_id('tempdb..#Discount_Pricing_Merchants') is not null drop table #Discount_Pricing_Merchants
select * into #Discount_Pricing_Merchants from (
   select 
           c.Platformid, c.PropertyOwnerAccountId
   from
           YapstoneDM..[Transaction] txn
           join ETLStaging..FinanceHAProductType pt on txn.PlatformId = pt.PlatformId and txn.IdClassId = pt.IdClassId
           join ETLStaging..FinanceHAPropertyOwners c on txn.PlatformId = c.Platformid and txn.Ref_CompanyId  = c.ChildCompanyId
           left join #Intl_Surcharge_Ids Intl on txn.PlatformId = Intl.PlatformId and txn.IdClassId = Intl.IdClassId
   where
           txn.TransactionCycleId in (1) and txn.PlatformId in (3) 
			and ( case when txn.PaymentTypeId in (1,2,3,11,12) then 1 
				when txn.PaymentTypeId in (10) and txn.ProcessorId in (22) and txn.Ref_BatchTypeId in (1) then 1 else 0 end
			) = 1  -- Card Volume
           and pt.ProductType in ('PPS')
           and Intl.PlatformId is null -- don't count Intl volume because that will be in Intl Surcharge section
           and txn.PostDate_R between @start and @end
           and ( ( txn.Amount > 200 ) and 
				( ( txn.AmtNetPropFee  / txn.Amount ) * 100 ) < 2.80
           )
   group by
           c.Platformid, PropertyOwnerAccountId
   ) src

if object_id('tempdb..#Discount_Pricing') is not null drop table #Discount_Pricing
select cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R) , 0)) as date) Date ,
	c.PropertyOwnerAccountId , c.PropertyOwnerName ,
	sum(txn.Amount) as Card_Volume_USD, sum(txn.AmtNetPropFee) as Revenue_USD, count(*) as Txn_Count
	into #Discount_Pricing
from                                           
   YapstoneDM.dbo.[Transaction] txn
   inner join ETLStaging..FinanceHAPropertyOwners c on txn.PlatformId = c.Platformid and txn.Ref_CompanyId = c.ChildCompanyId
   inner join YapstoneDM.dbo.Company c1             on txn.PlatformId = c1.PlatformId and txn.Ref_CompanyId = c1.CompanyId 
   inner join #Discount_Pricing_Merchants d on c.Platformid = d.PlatformId and c.PropertyOwnerAccountId = d.PropertyOwnerAccountId
   inner join ETLStaging..FinanceHAProductType Product on txn.IdClassId = Product.IdClassId and txn.PlatformId = Product.PlatformId
   left join #Intl_Surcharge_Ids Intl on txn.PlatformId = Intl.PlatformId and txn.IdClassId = Intl.IdClassId
where txn.PostDate_R between @start and @end
	and txn.TransactionCycleId in (1,3,4,9,16) -- Net
	and txn.PlatformId in (3) and txn.ProcessorId not in (14,16)
	and ( case when txn.PaymentTypeId in (1,2,3,11,12) then 1 
		when txn.PaymentTypeId in (10) and txn.ProcessorId in (22) and txn.Ref_BatchTypeId in (1) then 1 else 0 end
	) = 1  -- Card Volume
	and Product.ProductType in ('PPS')
	and Intl.PlatformId is null -- don't count Intl volume because that will be in Intl Surcharge section
group by 
	cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R) , 0)) as date),  
	c.PropertyOwnerAccountId,c.PropertyOwnerName

if object_id('tempdb..#Discount_Pricing_Commissions') is not null drop table #Discount_Pricing_Commissions
select 
	Date, sum(Card_Volume_USD) Card_Volume , round(sum(Revenue_USD)/sum(nullif(Card_Volume_USD,0))*100,2) Bill_Rate, sum(Revenue_USD) Revenue, 
	@Discount_Pricing_Commission as Commission_Rate,  @Discount_Pricing_Commission/100 * sum(Card_Volume_USD) Commission
	into #Discount_Pricing_Commissions
from #Discount_Pricing
group by
	Date
	

if object_id('tempdb..#PPS') is not null drop table #PPS
select cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R) , 0)) as date) Date ,
	sum(txn.Amount) as Card_Volume_USD, sum(txn.AmtNetPropFee) as Revenue_USD, count(*) as Txn_Count
	into #PPS
from                                           
   YapstoneDM.dbo.[Transaction] txn
   inner join ETLStaging..FinanceHAProductType Product on txn.IdClassId = Product.IdClassId and txn.PlatformId = Product.PlatformId
   inner join ETLStaging..FinanceHAPropertyOwners c on c.Platformid = txn.PlatformId and c.ChildCompanyId = txn.Ref_CompanyId
	left join #Discount_Pricing_Merchants d on c.PlatformId = d.PlatformId and c.PropertyOwnerAccountId = d.PropertyOwnerAccountId
	left join #Intl_Surcharge_Ids Intl on txn.PlatformId = Intl.PlatformId and txn.IdClassId = Intl.IdClassId	
	
where txn.PostDate_R between @start and @end
	and d.PlatformId is null -- ie don't double count PPS and discount pricing merchant
	and Intl.PlatformId is null -- ie don't double count Intl cuz that's handled elsewhere
	and txn.TransactionCycleId in (1,3,4,9,16) -- Net
	and txn.PlatformId in (3) and txn.ProcessorId not in (14,16)
	and ( case when txn.PaymentTypeId in (1,2,3,11,12) then 1 
		when txn.PaymentTypeId in (10) and txn.ProcessorId in (22) and txn.Ref_BatchTypeId in (1) then 1 else 0 end
	) = 1  -- Card Volume
	and Product.ProductType in ('PPS')
group by 
	year(txn.PostDate_R) , month(txn.PostDate_R) , cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R) , 0)) as date)  

if object_id('tempdb..#PPS_Commission') is not null drop table #PPS_Commission
select 
	Date,
	sum(Card_Volume_USD) Card_Volume , @PPS_Commission as Commission_Rate, @PPS_Commission/100 * sum(Card_Volume_USD) Commission 
	into #PPS_Commission
from #PPS
group by
	Date
		
	
	

	
if object_id('tempdb..#TPV') is not null drop table #TPV
select cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R) , 0)) as date) Date ,
	sum(txn.Amount) as TPV_Net
	into #TPV
from                                           
   YapstoneDM.dbo.[Transaction] txn
   join ETLStaging..FinanceHAProductType p on txn.PlatformId = p.PlatformId and txn.IdClassId = p.IdClassId
where txn.PostDate_R between @start and @end
	and txn.TransactionCycleId in (1,3,4,9,16) -- Net
	and txn.PlatformId in (3) 
	and txn.ProcessorId not in (14,16)
	and ( case when txn.PaymentTypeId in (1,2,3,11,12) then 1 
		when txn.PaymentTypeId in (10) and txn.ProcessorId in (22) and txn.Ref_BatchTypeId in (1) then 1 else 0 end
	) = 1  -- Card Volume
	and p.ProductType not in ('Ancillary')
group by 
	cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R) , 0)) as date)  




if object_id('tempdb..#ACH') is not null drop table #ACH
select cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R) , 0)) as date) Date ,
	count(*) as Txn_Count
	into #ACH
from                                           
   YapstoneDM.dbo.[Transaction] txn
   join ETLStaging..FinanceHAProductType p on txn.PlatformId = p.PlatformId and txn.IdClassId = p.IdClassId
where txn.PostDate_R between @start and @end
	and txn.TransactionCycleId in (1,3,4,9,16) -- Net
	and txn.PlatformId in (3) 
	and txn.ProcessorId not in (14,16)
	and txn.PaymentTypeId in (4,5)
	and p.ProductType not in ('Ancillary')
group by 
	cast(dateadd(d, -1 , dateadd(mm, (year(txn.PostDate_R) - 1900) * 12 + month(txn.PostDate_R) , 0)) as date)  

if object_id('tempdb..#ACH_Commission') is not null drop table #ACH_Commission
select *, Excess_over_5000 * Commission_Rate Commission into #ACH_Commission from (
select 
	Date, Txn_Count, case when Txn_Count > 5000 then Txn_Count - 5000 else 0 end as Excess_over_5000,
	@ACH_Commission Commission_Rate
from #ACH
) src



if object_id('tempdb..#Commission') is not null drop table #Commission
select * from (
	select Date,	'TPV' Description,	TPV_Net 'Volume/Count'	,null Commission_Rate		,null Commission			from #TPV							union all
	select Date,	'PPS',				Card_Volume				,Commission_Rate			,Commission					from #PPS_Commission				union all
	select Date,	'PPB',				Card_Volume				,Commission_Rate			,Commission					from #PPB_Commission				union all
	select Date,	'Discount Pricing',	Card_Volume				,Commission_Rate			,Commission					from #Discount_Pricing_Commissions	union all
	select Date,	'Intl Surcharge',	Card_Volume				,Commission_Rate			,Commission					from #Intl_Surcharge_Commission		union all
	select Date,	'ACH over 5000',	Excess_over_5000		,Commission_Rate			,-Commission				from #ACH_Commission 
) src

