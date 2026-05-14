# SQL Test Data Management

Proyecto SQL orientado a la gestión de datos de prueba para entornos QA.

El objetivo de este proyecto es simular un flujo básico de negocio utilizando una base de datos relacional con empresas, usuarios, fichas y operaciones, permitiendo:

- Crear estructuras relacionales
- Generar datos de prueba
- Ejecutar validaciones SQL
- Validar integridad de datos
- Limpiar información asociada a una empresa
- Practicar consultas utilizadas en QA backend

---

# Tecnologías utilizadas

- PostgreSQL
- Docker
- DBeaver
- SQL

---

# Estructura del proyecto

```text
sql-test-data-management/
│
├── cleanup/
│   └── 05_cleanup_by_company_id.sql
│
├── docs/
│   └── data_model.md
│
├── queries/
│   └── 04_validation_queries.sql
│
├── schema/
│   ├── 01_create_database.sql
│   └── 02_create_tables.sql
│
├── seed/
│   └── 03_insert_test_data.sql
│
└── README.md
```

---

# Requisitos previos

Antes de comenzar es necesario tener instalado:

- Docker Desktop
- DBeaver (o cualquier cliente SQL)
- Git 

---

# Levantar PostgreSQL con Docker

Abrir una terminal y ejecutar:

```bash
docker run --name postgres-demo \
-e POSTGRES_PASSWORD=admin123 \
-p 5432:5432 \
-d postgres
```

Este comando:

- Descarga PostgreSQL
- Crea un contenedor Docker
- Expone el puerto 5432
- Configura la contraseña del usuario postgres

---

# Verificar que el contenedor esté funcionando

```bash
docker ps
```

Debería aparecer algo similar a:

```text
postgres-demo
Up XX seconds
```

---

# Conexión desde DBeaver

Crear una nueva conexión PostgreSQL con los siguientes datos:

```text
Host: localhost
Puerto: 5432
Database: postgres
Usuario: postgres
Password: admin123
```

---

# Ejecución de scripts

Los scripts deben ejecutarse en el siguiente orden:

---

## 1. Crear base de datos

Ejecutar:

```text
schema/01_create_database.sql
```

Este script crea la base:

```text
qa_portfolio_demo
```

---

## 2. Crear tablas

Conectarse a la base `qa_portfolio_demo` y ejecutar:

```text
schema/02_create_tables.sql
```

Este script crea las tablas:

- companies
- users
- records
- operations

junto con:
- claves primarias
- claves foráneas
- relaciones
- reglas de borrado

---

## 3. Insertar datos de prueba

Ejecutar:

```text
seed/03_insert_test_data.sql
```

Este script:

- Genera datos de prueba relacionados
- Utiliza IDs dinámicos con `RETURNING INTO`
- Evita IDs hardcodeados
- Mantiene integridad relacional

---

## 4. Ejecutar validaciones SQL

Ejecutar:

```text
queries/04_validation_queries.sql
```

Incluye consultas para validar:

- Empresas creadas
- Usuarios asociados
- Fichas por riesgo
- Operaciones por estado
- Integridad de relaciones
- Operaciones inválidas
- Resúmenes por empresa

---

## 5. Limpiar datos de prueba

Ejecutar:

```text
cleanup/05_cleanup_by_company_id.sql
```

Este script elimina todos los datos asociados a una empresa utilizando:

```sql
ON DELETE CASCADE
```

permitiendo borrar automáticamente:
- usuarios
- fichas
- operaciones relacionadas

---

# Casos de uso QA

Este proyecto simula tareas comunes de QA backend como:

- Validaciones SQL
- Gestión de datos de prueba
- Verificación de integridad relacional
- Validación de datos huérfanos
- Limpieza de ambientes QA
- Verificación de reglas de negocio
- Análisis de datos en PostgreSQL

---

# Autor

Oriana Dinarelli

QA Engineer especializada en:
- Testing funcional
- Automatización
- API Testing
- SQL
- Gestión de datos de prueba
- Playwright
- PostgreSQL