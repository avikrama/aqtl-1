 
declare @date as date = '2016-01-31',
@start as date = '2013-01-01'  , @end as date = '2016-01-31',
@COGS_Financials as nvarchar(max), @COGS as nvarchar(max)
if object_id('tempdb..#COGS') is not null drop table #COGS
create table #COGS (Vertical nvarchar(max), Credit decimal(25,2), Debit decimal(25,2), Blend decimal(25,2), Amex decimal(25,2), ACH decimal(25,2))
if object_id('tempdb..#COGS_Financials_Base') is not null drop table #COGS_Financials_Base
create table #COGS_Financials_Base ( Date date, Total_COGS decimal(25,2), Homeaway decimal(25,2), Allocable_Card_Volume decimal(25,2) )														

if object_id('tempdb..#Allocable_Card_Volume') is not null drop table #Allocable_Card_Volume
select MPR.Date, sum(MPR.Card_Volume_Net_USD)  Allocable_Card_Volume
	into #Allocable_Card_Volume
from  ETLStaging..FinanceBaseMPR MPR  
where MPR.Gateway in ('YapProcessing') and MPR.Vertical not in ('HA-Intl','HA')
group by MPR.Date

set @COGS =                          '           
insert into #COGS select ''Dues'',   ''1.99'',       ''0.36'',      ''1.36'',      ''2.29'',       ''0.03''
insert into #COGS select ''Inn'',    ''1.94'',       ''0.47'',      ''1.65'',      ''2.29'',       ''0.03''
insert into #COGS select ''Rent'',   ''2.02'',       ''0.37'',      ''1.19'',      ''2.29'',       ''0.03''
insert into #COGS select ''VRP'',    ''1.9'',       ''0.38'',      ''1.66'',      ''2.29'',       ''0.03''
insert into #COGS select ''SRP'',    ''2.09'',       ''0.73'',      ''1.19'',      ''2.29'',       ''0.03''
insert into #COGS select ''NonProfit'',     ''2.47'',       ''0.97'',      ''2.29'',      ''2.29'',       ''0.03''
insert into #COGS select ''HA'',     ''1.9'',       ''0.41'',      ''1.52'',      ''2.29'',       ''0.03''
insert into #COGS select ''HA-Intl'',       ''2.34'',       ''0.42'',      null,  null,  null
'   
set @COGS_Financials = '
insert into #COGS_Financials_Base select ''2013-01-31'' , 4334559 , 765895, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2013-01-31'') )
insert into #COGS_Financials_Base select ''2013-02-28'' , 3953897 , 731973, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2013-02-28'') )
insert into #COGS_Financials_Base select ''2013-03-31'' , 3913363 , 721878, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2013-03-31'') )
insert into #COGS_Financials_Base select ''2013-04-30'' , 3928581 , 777925, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2013-04-30'') )
insert into #COGS_Financials_Base select ''2013-05-31'' , 5044537 , 1018972, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2013-05-31'') )
insert into #COGS_Financials_Base select ''2013-06-30'' , 5522725 , 1110487, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2013-06-30'') )
insert into #COGS_Financials_Base select ''2013-07-31'' , 5457970 , 1196230, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2013-07-31'') )
insert into #COGS_Financials_Base select ''2013-08-31'' , 3965201 , 873302, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2013-08-31'') )
insert into #COGS_Financials_Base select ''2013-09-30'' , 3460856 , 860966, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2013-09-30'') )
insert into #COGS_Financials_Base select ''2013-10-31'' , 3764626 , 882692, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2013-10-31'') )
insert into #COGS_Financials_Base select ''2013-11-30'' , 4055276 , 974769, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2013-11-30'') )
insert into #COGS_Financials_Base select ''2013-12-31'' , 4195839 , 1137395, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2013-12-31'') )
insert into #COGS_Financials_Base select ''2014-01-31'' , 6173394 , 1719081, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2014-01-31'') )
insert into #COGS_Financials_Base select ''2014-02-28'' , 5255634 , 1596313, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2014-02-28'') )
insert into #COGS_Financials_Base select ''2014-03-31'' , 5740891 , 1782774, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2014-03-31'') )
insert into #COGS_Financials_Base select ''2014-04-30'' , 5309589 , 1689962, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2014-04-30'') )
insert into #COGS_Financials_Base select ''2014-05-31'' , 6702025 , 2131137, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2014-05-31'') )
insert into #COGS_Financials_Base select ''2014-06-30'' , 7670034 , 2476637, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2014-06-30'') )
insert into #COGS_Financials_Base select ''2014-07-31'' , 6970573 , 2277938, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2014-07-31'') )
insert into #COGS_Financials_Base select ''2014-08-31'' , 4975568 , 1698512, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2014-08-31'') )
insert into #COGS_Financials_Base select ''2014-09-30'' , 5012709 , 1830178, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2014-09-30'') )
insert into #COGS_Financials_Base select ''2014-10-31'' , 5223066 , 1775187, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2014-10-31'') )
insert into #COGS_Financials_Base select ''2014-11-30'' , 5080146 , 1920112, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2014-11-30'') )
insert into #COGS_Financials_Base select ''2014-12-31'' , 6342268 , 2369502, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2014-12-31'') )
insert into #COGS_Financials_Base select ''2015-01-31'' , 8204391 , 3372823, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2015-01-31'') )
insert into #COGS_Financials_Base select ''2015-02-28'' , 7263639 , 3017642, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2015-02-28'') )
insert into #COGS_Financials_Base select ''2015-03-31'' , 8013648 , 3315023, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2015-03-31'') )
insert into #COGS_Financials_Base select ''2015-04-30'' , 7342937 , 3000951, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2015-04-30'') )
insert into #COGS_Financials_Base select ''2015-05-31'' , 8717660 , 3503107, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2015-05-31'') )
insert into #COGS_Financials_Base select ''2015-06-30'' , 10721203 , 4363967, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2015-06-30'') )
insert into #COGS_Financials_Base select ''2015-07-31'' , 9287115 , 3672875, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2015-07-31'') )
insert into #COGS_Financials_Base select ''2015-08-31'' , 7186661 , 2889690, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2015-08-31'') )
insert into #COGS_Financials_Base select ''2015-09-30'' , 6386660 , 2661722, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2015-09-30'') )
insert into #COGS_Financials_Base select ''2015-10-31'' , 6560096 , 2731206, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2015-10-31'') )
insert into #COGS_Financials_Base select ''2015-11-30'' , 7485626 , 3187536, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2015-11-30'') )
insert into #COGS_Financials_Base select ''2015-12-31'' , 7849861 , 3301992, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2015-12-31'') )
insert into #COGS_Financials_Base select ''2016-01-31'' , 10455477 , 4733567, (select Allocable_Card_Volume from #Allocable_Card_Volume where Date in (''2016-01-31'') )
'
exec(@COGS+';'+@COGS_Financials)	

if object_id('tempdb..#Initial_COGS') is not null drop table #Initial_COGS
select 
	MPR.Date,
	sum(
		case 
			when MPR.PaymentTypeGroup in ('ACH_Scan','Amex') then (Txn_Count * COGS.ACH) else 0 end
		+
		case 
		when 
			MPR.Vertical not in ('HA') and MPR.PaymentTypeGroup in ('Card','Amex-Processing') then
			isnull( ((Credit_Card_Net_USD - Amex_Processing_Net_USD) * COGS.Credit * 0.01),0) + isnull((Debit_Card_Net_USD * COGS.Debit * 0.01),0) + isnull((Amex_Processing_Net_USD * COGS.Amex * 0.01),0) + isnull((case when TPV is null and PaymentTypeGroup in ('Card') then TPV_Billing else 0 end * COGS.Blend * 0.01),0)
		when 
			MPR.Vertical in ('HA') and MPR.PaymentTypeGroup in ('Card','Amex-Processing') and FeePaymentType in ('PropertyPaid') then
			isnull(COGS_Financials.Homeaway,0)
		else 0 end
	   ) Initial_COGS
	into #Initial_COGS
from
	ETLStaging..FinanceBaseMPR MPR
	left join #COGS COGS on COGS.Vertical = MPR.Vertical and MPR.Gateway in ('YapProcessing') and MPR.PaymentTypeGroup not in ('Cash')
	left join #COGS_Financials_Base COGS_Financials on MPR.Date = COGS_Financials.Date and MPR.Gateway in ('YapProcessing') and MPR.PaymentTypeGroup in ('Card')	
where MPR.Gateway in ('YapProcessing') and MPR.Vertical not in ('HA-Intl')	and MPR.PaymentTypeGroup not in ('Cash')
group by
	MPR.Date

if object_id('tempdb..#COGS_Financials') is not null drop table #COGS_Financials
select #COGS_Financials_Base.*, (#COGS_Financials_Base.Total_COGS - #Initial_COGS.Initial_COGS) Allocation		into #COGS_Financials
from
	#COGS_Financials_Base
	join #Initial_COGS on #COGS_Financials_BASE.Date = #Initial_COGS.Date



if object_id('tempdb..#MPR') is not null drop table #MPR
if object_id('tempdb..#MPR_Total') is not null drop table #MPR_Total



if object_id('tempdb..#IntlVolume') is not null drop table #IntlVolume
select * into #IntlVolume from (
	select
		txn.PlatformId , c.ParentAccountId, 
		case when abs(txn.AmtNetConvFee) = 0 then 'PropertyPaid' when abs(txn.AmtNetConvFee) <> 0 then 'ConvFee' end as FeePaymentType ,
		sum(txn.Amount) as Intl_Issuer_TPV
	from
		YapstoneDM..[Transaction] txn
		join ETLStaging..FinanceParentTable c on txn.PlatformId = c.PlatformId and txn.Ref_CompanyId = c.ChildCompanyId
		join ETLStaging..FinanceIssuerType i on txn.PlatformId = i.PlatformId and txn.IdClassId = i.IdClassId
	where
		txn.PlatformId in (1,2,3)
		and txn.PostDate_R between @start and @date
		and txn.TransactionCycleId in (1)
		and txn.ProcessorId not in (14,16)
		and i.CardType in ('Intl')
	group by
		txn.PlatformId , c.ParentAccountId ,
		case when abs(txn.AmtNetConvFee) = 0 then 'PropertyPaid' when abs(txn.AmtNetConvFee) <> 0 then 'ConvFee' end
)  src

 
select * into #MPR from (
select
	MPR.Date , MPR.PlatformId , MPR.SoftwareName ,  
	MPR.Gateway,MPR.Vertical, MPR.ParentAccountId, MPR.ParentName , c.DateFirstSeen ,
	MPR.FeePaymentType ,MPR.PaymentTypeGroup ,
	sum(TPV_USD) TPV_USD,
	sum(TPV_Net_USD) TPV_Net_USD,
	sum(TPV_Billing) TPV_Billing,
	sum(Revenue_USD) Revenue_USD ,
	sum(Revenue_Net_USD) Revenue_Net_USD ,
	sum(
		isnull(
		case 
			when MPR.PaymentTypeGroup in ('ACH_Scan','Amex') then (Txn_Count * COGS.ACH) else 0 end
		+
		case 
		when 
			MPR.Vertical not in ('HA') and MPR.PaymentTypeGroup in ('Card','Amex-Processing') then
			isnull( ((Credit_Card_Net_USD - Amex_Processing_Net_USD) * COGS.Credit * 0.01),0) + isnull((Debit_Card_Net_USD * COGS.Debit * 0.01),0) + isnull((Amex_Processing_Net_USD * COGS.Amex * 0.01),0) + isnull((case when TPV is null and PaymentTypeGroup in ('Card') then TPV_Billing else 0 end * COGS.Blend * 0.01),0)
			+( 
				isnull( ( ( cast(Card_Volume_Net_USD as decimal(18,2) ) / cast(COGS_Financials.Allocable_Card_Volume as decimal(18,2)) ) * COGS_Financials.Allocation  ), 0) 
			  ) -- Excess
		when 
			MPR.Vertical in ('HA') and MPR.PaymentTypeGroup in ('Card','Amex-Processing') and MPR.FeePaymentType in ('PropertyPaid') then
			isnull(COGS_Financials.Homeaway,0)
		else 0
	   end
	   ,0)
	) COGS_USD,
	sum(Txn_Count) Txn_Count,
	sum(Debit_Card_USD) Debit_TPV ,
	sum(isnull(Intl.Intl_Issuer_TPV,0)) Intl_Issuer_TPV
from
	ETLStaging..FinanceBaseMPR MPR
	join ETLStaging..FinanceParentTable c on MPR.PlatformId = c.PlatformId and MPR.ParentAccountId = c.ChildAccountId
	left join #COGS COGS on COGS.Vertical = MPR.Vertical and MPR.Gateway in ('YapProcessing') and MPR.PaymentTypeGroup not in ('Cash')
	left join #IntlVolume Intl on MPR.PlatformId = Intl.PlatformId and MPR.ParentAccountId = Intl.ParentAccountId and MPR.PaymentTypeGroup in ('Card') and MPR.FeePaymentType = Intl.FeePaymentType
	left join #COGS_Financials COGS_Financials on MPR.Date = COGS_Financials.Date and MPR.Gateway in ('YapProcessing') and MPR.PaymentTypeGroup in ('Card','Amex-Processing')
where
	MPR.Gateway in ('YapProcessing','GatewayOnly')
	and MPR.Date between @start and @end
	and MPR.Vertical not in ('HA-Intl')
group by
	MPR.Date , MPR.PlatformId , MPR.SoftwareName ,  
    MPR.Gateway, MPR.Vertical  , MPR.ParentAccountId ,MPR.ParentName, c.DateFirstSeen ,
    MPR.FeePaymentType, MPR.PaymentTypeGroup
) src
 
 
 
select
	Date, PlatformId, SoftwareName , Gateway, Vertical, ParentAccountId, ParentName , DateFirstSeen ,
	FeePaymentType, PaymentTypeGroup ,
	sum(TPV_USD) as TPV_USD, sum(TPV_USD) - sum(TPV_Net_USD) as 'Refunds/Chargebacks', sum(TPV_Net_USD) as TPV_Net_USD , sum(TPV_Billing) as Invoice_TPV,
	sum(Revenue_Net_USD) as Revenue_Net_USD, sum(COGS_USD) as COGS_USD,  
	sum(Txn_Count) as Txn_Count, 
	sum(Debit_TPV) as Debit_TPV,
	sum(Intl_Issuer_TPV) Intl_Issuer_TPV
from
	#MPR MPR
group by
	Date, PlatformId, SoftwareName , Gateway, Vertical, ParentAccountId, ParentName , DateFirstSeen ,
	FeePaymentType, PaymentTypeGroup 
 