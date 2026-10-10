# Resultados de ejecución en Windows

Fecha: 9 de octubre de 2026, hora de Ciudad de México.
Procedencia: extractos de las salidas de PowerShell compartidas por el alumno durante la práctica. No se presentan como comandos ejecutados por el entorno de preparación ni como capturas de pantalla.

## 1 Herramientas

```text
Terraform v1.16.5
on windows_amd64
azure-cli: 2.91.0
git version 2.56.0.windows.1
```

## 2 Cuenta y suscripción

Se comprobó la cuenta universitaria indicada y la suscripción Azure for Students.
Al principio, el registro de Microsoft.Network falló con ReadOnlyDisabledSubscription.
El alumno confirmó que había agotado el crédito y actualizó su suscripción.
La consulta posterior mediante az account list --refresh devolvió Enabled.

## 3 Microsoft Network

Estado inicial: NotRegistered.
Tras un intento posterior de az provider register --namespace Microsoft.Network --subscription ID_REAL --wait, se consultó:

```json
{
  "namespace": "Microsoft.Network",
  "state": "Registered"
}
```

ID_REAL es un marcador de anonimización en este extracto, no el valor utilizado al ejecutar el comando. Se utilizó el ID verdadero obtenido de Azure CLI.

## 4 Inicialización y validación

```text
- Reusing previous version of hashicorp/azurerm from the dependency lock file
- Installing hashicorp/azurerm v5.9.0...
- Installed hashicorp/azurerm v5.9.0 (signed by HashiCorp)
Terraform has been successfully initialized!
Success! The configuration is valid.
```

El init añadió el checksum correspondiente a Windows al archivo .terraform.lock.hcl.

## 5 Plan inicial

Comando que terminó correctamente:

```powershell
terraform plan "-out=practica.tfplan"
```

```text
# azurerm_resource_group.rg will be created
# azurerm_virtual_network.vnet will be created
Plan: 2 to add, 0 to change, 0 to destroy.
Saved the plan to: practica.tfplan
```

Grupo: rg-integradora-dev-mexicocentral-001.
Red: vnet-integradora-dev-mexicocentral-001.
Región: mexicocentral. Espacio de red: 10.10.0.0/16.
Los IDs se indicaron como known after apply.

## 6 Apply y outputs

Comando:

```powershell
terraform apply "practica.tfplan"
```

```text
azurerm_resource_group.rg: Creation complete after 27s
azurerm_virtual_network.vnet: Creation complete after 12s
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

Se obtuvieron resource_group_id, resource_group_name, virtual_network_address_space, virtual_network_id y virtual_network_name.
Los IDs completos contienen la suscripción real y se omiten de este extracto público.

## 7 Comprobación de Azure y ausencia de cambios

Salida de az network vnet show:

```json
{
  "estado": "Succeeded",
  "nombre": "vnet-integradora-dev-mexicocentral-001",
  "rangos": ["10.10.0.0/16"]
}
```

Plan posterior:

```text
No changes. Your infrastructure matches the configuration.
Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```

## 8 Git

Push publicado en https://github.com/emilianoarratia/terraform-segundo-programa, rama main.
Estado reportado después del push:

```text
On branch main
Your branch is up to date with 'origin/main'.
nothing to commit, working tree clean
```

Historial del push del alumno:

```text
834fd01 chore: registrar checksum de AzureRM para Windows
ec643f7 docs: registrar auditoria validaciones y pasos pendientes
9fcc7fc feat: reproducir grupo y red virtual de segundo programa
c8cbc7c chore: iniciar practica y excluir estado y credenciales
```

Una actualización posterior de documentación registra este resultado final conservando esos cuatro commits.
No se ejecutó terraform destroy.
Las capturas reales se incorporarán al reporte Word cuando el alumno las adjunte.
