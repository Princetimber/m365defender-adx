














./DefenderArchiveR.ps1 `
    -TenantId "8c884f39-eb63-49ee-83e4-7ebe060b8e5a" `
    -appId "d5cd9e81-c5f5-4f4e-9ff6-736c7401c1de" `
    -appSecret $appSecret `
    -subscriptionId "c2fa5885-0b00-4976-96d4-b4ea2fa9d578" `
    -resourceGroupName "rg-m365d-archive-01" `
    -saveAdxScript `
    -m365defenderTables "`
        DeviceInfo, `
        DeviceNetworkInfo, `
        DeviceProcessEvents, `
        DeviceNetworkEvents, `
        DeviceFileEvents, `
        DeviceRegistryEvents, `
        DeviceLogonEvents, `
        DeviceEvents, `
        DeviceFileCertificateInfo, `
        EmailAttachmentInfo, `
        EmailEvents, `
        EmailUrlInfo `
    " `
    -deploySentinelFunctions
