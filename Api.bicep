import * as types from 'types.bicep'


param appServicePlanSku types.appServicePlanSkuType
param keyVaultName string
param appConfigurationName string
param templateSettings types.templateSettingsType

var logAnalyticsWorkspaceName = 'log-${templateSettings.sufix}-${templateSettings.env}'
var appInsightsName = 'appi-${templateSettings.sufix}-${templateSettings.env}'
var webAppName = 'app-${templateSettings.sufix}-${templateSettings.env}'
var webAppNamePlan = 'plan-${templateSettings.sufix}-${templateSettings.env}'
var keyVaultSecretReaderRoleId = '4633458b-17de-408a-b874-0445c86b69e6' // RBAC Role: Key Vault Secrets User
var appConfigurationReaderRoleId = '516239f1-63e1-4d78-a4de-a74fb236a071' // RBAC Role: App Configuration Data Reader

module applicationInsightsModule 'Modules/Insights/ApplicationInsights.bicep' = {
  name: 'applicationInsightsModule'
  params: {
    applicationInsightsName: appInsightsName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    location: templateSettings.location
  }
}

module serverFarmModule 'Modules/WebApp/Serverfarm.bicep' = {
  name: 'serverFarmModule'
  params: {
    name: webAppNamePlan
    sku: appServicePlanSku
    location: templateSettings.location
  }
}

module webAppModule 'Modules/WebApp/WebApp.bicep' = {
  name: 'webAppModule'
  params: {
    webAppName: webAppName
    appServicePlanName: webAppNamePlan
    appSettings: [
      {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: applicationInsightsModule.outputs.instrumentationKey
      }
    ]
    location: templateSettings.location
  }
  dependsOn: [
    serverFarmModule
  ]
}

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource SecretReaderResource 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(webAppName, keyVaultSecretReaderRoleId)
  scope: kv
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', keyVaultSecretReaderRoleId)
    principalType: 'ServicePrincipal'
    principalId: webAppModule.outputs.principalId
  }
}

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2022-05-01' existing = {
  name: appConfigurationName
}

resource ConfigurationReaderResource 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(webAppName, appConfigurationReaderRoleId)
  scope: appConfiguration
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', appConfigurationReaderRoleId)
    principalType: 'ServicePrincipal'
    principalId: webAppModule.outputs.principalId
  }
}
