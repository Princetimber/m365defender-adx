param workspaceName string
param adxClusterName string
param adxDatabaseName string
param tableNames array = [
  'AlertInfo'
  'AlertEvidence'
  'DeviceInfo'
  'DeviceNetworkInfo'
  'DeviceProcessEvents'
  'DeviceNetworkEvents'
  'DeviceFileEvents'
  'DeviceRegistryEvents'
  'DeviceLogonEvents'
  'DeviceImageLoadEvents'
  'DeviceEvents'
  'DeviceFileCertificateInfo'
  'EmailAttachmentInfo'
  'EmailEvents'
  'EmailPostDeliveryEvents'
  'EmailUrlInfo'
  'UrlClickEvents'
  'IdentityLogonEvents'
  'IdentityQueryEvents'
  'IdentityDirectoryEvents'
  'CloudAppEvents'
]

resource workspaceName_adx_tableNames 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = [for item in tableNames: {
  name: '${workspaceName}/adx_${item}'
  properties: {
    category: 'ADX'
    displayName: 'adx_${item}'
    query: 'adx("https://${adxClusterName}/${adxDatabaseName}").${item}'
    functionAlias: 'adx_${item}'
  }
}]
