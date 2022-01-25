param location string = resourceGroup().location

param catalog_api_image string
param orders_api_image string
param ui_image string
param registry string
param registryUsername string

@secure()
param registryPassword string

module env 'environment.bicep' = {
  name: 'containerAppEnvironment'
  params: {
    location: location
  }
}

module catalog_api 'container-app.bicep' = {
  name: 'catalog-api'
  params: {
    name: 'catalog-api'
    containerAppEnvironmentId: env.outputs.id
    registry: registry
    registryPassword: registryPassword
    registryUsername: registryUsername
    repositoryImage: catalog_api_image
    allowExternalIngress: false
    allowInternalIngress: true
  }
}

var catalog_api_fqdn = 'https://${catalog_api.outputs.fqdn}'

module orders_api 'container-app.bicep' = {
  name: 'orders-api'
  params: {
    name: 'orders-api'
    containerAppEnvironmentId: env.outputs.id
    registry: registry
    registryPassword: registryPassword
    registryUsername: registryUsername
    repositoryImage: orders_api_image
    allowExternalIngress: false
    allowInternalIngress: true
  }
}

var orders_api_fqdn = 'https://${orders_api.outputs.fqdn}'

module ui 'container-app.bicep' = {
  name: 'frontend'
  params: {
    name: 'frontend'
    containerAppEnvironmentId: env.outputs.id
    registry: registry
    registryPassword: registryPassword
    registryUsername: registryUsername
    repositoryImage: ui_image
    allowExternalIngress: true
    allowInternalIngress: false
    envVars : [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
      {
        name: 'CATALOG_API'
        value: catalog_api_fqdn
      }
      {
        name: 'ORDERS_API'
        value: orders_api_fqdn
      }
    ]
  }
}
