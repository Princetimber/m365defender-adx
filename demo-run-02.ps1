














@'


DeviceEvents
| take 1


let TimeFilter = "where Timestamp between (startofday(ago(1d)) .. endofday(ago(1d)))";
    DeviceEvents
    | getschema
    | summarize CalculateStringLengths = array_strcat(make_list(strcat("strlen(tostring(", ColumnName, "))")), " + ")
    | project strcat("DeviceEvents", " | ", TimeFilter, " | project totalLengthBytes = ", CalculateStringLengths, " | summarize totalThroughputGB = sum(totalLengthBytes) / (1024 * 1024) * 2")


| extend tpu = round(totalThroughputGB / 86400)


'@


./CalculateTableSizing.ps1 `
    -tenantId $tenantId `
    -appId $serviceprincipalId `
    -appSecret $servicePrincipalKey
