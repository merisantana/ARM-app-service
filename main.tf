{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "appName": {
            "type": "string",
            "minLength": 1,
            "metadata": {
                "description": "Nombre de la aplicación"
            }
        },
        "runtime": {
            "type": "string",
            "defaultValue": "dotnet",
            "allowedValues": [
                "dotnet",
                "node",
                "python",
                "java"
            ],
            "metadata": {
                "description": "Runtime de la aplicación"
            }
        },
        "sku": {
            "type": "string",
            "defaultValue": "F1",
            "allowedValues": [
                "F1",
                "D1",
                "B1",
                "B2",
                "B3",
                "S1",
                "S2",
                "S3"
            ],
            "metadata": {
                "description": "SKU del servicio de aplicación"
            }
        },
        "location": {
            "type": "string",
            "defaultValue": "[resourceGroup().location]",
            "metadata": {
                "description": "Ubicación del servicio de aplicación"
            }
        }
    },
    "variables": {
        "appServicePlanName": "[concat(parameters('appName'), '-asp')]"
    },
    "resources": [
        {
            "type": "Microsoft.Web/serverfarms",
            "apiVersion": "2018-02-01",
            "name": "[variables('appServicePlanName')]",
            "location": "[parameters('location')]",
            "sku": {
                "name": "[parameters('sku')]"
            },
            "kind": "app",
            "properties": {
                "name": "[variables('appServicePlanName')]"
            }
        },
        {
            "type": "Microsoft.Web/sites",
            "apiVersion": "2018-11-01",
            "name": "[parameters('appName')]",
            "location": "[parameters('location')]",
            "kind": "app",
            "dependsOn": [
                "[resourceId('Microsoft.Web/serverfarms', variables('appServicePlanName'))]"
            ],
            "properties": {
                "name": "[parameters('appName')]",
                "serverFarmId": "[resourceId('Microsoft.Web/serverfarms', variables('appServicePlanName'))]",
                "siteConfig": {
                    "runtimeStack": "[parameters('runtime')]"
                }
            }
        }
    ],
    "outputs": {
        "appUrl": {
