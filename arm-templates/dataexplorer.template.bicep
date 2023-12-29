@description('Name of the cluster to create')
param adxClusterName string

param location string = resourceGroup().location

@description('Pricing tier i.e. Basic or Standard')
param tier string = 'Standard'

@description('Type of underlying compute used')
param computeType string = 'Standard_E2a_v4'

@description('number of throughput/processing units')
param capacity int = 2

@description('Enable/disable auto-scaling')
param autoScaleEnabled bool = false

@description('Enable/disable auto-scaling')
param autoScaleLimit int = 5

@description('Name of the database to create')
param adxDatabaseName string = 'kustodb'

@description('Script containing all kusto commands to setup tables, mapping, functions and policies')
param adxScript string = ''

@description('Name of the Event Hub Namespace containing all the Event Hubs')
param eventHubNamespaceName string = ''

@description('Array containing all Event Hub names.')
param tableNames array = []

resource adxCluster 'Microsoft.Kusto/clusters@2022-12-29' = {
  name: adxClusterName
  location: location
  sku: {
    name: computeType
    tier: tier
    capacity: capacity
  }
  properties: {
    optimizedAutoscale: {
      version: 1
      isEnabled: autoScaleEnabled
      minimum: capacity
      maximum: autoScaleLimit
    }
    enableDiskEncryption: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource adxClusterName_adxDatabase 'Microsoft.Kusto/clusters/databases@2022-12-29' = {
  parent: adxCluster
  name: adxDatabaseName
  location: location
  kind: 'ReadWrite'
  properties: {
    softDeletePeriod: '365'
    hotCachePeriod: '31'
  }
}

resource adxClusterName_adxDatabaseName_adxScript 'Microsoft.Kusto/clusters/databases/scripts@2022-12-29' = {
  parent: adxClusterName_adxDatabase
  name: 'adxScript'
  properties: {
    scriptContent: adxScript
    continueOnErrors: false
  }
}

resource adxClusterName_adxDatabaseName_dc_tableNames 'Microsoft.Kusto/clusters/databases/dataConnections@2022-12-29' = [for item in tableNames: {
  name: '${adxClusterName}/${adxDatabaseName}/dc-${toLower(item)}'
  location: location
  kind: 'EventHub'
  properties: {
    compression: 'None'
    databaseRouting: 'Single'
    consumerGroup: '$Default'
    dataFormat: 'MULTIJSON'
    eventHubResourceId: resourceId('Microsoft.EventHub/namespaces/eventhubs', eventHubNamespaceName, 'insights-logs-advancedhunting-${toLower(item)}')
    managedIdentityResourceId: adxCluster.id
    mappingRuleName: '${item}RawMapping'
    tableName: '${item}Raw'
  }
  dependsOn: [
    adxClusterName_adxDatabase
    adxClusterName_adxDatabaseName_adxScript
  ]
}]
