import * as types from 'types.bicep'

param sqlSettings types.sqlSettingsType
param appServicePlanSku types.appServicePlanSkuType
param storageAccountSettings types.storageAccountSettingsType[]
param templateSettings types.templateSettingsType

var keyVaultName = 'kv-${templateSettings.sufix}-${templateSettings.env}'
var appConfigurationName = 'appconfig-${templateSettings.sufix}-${templateSettings.env}'

module configurationModule './Configuration.bicep' = {
  name: 'configurationModule'
  params: {
    keyVaultName: keyVaultName
    appConfigurationName: appConfigurationName
    location: templateSettings.location
  }
}

module apiModule './Api.bicep' = {
  name: 'apiModule'
  dependsOn: [
    configurationModule
  ]
  params: {
    appServicePlanSku: appServicePlanSku
    keyVaultName: keyVaultName
    appConfigurationName: appConfigurationName
    templateSettings: templateSettings
  }
}

module storageModule './Storage.bicep' = {
  name: 'storageModule'
  dependsOn: [
    configurationModule
  ]
  params: {
    keyVaultName: keyVaultName
    sqlSettings: sqlSettings
    storageAccountSettings: storageAccountSettings
    templateSettings: templateSettings
  }
}
