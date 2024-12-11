
az group create --name rg-sample-bicep-deployment-ne --location northeurope

az deployment group create --name sampleBicepDeployment --resource-group rg-sample-bicep-deployment-ne --template-file Main.bicep --parameters test.bicepparam
