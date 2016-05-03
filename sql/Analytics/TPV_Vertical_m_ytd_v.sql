SELECT  r[1]::date AS date,         "Dues",         "HA",         "HA-Intl",         "Inn",         "NonProfit",         "Rent",         "SRP",         "VRP" 
FROM    crosstab (         
  'SELECT ARRAY[date::text] AS r, vertical, sum(tpv_usd)         
  FROM analytics 
  Where Gateway in (''YapProcessing'')  
  GROUP BY date, vertical         
  ORDER BY date'     
  , '
  SELECT DISTINCT vertical         
  FROM analytics       
  Where Gateway in (''YapProcessing'')  
  ORDER BY vertical'     
) AS newtable (         
  r varchar[],         "Dues" numeric,         "HA-Intl" numeric,         "HA" numeric,         "Inn" numeric,         "NonProfit" numeric,         "Rent" numeric,         "SRP" numeric,         "VRP" numeric     
);
