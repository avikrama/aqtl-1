
declare @now date, @start date, @end date 

set @now = getdate()
set @start = dateadd(mm,(year(@now)- 1900) * 12 + month(@now) - 1 -1 , 0)
set @end   = dateadd(d,-1 , dateadd(mm,(year(@now)- 1900) * 12 + month(@now)- 1 , 0))  

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

	
select
	Date , MPR.SoftwareName, ParentName ,
	sum(TPV_Net_USD) Card_Volume_Net_USD, sum(Revenue_Net_USD) Revenue , sum(COGS_USD) Costs, sum(Revenue_Net_USD) - sum(COGS_USD) Profit, 
	cast(cast(software.CommissionRate*100 as decimal(10,0)) as varchar)+'%' as Commission_Rate, 
	software.CommissionRate * (sum(Revenue_Net_USD) - sum(COGS_USD)) Commission 
from
	ETLStaging..FinanceMPR MPR
	join #Softwares software on MPR.SoftwareName = software.SoftwareName
where
	MPR.Date in (@end)
	and MPR.PaymentTypeGroup in ('Card')
	and Gateway in ('YapProcessing')
group by
	Date, MPR.SoftwareName, ParentName, software.CommissionRate
order by SoftwareName, ParentName



