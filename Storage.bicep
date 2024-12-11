import * as types from 'types.bicep'

param keyVaultName string
param sqlSettings types.sqlSettingsType
param storageAccountSettings types.storageAccountSettingsType[]
param templateSettings types.templateSettingsType

var sqlServerName = 'sql-${templateSettings.sufix}-${templateSettings.env}'
var SqlDatabaseName = 'sql-${templateSettings.sufix}-${templateSettings.env}'

module storageAccountModules 'Modules/Storage/StorageAccountV2.bicep' = [for storageAccountSetting in storageAccountSettings: {
  name: 'storageAccountModule-${storageAccountSetting.name}'
  params: {
    storageAccount: storageAccountSetting
    env: templateSettings.env
    keyVaultName: keyVaultName
    location: templateSettings.location
  }
}]

module SqlServerModule 'Modules/Sql/SqlServer.bicep' = {
  name: 'sqlServerModule'
  params: {
    name: sqlServerName
    sqlServerUsername: sqlSettings.sqlServerUsername
    sqlServerPassword: sqlSettings.sqlServerPassword
    location: templateSettings.location
  }
}

module sqlDatabaseModule 'Modules/Sql/SqlServerDatabase.bicep' = {
  name: 'sqlDatabaseModule'
  dependsOn: [
    SqlServerModule
  ]
  params: {
    name: SqlDatabaseName
    databaseSettings: sqlSettings.database
    sqlServerName: sqlServerName
    location: templateSettings.location
  }
}
