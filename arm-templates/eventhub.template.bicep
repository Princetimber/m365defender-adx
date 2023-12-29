param location string = resourceGroup().location
@secure()
param eventHubNamespaceName string

@description('Array containing all Event Hub names.')
param eventHubNames array = []

@allowed([
  'basic'
  'standard'
  'premium'
])
param sku string = 'standard'

@minValue(0)
@maxValue(40)
param skuCapacity int = 1
param enableAutoInflate bool = true

@minValue(0)
@maxValue(40)
param maxAutoInflate int = 40

@minValue(1)
@maxValue(32)
param partitionCount int = 32
param zoneRedundant bool = false

@minValue(1)
@maxValue(7)
param messageRetentionInDays int = 7

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  name: eventHubNamespaceName
  location:location
  sku: {
    name: sku
    tier: sku
    capacity: skuCapacity
  }
  properties: {
    zoneRedundant: zoneRedundant
    isAutoInflateEnabled: enableAutoInflate
    maximumThroughputUnits: maxAutoInflate
    kafkaEnabled: true
  }
}
resource eventHubNamespaceName_RootManageSharedAccessKey 'Microsoft.EventHub/namespaces/AuthorizationRules@2017-04-01' = {
  parent: eventHubNamespace
  name: 'RootManageSharedAccessKey'
  properties: {
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
}
resource eventHubNamespaceName_eventHubNames 'Microsoft.EventHub/namespaces/eventhubs@2017-04-01' = [for item in eventHubNames: {
  name: '${eventHubNamespaceName}${item}'
  properties: {
    messageRetentionInDays: messageRetentionInDays
    partitionCount: partitionCount
    status: 'Active'
  }
  parent: eventHubNamespace
}]
resource eventHubNamespaceName_eventHubNames_Default 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2017-04-01' = [for item in eventHubNames: {
  name: '${eventHubNamespaceName}/${item}/$Default'
  properties: {
    userMetadata: 'Default consumer group'
  }
  dependsOn: [
    eventHubNamespaceName_eventHubNames[item]
  ]
}]
resource eventHubNamespaceName_default 'Microsoft.EventHub/namespaces/networkRuleSets@2023-01-01-preview' = {
  parent: eventHubNamespace
  name: 'default'
  properties: {
    defaultAction: 'Allow'
    virtualNetworkRules: []
    ipRules: []
  }
}
output eventHubNamespaceResourceId string = eventHubNamespace.id

