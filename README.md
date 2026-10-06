# RetailChain — Consolidación de Inventario con UNION y UNION ALL

Este proyecto resuelve la consolidación vertical de datos provenientes de múltiples sucursales (Norte y Sur) para responder a requerimientos comerciales y operacionales de RetailChain.

## Estructura del Repositorio
- `schema.sql`: Script DDL de creación de tablas y sentencias DML de inserción con los datos de prueba de ambas sucursales.
- `soluciones.sql`: Consultas SQL implementando `UNION`, `UNION ALL` y las subconsultas de comparación de registros.
- `README.md`: Justificación técnica y conceptual de las soluciones.

---

## Justificación Técnica y Respuestas a la Consigna

### 1. ¿Cuántas filas devuelve cada consulta y por qué son distintas?
- **Consulta 1 (`UNION`):** Devuelve **11 filas**.  
  Al consultar el catálogo unificado (`id_producto`, `nombre_producto`, `categoria`), los productos compartidos con idéntico ID y descripción (103 - Monitor 4K 27", 104 - Teclado Mecánico y 106 - SSD Externo 1TB) se consolidan eliminando sus registros duplicados.  
  *(Nota: El producto "Webcam HD 1080p" aparece dos veces porque en la sucursal Norte tiene ID 107 y en la Sur ID 111; al diferir en la clave, para el operador representan filas distintas).*
- **Consulta 2 (`UNION ALL`):** Devuelve **14 filas**.  
  Retorna la suma directa de los 7 registros de la Sucursal Norte y los 7 registros de la Sucursal Sur ($7 + 7 = 14$), preservando todas las líneas de stock físico sin realizar ninguna eliminación de duplicados.

### 2. ¿Por qué UNION ALL es más eficiente que UNION? ¿Qué operación interna realiza UNION?
`UNION ALL` simplemente apila los resultados de ambas consultas de forma secuencial en memoria o en el flujo de salida, demandando una complejidad algorítmica lineal $O(N)$.  
En contraste, `UNION` exige un paso de procesamiento adicional de **deduplicación** (habitualmente mediante un algoritmo de ordenamiento interno `Sort Unique` o una tabla de hash `Hash Aggregate`). Este proceso de comparación fila por fila consume ciclos de CPU y memoria temporal (o espacio en disco temporal en volúmenes masivos de datos), haciendo que `UNION` sea notablemente más costoso que `UNION ALL`.

### 3. ¿En qué casos de negocio usarías cada uno? (Ejemplos reales distintos)
- **Casos para `UNION` (Deduplicación estricta):**
  1. *Marketing y Campañas de Fidelización:* Unificar las listas de correos electrónicos de suscriptores al newsletter con la lista de compradores en tiendas físicas para crear una audiencia de envío publicitario sin enviar correos duplicados al mismo cliente.
  2. *Catálogo de Proveedores:* Combinar los padrones de proveedores aprobados de dos empresas fusionadas para tener un maestro unificado sin repeticiones de CUIT/RUT.
- **Casos para `UNION ALL` (Preservación de volumen e historial):**
  1. *Conciliación Transaccional Financiera:* Consolidar en una tabla analítica los cobros con tarjeta de crédito de la pasarela online y las transacciones de los POS físicos para calcular la facturación bruta total del día.
  2. *Auditoría de Logs del Sistema:* Apilar los registros de actividad o inicios de sesión de distintos servidores de autenticación para auditoría de seguridad y análisis forense forense, donde cada evento individual debe ser preservado obligatoriamente.

### 4. ¿Qué pasa si las columnas de ambas consultas no coinciden en número o tipo?
Si las consultas a unir no cumplen con las reglas de compatibilidad de conjuntos, el motor SQL detiene la ejecución y arroja un error de sintaxis/tipo:
- **Discrepancia en la cantidad de columnas:** Arroja un error de compatibilidad estructural (por ejemplo, en PostgreSQL: *`ERROR: each UNION query must have the same number of columns`*).
- **Discrepancia en tipos de datos:** Si columnas en la misma posición ordinal tienen tipos incompatibles que el motor no puede convertir implícitamente (por ejemplo, intentar emparejar un `INT` con un `VARCHAR` o `DATE`), el motor genera un error de conversión (ejemplo: *`ERROR: UNION types text and integer cannot be matched`*).
