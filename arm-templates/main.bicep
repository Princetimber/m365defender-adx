param location string = resourceGroup().location
module dataexplorer 'dataexplorer.template.bicep' = {
  name: 'dataexplorer'
    params: {
      location: location
      adxClusterName:''
    }
}
module eventhub 'eventhub.template.bicep' = {
  name: 'eventhub'
    params: {
      location: location
      eventHubNamespaceName:''
    }
    dependsOn: [
      dataexplorer
    ]
}
module workspace 'workspacefunctions.template.bicep' = {
  name: 'workspace'
    params:{
      adxClusterName:''
      workspaceName:''
        adxDatabaseName:''
    }
    dependsOn: [
      dataexplorer
      eventhub
    ]
}
