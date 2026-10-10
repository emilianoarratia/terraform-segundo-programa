# Terraform Segundo Programa

Práctica académica de Emiliano Gutierrez basada en los videos del profesor. Despliegue completado y validado en Windows el 9 de octubre de 2026.

Repositorio de entrega: https://github.com/emilianoarratia/terraform-segundo-programa

Rama: `main`.

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

Guía para reproducir el ejercicio. Los resultados de la ejecución en Windows están documentados en `evidencias/resultados-windows.md`. Los registros iniciales del entorno de preparación se conservan para trazabilidad.

```powershell
terraform version
az version
git --version
az login
$cuentaPractica = az account show -o json | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw "No se pudo consultar Azure" }
$cuentaPractica.user.name # Comprobar que corresponde a la cuenta universitaria autorizada.
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
terraform plan "-out=practica.tfplan"
```

Detenerse ante cualquier error. Revisar el plan real: para un estado nuevo debe proponer únicamente los dos recursos definidos, sin modificaciones ni eliminaciones. Confirmar la suscripción y comprobar que no hay recursos previos con los mismos nombres. En la ejecución documentada se comprobó: 2 por crear, 0 por modificar y 0 por eliminar.

Después de validar el plan:

```powershell
terraform apply "practica.tfplan"
terraform output
az group show --name rg-integradora-dev-mexicocentral-001 --subscription $cuentaPractica.id --query "{name:name,location:location,state:properties.provisioningState}" -o json
az network vnet show --resource-group rg-integradora-dev-mexicocentral-001 --name vnet-integradora-dev-mexicocentral-001 --subscription $cuentaPractica.id --query "{name:name,location:location,addressSpace:addressSpace.addressPrefixes,state:provisioningState}" -o json
terraform plan -detailed-exitcode
```

El último comando devuelve 0 si no hay diferencias. En esta práctica se ejecutó `terraform plan` después del apply y se obtuvo `No changes`. No se ejecutó `destroy`. Conservar las evidencias y revisar el plan de destrucción antes de eliminar recursos.

## Git y entrega

Código publicado en el repositorio propio, en `main`. El repositorio del profesor se usó solo como fuente de lectura.

```powershell
git clone https://github.com/emilianoarratia/terraform-segundo-programa.git
cd terraform-segundo-programa
git status
git log --oneline
```

El estado local reportado después del push fue `nothing to commit, working tree clean`.
La actualización de documentación posterior debe descargarse con `git pull --ff-only`.
No publicar archivos de estado, planes, credenciales ni capturas con secretos.

## Resultados verificados

| Comprobación | Resultado |
| --- | --- |
| Terraform en Windows | 1.16.5, windows_amd64 |
| Azure CLI | 2.91.0 |
| Git en Windows | 2.56.0.windows.1 |
| AzureRM | 5.9.0, firmado por HashiCorp |
| terraform fmt -check | Sin diferencias de formato reportadas |
| terraform init | Inicialización correcta |
| terraform validate | Success! The configuration is valid. |
| Suscripción | Azure for Students; estado Enabled |
| Microsoft.Network | Registered |
| Plan inicial | 2 to add, 0 to change, 0 to destroy |
| Apply | 2 added, 0 changed, 0 destroyed |
| Red en Azure CLI | Succeeded; rango 10.10.0.0/16 |
| Plan posterior | No changes. Your infrastructure matches the configuration. |
| GitHub | Código publicado en main |

Recursos creados:

- `rg-integradora-dev-mexicocentral-001`, grupo de recursos.
- `vnet-integradora-dev-mexicocentral-001`, red virtual en `mexicocentral`.

Se obtuvieron cinco outputs: nombre e ID del grupo, nombre e ID de la red y espacio de direcciones.
Los IDs completos y el contexto de la cuenta se reservan para el reporte académico; no son necesarios en esta documentación pública.

## Incidencias resueltas

1. El entorno inicial bloqueaba el socket Unix del proveedor y las consultas al endpoint de Azure. La ejecución se trasladó al PowerShell del alumno.
2. Faltaban Azure CLI y Terraform en Windows; se instalaron y comprobaron sus versiones.
3. La suscripción estaba deshabilitada por agotamiento de crédito, según informó el alumno. Tras su actualización, se confirmó Enabled. El registro seguía bloqueado temporalmente y un intento posterior terminó con Microsoft.Network Registered.
4. PowerShell devolvió Too many command line arguments al usar el argumento del plan sin comillas. Con `terraform plan "-out=practica.tfplan"` el plan se guardó correctamente.
5. El init de Windows añadió una suma de verificación de AzureRM al lock file, registrada en el commit 834fd01.

## Evidencias y reporte

`evidencias/resultados-windows.md` recoge extractos de las salidas compartidas por el alumno durante la ejecución real. No son capturas ni resultados ejecutados en el entorno inicial.
`evidencias/terraform-validate.txt`, `azure-contexto.txt` y `versiones.txt` conservan el diagnóstico de la preparación inicial; no representan el estado final de Windows.

La entrega de código está publicada. El reporte Word con capturas reales se completa cuando se adjunten las imágenes del alumno.
