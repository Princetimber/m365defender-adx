$tenantId            = [System.Text.ASCIIEncoding]::ASCII.GetString([System.Convert]::FromBase64String(" YTZiMTY5ZjEtNTkyYi00MzI5LThmMzMtOGRiODkwMzAwM2M3 "))
$serviceprincipalId  = [System.Text.ASCIIEncoding]::ASCII.GetString([System.Convert]::FromBase64String(" YjIzMTFjMzctNTU0ZC00NzEzLThkYjktMzZiZWQ4MzBlNTQy "))
$servicePrincipalKey = 
























./CalculateTableSizing.ps1 `
    -tenantId $tenantId `
    -appId $serviceprincipalId `
    -appSecret $servicePrincipalKey