# Terraform Segundo Programa

Práctica académica de Emiliano Gutierrez basada en los videos del profesor.

## Fuente y alcance

- Fuente: https://github.com/jorgealmeidamontiel/terraform-laboratories/tree/main/segundo-programa
- Revisión consultada: 9d0eb0eb0ec423248007a0df5e7031c29d138e8f
- La carpeta fuente contiene 14 videos y un TXT, sin archivos Terraform.
- La configuración se transcribió de los videos 11 a 14. Los videos 2 a 6 explican variables y un ejemplo previo con random_string.
- Recursos definidos: un grupo de recursos y una red virtual con 10.10.0.0/16.
- No se configuran máquinas virtuales, IP públicas, subredes ni otros servicios.

## Archivos

| Archivo | Función |
| --- | --- |
| terraform.tf | Versiones de Terraform y AzureRM |
| providers.tf | Autenticación con Azure CLI y suscripción real |
| variables.tf | Entradas y validaciones |
| locals.tf | Nombres y etiquetas comunes |
| terraform.tfvars | Valores públicos de la práctica |
| main.tf | Grupo de recursos y red virtual |
| output.tf | Cinco salidas del despliegue |
| .terraform.lock.hcl | Versión exacta del proveedor y comprobaciones |
| evidencias/ | Registros reales y diagnóstico |

## Ajustes respecto a los videos

Se conserva AzureRM ~> 5.0, Terraform >= 1.13.0, los nombres y el espacio de red.
La lista de direcciones se pasa directamente a address_space, sin listas anidadas.
El mensaje de validación del nombre describe el intervalo real de 5 a 20 caracteres.
No se incluye una suscripción ficticia ni la suscripción del profesor.
El ID se suministra mediante TF_VAR_subscription_id después de comprobar la cuenta real.
El propietario de las etiquetas es emilianoarratia.
El registro automático de proveedores se desactiva para consultar y registrar Microsoft.Network explícitamente con Azure CLI.

## Ejecución en PowerShell

Los comandos de esta sección son pasos pendientes salvo los documentados en evidencias.

```powershell
terraform version
az version
git --version
az login
$cuentaPractica = az account show -o json | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw "No se pudo consultar Azure" }
if ($cuentaPractica.user.name -ne "al222310542@utvtol.edu.mx") {
    throw "La sesión no corresponde a la cuenta universitaria indicada"
}
$cuentaPractica | Select-Object name, id, @{Name="usuario";Expression={$_.user.name}}
$env:TF_VAR_subscription_id = $cuentaPractica.id
az provider show --namespace Microsoft.Network --subscription $cuentaPractica.id --query "{namespace:namespace,state:registrationState}" -o json
```

Si Microsoft.Network no está registrado y tienes permisos:

```powershell
az provider register --namespace Microsoft.Network --subscription $cuentaPractica.id --wait
az provider show --namespace Microsoft.Network --subscription $cuentaPractica.id --query "{namespace:namespace,state:registrationState}" -o json
```

En la carpeta del proyecto:

```powershell
terraform fmt -check -diff
terraform init
terraform validate
terraform plan -out=practica.tfplan
```

Detenerse ante cualquier error. Revisar el plan real: para un estado nuevo debe proponer únicamente los dos recursos definidos, sin modificaciones ni eliminaciones. Confirmar la suscripción y comprobar que no hay recursos previos con los mismos nombres. El número de recursos todavía no se ha comprobado con un plan real.

Después de validar el plan:

```powershell
terraform apply practica.tfplan
terraform output
az group show --name rg-integradora-dev-mexicocentral-001 --subscription $cuentaPractica.id --query "{name:name,location:location,state:properties.provisioningState}" -o json
az network vnet show --resource-group rg-integradora-dev-mexicocentral-001 --name vnet-integradora-dev-mexicocentral-001 --subscription $cuentaPractica.id --query "{name:name,location:location,addressSpace:addressSpace.addressPrefixes,state:provisioningState}" -o json
terraform plan -detailed-exitcode
```

El último comando debe devolver 0 si no hay diferencias. No se ha ejecutado apply ni destroy. No eliminar recursos sin revisar qué contiene el grupo y el plan de destrucción.

## Git y entrega

El historial local tiene commits reales. El ZIP incluye un bundle para conservarlos:

```powershell
git clone .\terraform-segundo-programa.bundle terraform-segundo-programa
cd terraform-segundo-programa
```

Crear un repositorio vacío en tu cuenta, sin README inicial, y sustituir la URL siguiente por la URL real:

```powershell
git remote remove origin
git remote add origin URL_REAL_DE_TU_REPOSITORIO
git status
git diff
git log --oneline
git push -u origin main
```

El origin inicial del clon del bundle es el archivo local, nunca el repositorio del profesor.
No publicar archivos de estado, planes, credenciales ni capturas con secretos.

## Estado verificado

- Git 2.51.1, Terraform 1.13.4 y Azure CLI 2.91.0 disponibles en el entorno de revisión.
- terraform fmt -check: correcto.
- terraform init: correcto; AzureRM 5.9.0, firmado por HashiCorp.
- terraform validate: bloqueado por el entorno al abrir un socket Unix; no se afirma que haya validado.
- Azure: sin sesión autenticada al consultar az account show.
- Microsoft.Network: pendiente de consultar la suscripción real.
- Plan, apply, outputs reales y verificación de recursos: pendientes.
- Repositorio remoto y capturas reales de ejecución: pendientes.
- El Word final se generará después de comprobar esos resultados.
