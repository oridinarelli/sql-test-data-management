# Data Model

Este documento describe la estructura de la base de datos, las relaciones entre entidades y el propósito de cada archivo SQL del proyecto.

---

# Objetivo del modelo

Simular un flujo básico de negocio donde una empresa:

- administra usuarios
- crea fichas
- registra operaciones

permitiendo realizar validaciones típicas de QA backend mediante SQL.

---

# Entidades

## companies

Almacena las empresas registradas en el sistema.

### Campos principales

| Campo | Tipo | Descripción |
|---|---|---|
| id | SERIAL | Identificador único |
| name | VARCHAR | Nombre de la empresa |
| country | VARCHAR | País |
| created_at | TIMESTAMP | Fecha de creación |

### Relaciones

- Una empresa puede tener muchos usuarios
- Una empresa puede tener muchas fichas
- Una empresa puede tener muchas operaciones

---

## users

Almacena usuarios asociados a una empresa.

### Campos principales

| Campo | Tipo | Descripción |
|---|---|---|
| id | SERIAL | Identificador único |
| company_id | INT | Empresa asociada |
| full_name | VARCHAR | Nombre completo |
| email | VARCHAR | Correo electrónico |
| role | VARCHAR | Rol del usuario |
| is_active | BOOLEAN | Usuario activo/inactivo |

### Relaciones

- Un usuario pertenece a una empresa
- Un usuario puede crear operaciones

---

## records

Representa fichas del sistema.

Puede representar:
- Personas naturales
- Empresas

### Campos principales

| Campo | Tipo | Descripción |
|---|---|---|
| id | SERIAL | Identificador único |
| company_id | INT | Empresa asociada |
| record_type | VARCHAR | Tipo de ficha |
| document_number | VARCHAR | Documento |
| full_name | VARCHAR | Nombre persona |
| business_name | VARCHAR | Nombre empresa |
| risk_level | VARCHAR | Nivel de riesgo |

### Relaciones

- Una ficha pertenece a una empresa
- Una ficha puede tener operaciones asociadas

---

## operations

Representa operaciones registradas en el sistema.

### Campos principales

| Campo | Tipo | Descripción |
|---|---|---|
| id | SERIAL | Identificador único |
| company_id | INT | Empresa asociada |
| record_id | INT | Ficha asociada |
| created_by | INT | Usuario creador |
| operation_type | VARCHAR | Tipo de operación |
| amount | NUMERIC | Monto |
| currency | VARCHAR | Moneda |
| status | VARCHAR | Estado operación |

### Relaciones

- Una operación pertenece a una empresa
- Una operación puede asociarse a una ficha
- Una operación puede ser creada por un usuario

---

# Relaciones del modelo

```text
companies
 ├── users
 ├── records
 └── operations

operations
 ├── records
 └── users
```

---

# Descripción de archivos SQL

## 01_create_database.sql

Crea la base de datos principal:

```text
qa_portfolio_demo
```

---

## 02_create_tables.sql

Crea todas las tablas del sistema junto con:

- claves primarias
- claves foráneas
- restricciones
- relaciones
- ON DELETE CASCADE

---

## 03_insert_test_data.sql

Inserta datos de prueba relacionados.

Características:
- utiliza IDs dinámicos
- evita hardcodear IDs
- mantiene integridad relacional
- simula datos reales de QA

Incluye:
- empresas
- usuarios
- fichas
- operaciones

---

## 04_validation_queries.sql

Contiene queries utilizadas para validaciones QA.

Ejemplos:
- operaciones por estado
- fichas por riesgo
- relaciones inválidas
- datos huérfanos
- resúmenes por empresa

---

## 05_cleanup_by_company_id.sql

Permite eliminar todos los datos asociados a una empresa específica.

Utiliza:
- transacciones
- validaciones previas
- borrado en cascada

Ideal para:
- limpieza de ambientes QA
- rollback de datos
- reinicio de pruebas

---

# Reglas importantes del modelo

## Integridad referencial

Las relaciones utilizan claves foráneas para asegurar consistencia.

---

## ON DELETE CASCADE

Permite que al eliminar una empresa también se eliminen automáticamente:

- usuarios
- fichas
- operaciones relacionadas

---

## IDs dinámicos

Los scripts utilizan:

```sql
RETURNING id INTO variable
```

para evitar depender de IDs hardcodeados.

---

# Casos de uso QA

Este modelo permite practicar:

- Validaciones backend
- SQL para QA
- Gestión de datos de prueba
- Validaciones relacionales
- Cleanup de ambientes
- Integridad de datos
- Queries analíticas
- Validaciones de negocio