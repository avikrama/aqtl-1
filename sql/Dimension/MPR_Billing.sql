declare @date as date = '2015-10-31', @start as date  ,
 
@COGS_Total as int = 6560096
,/* @COGS_MPR as int = 7474458*/ @COGS_MPR as decimal(25,2), @Card_Volume_USD_Allocable as decimal(25,2) ,
@Homeaway_Domestic as int = 2731206
, @Homeaway_Intl as int = 200000, @NonProfit as int = 73830 , @Known_COGS as nvarchar(max),
@COGS as nvarchar(max), @ACH as nvarchar(max), @Amex_Processing as nvarchar(max), @Total_COGS as nvarchar(max)
if object_id('tempdb..#COGS') is not null drop table #COGS
create table #COGS (Vertical nvarchar(max), Credit decimal(25,2), Debit decimal(25,2), Blend decimal(25,2), Amex decimal(25,2), ACH decimal(25,2))
if object_id('tempdb..#Known_COGS') is not null drop table #Known_COGS
create table #Known_COGS (Vertical nvarchar(max), COGS decimal(25,2))
if object_id('tempdb..#Total_COGS') is not null drop table #Total_COGS
create table #Total_COGS (Excess_COGS decimal(25,2), Allocable_Card_Volume_USD decimal(25,2))
 
set @start = dateadd(d,1,dateadd(m,-1,@date))
set @Card_Volume_USD_Allocable = (   select sum(Card_Volume_Net_USD)  from  ETLStaging..FinanceMPR MPR 
                                                           where MPR.Gateway in ('YapProcessing')
                                                                   and MPR.Date in (@date)
                                                                   and MPR.Vertical not in ('HA-Intl','HA')    )                                                                                                             
 
set @ACH =                           '             insert into #ACH select ''0.03''                                          '
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
set @Known_COGS = '
insert into #Known_COGS select ''HA'', '''+cast(@Homeaway_Domestic as nvarchar(max))+'''
insert into #Known_COGS select ''HA-Intl'', '''+cast(@Homeaway_Intl as nvarchar(max))+'''
insert into #Known_COGS select ''NonProfit'', '''+cast(@NonProfit as nvarchar(max))+''' '
exec(@COGS+';'+@Known_COGS)  
if object_id('tempdb..#MPR') is not null drop table #MPR
 
set @COGS_MPR = (
select sum(isnull((Txn_Count * COGS.ACH),0) + case when MPR.Vertical not in ('HA') then
                      isnull( ((Credit_Card_Net_USD - Amex_Processing_Net_USD) * COGS.Credit * 0.01),0) + isnull((Debit_Card_Net_USD * COGS.Debit * 0.01),0) + isnull((Amex_Processing_Net_USD * COGS.Amex * 0.01),0)
          when MPR.Vertical in ('HA') then isnull(Known_COGS.COGS,0)  end )
from
       ETLStaging..FinanceMPR MPR
       left join #Known_COGS Known_COGS on MPR.Vertical = Known_COGS.Vertical and MPR.FeePaymentType in ('PropertyPaid') and MPR.PaymentTypeGroup in ('Card') and MPR.Gateway in ('YapProcessing')
       left join #COGS COGS on COGS.Vertical = MPR.Vertical and MPR.Gateway in ('YapProcessing') and MPR.PaymentTypeGroup not in ('Cash')
where MPR.Gateway in ('YapProcessing') and MPR.Date in (@date) and MPR.Vertical not in ('HA-Intl')
)
 
set @Total_COGS = 'insert into #Total_COGS select '''+cast(abs(@COGS_Total-@COGS_MPR) as nvarchar(max))+''','''+cast(@Card_Volume_USD_Allocable as nvarchar(max))+''''
exec(@Total_COGS)

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
	sum(isnull((Txn_Count * COGS.ACH),0) +
		case when MPR.Vertical not in ('HA') then
			isnull( ((Credit_Card_Net_USD - Amex_Processing_Net_USD) * COGS.Credit * 0.01),0) + isnull((Debit_Card_Net_USD * COGS.Debit * 0.01),0) + isnull((Amex_Processing_Net_USD * COGS.Amex * 0.01),0)
			+      ( isnull(
					( ( cast(Card_Volume_Net_USD as decimal(18,2) ) / cast(Total_COGS.Allocable_Card_Volume_USD as decimal(18,2)) ) * Total_COGS.Excess_COGS  )
								 , 0)
					) -- Excess
	  when MPR.Vertical in ('HA') then isnull(Known_COGS.COGS,0) end) COGS_USD,
	sum(Txn_Count) Txn_Count,
	sum(Debit_Card_USD) Debit_TPV ,
	sum(isnull(Intl.Intl_Issuer_TPV,0)) Intl_Issuer_TPV
from
	ETLStaging..FinanceMPR MPR
	join ETLStaging..FinanceParentTable c on MPR.PlatformId = c.PlatformId and MPR.ParentAccountId = c.ChildAccountId
	left join #Known_COGS Known_COGS on MPR.Vertical = Known_COGS.Vertical and MPR.FeePaymentType in ('PropertyPaid') and MPR.PaymentTypeGroup in ('Card') and MPR.Gateway in ('YapProcessing')
	left join #COGS COGS on COGS.Vertical = MPR.Vertical and MPR.Gateway in ('YapProcessing') and MPR.PaymentTypeGroup not in ('Cash')
	left join #Total_COGS Total_Cogs on MPR.PaymentTypeGroup in ('Card','Amex-Processing') and MPR.Gateway in ('YapProcessing')
	left join #IntlVolume Intl on MPR.PlatformId = Intl.PlatformId and MPR.ParentAccountId = Intl.ParentAccountId and MPR.PaymentTypeGroup in ('Card') and MPR.FeePaymentType = Intl.FeePaymentType
where
	MPR.Gateway in ('YapProcessing','GatewayOnly')
	and MPR.Date in (@date)
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
 