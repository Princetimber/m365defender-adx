$tenantId            = [System.Text.ASCIIEncoding]::ASCII.GetString([System.Convert]::FromBase64String(" YTZiMTY5ZjEtNTkyYi00MzI5LThmMzMtOGRiODkwMzAwM2M3 "))
$serviceprincipalId  = [System.Text.ASCIIEncoding]::ASCII.GetString([System.Convert]::FromBase64String(" YjIzMTFjMzctNTU0ZC00NzEzLThkYjktMzZiZWQ4MzBlNTQy "))
$servicePrincipalKey = 















let bytes_ = 500;
union withsource = MDTables*
| where Timestamp > startofday(ago(6h))
| summarize count() by bin(Timestamp, 1m), MDTables
| extend EPS = count_ / 60
| summarize avg(EPS), estimatedMBPerSec = (avg(EPS) * bytes_ ) 
			/ (1024 * 1024) by MDTables


let TimeFilter = "where Timestamp between (startofday(ago(1d)) .. endofday(ago(1d)))";
DeviceFileEvents
| getschema
| summarize CalculateStringLengths = array_strcat(make_list(strcat("strlen(tostring(", ColumnName, "))")), " + ")
| project strcat("DeviceFileEvents", " | ", TimeFilter, " | project totalLengthBytes = ", CalculateStringLengths, " | summarize totalThroughputMB = sum(totalLengthBytes) / (1024 * 1024) * 2")









./CalculateTableSizing.ps1 `
    -tenantId $tenantId `
    -appId $serviceprincipalId `
    -appSecret $servicePrincipalKey