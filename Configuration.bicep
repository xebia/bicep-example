import * as types from 'types.bicep'

param keyVaultName string
param appConfigurationName string
param location string

module keyVaultModule 'Modules/Keyvault/KeyVault.bicep' = {
  name: 'keyVaultModule'
  params: {
    keyVaultName: keyVaultName
    location: location
  }
}

module appConfigurationModule 'Modules/AppConfiguration/AppConfiguration.bicep' = {
  name: 'appConfigurationModule'
  params: {
    appConfigurationName: appConfigurationName
    location: location
  }
}
