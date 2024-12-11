using 'Main.bicep'

param templateSettings = {
  location: 'northeurope'
  env: 'tst'
  sufix: 'bicepdemo'
}

param appServicePlanSku = {
  capacity: 1
  name: 'B1'
}

param sqlSettings = {
  sqlServerUsername: 'bicepdemo'
  sqlServerPassword: '__sqlServerPassword__'
  database: {
    sku: {
      name: 'Basic'
      tier: 'Basic'
      capacity: 5
    }
    maxSizeBytes: 2147483648
  }
}

param storageAccountSettings = [
  {
    name: 'data'
    sku: {
      name: 'Standard_LRS'
      tier: 'Standard'
    }
  }
  {
    name: 'logging'
    sku: {
      name: 'Standard_LRS'
      tier: 'Standard'
    }
  }
]
