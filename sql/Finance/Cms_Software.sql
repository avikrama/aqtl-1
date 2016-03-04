
declare @now date, @start date, @end date 

set @now = '2016-02-12'--getdate()
set @start = dateadd(mm,(year(@now)- 1900) * 12 + month(@now) - 1 -1 , 0)
set @end   = dateadd(d,-1 , dateadd(mm,(year(@now)- 1900) * 12 + month(@now)- 1 , 0)) 

if object_id('tempdb..#Exceptions') is not null drop table #Exceptions 
create table #Exceptions (ParentName nvarchar(max), SoftwareName nvarchar(max))
insert into #Exceptions select 'AD Real Estate Investors Inc', 'EZ Payments'
insert into	#Exceptions select 'Clinton Management', 'EZ Payments'
insert into	#Exceptions select 'Douglas Elliman Property Management', 'EZ Payments'
insert into	#Exceptions select 'Fairfield Properties', 'EZ Payments'

if object_id('tempdb..#Softwares') is not null drop table #Softwares
create table #Softwares (SoftwareName nvarchar(max), CommissionRate decimal(10,2))
insert into #Softwares select 'SkyRun', 0.15
insert into #Softwares select 'QuikStor' , 0.5 
insert into #Softwares select 'Evolve Vacation Rental Network', 0.25 
insert into #Softwares select 'Ciirus  Inc', 0.25 
insert into #Softwares select 'Resort Management System', 0.25 
insert into #Softwares select 'Kigo', 0.25 
insert into #Softwares select 'LiveRez', 0.33 
insert into #Softwares select 'ResSoft', 0.25 
insert into #Softwares select 'Resort Data Processing Inc RDP', 0.25 
insert into #Softwares select 'Innkeepers Advantage', 0.25 
insert into #Softwares select 'Vacation Rent Pro', 0.25 
insert into #Softwares select 'Advanced Technology Group  ATG', 0.25
insert into #Softwares select 'Tenant Technologies' ,  0.25
insert into #Softwares select 'TotalManagement Properties' , 0.25
insert into #Softwares select 'TotalManagement',  0.25
insert into #Softwares select 'EZ Payments',  0.30

	
select
	Date , coalesce(e.SoftwareName,MPR.SoftwareName) SoftwareName, MPR.ParentName ,
	sum(TPV_Net_USD) Card_Volume_Net_USD, sum(Revenue_Net_USD) Revenue , sum(COGS_USD) Costs, sum(Revenue_Net_USD) - sum(COGS_USD) Profit, 
	cast(cast(software.CommissionRate*100 as decimal(10,0)) as varchar)+'%' as Commission_Rate, 
	software.CommissionRate * (sum(Revenue_Net_USD) - sum(COGS_USD)) Commission 
from
	ETLStaging..FinanceMPR MPR
	left join #Exceptions e on MPR.ParentName = e.ParentName
	left join #Softwares software on coalesce(e.SoftwareName,MPR.SoftwareName)  = software.SoftwareName
where
	MPR.Date in (@end)
	and MPR.PaymentTypeGroup in ('Card')
	and Gateway in ('YapProcessing')
	and MPR.ParentName = 'Fairfield Properties'
group by
	Date, coalesce(e.SoftwareName,MPR.SoftwareName), MPR.ParentName, software.CommissionRate
order by SoftwareName, ParentName



