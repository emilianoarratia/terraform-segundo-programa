# Auditoría inicial

## Estado actual

CORRECTO: se clonó main de la fuente con acceso de lectura y se enumeró la carpeta completa.
FALTANTE EN LA FUENTE: archivos .tf y .gitignore en segundo-programa.
La carpeta contiene 14 videos numerados del 2 al 15 y el TXT de Microsoft.Network.
Se extrajeron fotogramas cada 15 segundos para inspeccionar el contenido y el código mostrado.
Los resultados del profesor en los videos son material de referencia, no evidencia de ejecución del alumno.

## Objetivo identificado

Parametrizar infraestructura con variables y locals, declarar proveedor y versiones, crear un grupo de recursos y una red virtual en Azure y consultar cinco outputs.

## Contenido de los videos

| Video | Contenido observado |
| --- | --- |
| 2 Variables | length como entrada de random_string |
| 3 Pasar valores a variables | valores por -var y sustitución de random_string |
| 4 locals | composición de un nombre de aplicación |
| 5 ouputs | publicación y consulta de valores |
| 6 Tipos de datos en Terraform | string, number, bool, list, map, object y set |
| 7 Instalacion de Azure CLI | instalación y az version |
| 8 Conexion usuando Azure CLI | az login y selección de suscripción |
| 9 Demostracion | grupo, red y resultados de ejemplo del profesor |
| 10 Habilitar el proveedor de redes de Microsoft | consulta y registro de Microsoft.Network |
| 11 Creacion de variables y locals | archivos del proyecto, validaciones, nombres y etiquetas |
| 12 Configuracion de tfvars y providers | valores, list(string), features y subscription_id |
| 13 Configuracion de recursos | azurerm_resource_group.rg y azurerm_virtual_network.vnet |
| 14 Salidas | nombres, IDs y espacio de red |
| 15 Creacion de elementos | init, validate, despliegue y consulta en Portal del profesor |

## Azure

Se requiere autenticación real con al222310542@utvtol.edu.mx, selección de la suscripción y comprobación de Microsoft.Network. La suscripción del profesor no se reutiliza.

## Terraform

La configuración del alumno reproduce la parte de Azure; requiere init, validate, plan y apply. La red depende implícitamente del grupo mediante sus referencias.

## Git

Se prepara un repositorio independiente para emilianoarratia. El repositorio del profesor no se modifica. Falta crear el remoto propio.

## Evidencias y documento

Se conservan registros originales de herramientas, init y error de validate. Faltan capturas reales de la ejecución del alumno, contexto Azure, Microsoft.Network, plan, apply, outputs, recursos e historial remoto. El Word final tendrá las once secciones solicitadas, sin portada independiente ni pie de página.

## Plan y estado

1. Auditar fuente y herramientas: completado.
2. Preparar Terraform y Git local: completado; init y fmt correctos, validate bloqueado.
3. Verificar Azure y desplegar: pendiente de autenticación y validación en entorno compatible.
4. Publicar repositorio propio: pendiente de creación del remoto.
5. Crear Word definitivo: pendiente de resultados y capturas reales.

## Incidencia de validación

El proveedor falla antes de cargar su esquema: listen unix /tmp/plugin...: socket: operation not permitted.
La arquitectura y permisos del binario son correctos según el diagnóstico de Terraform.
No es un error HCL demostrado; tampoco permite afirmar que HCL validó correctamente.
Acción siguiente: ejecutar validate en Windows o Azure Cloud Shell, conservando la salida real.
