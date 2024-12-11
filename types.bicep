@export()
type appServicePlanSkuType = {
  capacity: int
  name: string
}

@export()
type sqlSettingsType = {
  sqlServerUsername: string
  sqlServerPassword: string
  database: {
    sku: {
      name: string
      tier: string
      capacity: int
    }
    maxSizeBytes: int
  }
}

@export()
type storageAccountSettingsType = {
  name: string
  sku: {
    name: string
    tier: string
  }
}

@export()
type templateSettingsType = {
  location: string
  //storageContainer: string
  env: string
  sufix: string
}
