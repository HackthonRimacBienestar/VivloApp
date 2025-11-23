# Documentación de API - VivloApi

## Información General

- **Base URL**: `/api/v1`
- **Formato de Respuesta**: JSON
- **Autenticación**: No requerida (según configuración actual)

---

## Estructura de Respuesta Base

Todos los endpoints devuelven una estructura `BaseResponse<T>`:

```json
{
  "data": T,           // Datos de respuesta (puede ser null en caso de error)
  "message": "string", // Mensaje de error o información
  "success": boolean   // Indica si la operación fue exitosa
}
```

---

## 1. Endpoints de Usuarios (`/api/v1/users`)

### 1.1. Crear Usuario

**Endpoint**: `POST /api/v1/users`

**Descripción**: Crea un nuevo usuario en el sistema.

**Parámetros de Request (Body)**:
```json
{
  "username": "string",  // Requerido - Nombre de usuario
  "email": "string",     // Requerido - Email válido (formato validado)
  "dni": "string"        // Requerido - DNI con exactamente 7 caracteres
}
```

**Validaciones**:
- `email`: Debe tener formato de email válido
- `dni`: Debe tener exactamente 7 caracteres

**Respuesta Exitosa (201 Created)**:
```json
{
  "data": {
    "id": "string",              // GUID generado automáticamente
    "username": "string",
    "email": "string",
    "dni": "string",
    "createdAt": "datetime",     // Fecha UTC
    "updatedAt": null,
    "isDeleted": false
  },
  "message": "",
  "success": true
}
```

**Respuesta de Error (400 Bad Request)**:
```json
{
  "data": null,
  "message": "string",  // Mensaje de error (ej: "User already exists")
  "success": false
}
```

**Ejemplo de Request**:
```json
{
  "username": "Juan Pérez",
  "email": "juan.perez@example.com",
  "dni": "1234567"
}
```

---

### 1.2. Obtener Usuario por Email

**Endpoint**: `GET /api/v1/users/{email}`

**Descripción**: Obtiene la información de un usuario por su email.

**Parámetros de Ruta**:
- `email` (string, requerido): Email del usuario a buscar

**Respuesta Exitosa (200 OK)**:
```json
{
  "data": {
    "id": "string",
    "username": "string",
    "email": "string",
    "dni": "string",
    "createdAt": "datetime",
    "updatedAt": "datetime",
    "isDeleted": false
  },
  "message": "",
  "success": true
}
```

**Respuesta de Error (200 OK con success: false)**:
```json
{
  "data": null,
  "message": "string",  // Mensaje de error
  "success": false
}
```

**Ejemplo de Request**:
```
GET /api/v1/users/juan.perez@example.com
```

---

## 2. Endpoints de Rankings (`/api/v1/ranks`)

### 2.1. Crear Ranking

**Endpoint**: `POST /api/v1/ranks`

**Descripción**: Crea un nuevo ranking para un usuario. El ranking se inicializa con 0 puntos.

**Parámetros de Request (Body)**:
```json
{
  "userId": "string"  // Requerido - ID del usuario (debe existir)
}
```

**Validaciones**:
- El usuario debe existir en el sistema
- El usuario no debe tener un ranking ya creado

**Respuesta Exitosa (201 Created)**:
```json
{
  "data": {
    "id": "string",              // GUID generado automáticamente
    "userId": "string",
    "points": 0,                 // Inicializado en 0
    "createdAt": "datetime",
    "updatedAt": null,
    "isDeleted": false
  },
  "message": "",
  "success": true
}
```

**Respuesta de Error (400 Bad Request)**:
```json
{
  "data": null,
  "message": "string",  // Ejemplos: "Rank already exists for this user", "User does not exist"
  "success": false
}
```

**Ejemplo de Request**:
```json
{
  "userId": "550e8400-e29b-41d4-a716-446655440000"
}
```

---

### 2.2. Actualizar Ranking

**Endpoint**: `PUT /api/v1/ranks`

**Descripción**: Incrementa los puntos de un ranking existente.

**Parámetros de Request (Body)**:
```json
{
  "rankId": "string",  // Requerido - ID del ranking a actualizar
  "quantity": 0        // Requerido - Cantidad de puntos a incrementar (puede ser positivo o negativo)
}
```

**Nota**: La cantidad se suma a los puntos actuales. Si se envía un número negativo, los puntos disminuirán.

**Respuesta Exitosa (200 OK)**:
```json
{
  "data": {
    "id": "string",
    "userId": "string",
    "points": 0,                 // Puntos actualizados
    "createdAt": "datetime",
    "updatedAt": "datetime",     // Fecha actualizada automáticamente
    "isDeleted": false
  },
  "message": "",
  "success": true
}
```

**Respuesta de Error (400 Bad Request)**:
```json
{
  "data": null,
  "message": "string",  // Ejemplo: "Rank not found"
  "success": false
}
```

**Ejemplo de Request**:
```json
{
  "rankId": "660e8400-e29b-41d4-a716-446655440000",
  "quantity": 10
}
```

---

### 2.3. Obtener Top Rankings

**Endpoint**: `GET /api/v1/ranks?count={count}`

**Descripción**: Obtiene los rankings más altos ordenados por puntos de forma descendente.

**Parámetros de Query**:
- `count` (int, requerido): Número de rankings a retornar

**Respuesta Exitosa (200 OK)**:
```json
{
  "data": [
    {
      "userId1": 150  // Diccionario con userId como clave y points como valor
    },
    {
      "userId2": 120
    },
    {
      "userId3": 100
    }
  ],
  "message": "",
  "success": true
}
```

**Nota**: La respuesta es un array de diccionarios donde cada diccionario contiene un solo par clave-valor: `{ "userId": puntos }`. Los resultados están ordenados de mayor a menor cantidad de puntos.

**Ejemplo de Request**:
```
GET /api/v1/ranks?count=10
```

---

### 2.4. Obtener Ranking por Usuario

**Endpoint**: `GET /api/v1/ranks/{userId}`

**Descripción**: Obtiene el ranking de un usuario específico por su ID.

**Parámetros de Ruta**:
- `userId` (string, requerido): ID del usuario

**Respuesta Exitosa (200 OK)**:
```json
{
  "data": {
    "id": "string",
    "userId": "string",
    "points": 0,
    "createdAt": "datetime",
    "updatedAt": "datetime",
    "isDeleted": false
  },
  "message": "",
  "success": true
}
```

**Respuesta de Error (200 OK con success: false)**:
```json
{
  "data": null,
  "message": "string",  // Ejemplo: "Rank for UserId: {userId} not found."
  "success": false
}
```

**Ejemplo de Request**:
```
GET /api/v1/ranks/550e8400-e29b-41d4-a716-446655440000
```

---

## 3. Endpoints de Asistencia (`/api/v1/assitances`)

### 3.1. Invocar Modelo de IA

**Endpoint**: `POST /api/v1/assitances/invoke`

**Descripción**: Invoca el modelo de IA Claude 3.5 Sonnet de AWS Bedrock para procesar un prompt y obtener una respuesta.

**Modelo Utilizado**: `anthropic.claude-3-5-sonnet-20240620-v1:0`

**Parámetros de Request (Body)**:
```json
{
  "prompt": "string"  // Requerido - Texto del prompt a procesar
}
```

**Validaciones**:
- `prompt`: No puede estar vacío o ser null

**Respuesta Exitosa (200 OK)**:
```json
{
  "data": "string",   // Texto de respuesta del modelo de IA
  "message": "",
  "success": true
}
```

**Respuesta de Error (400 Bad Request)**:
```json
{
  "data": null,
  "message": "ModelId and InputText are required.",
  "success": false
}
```

**Respuesta de Error (500 Internal Server Error)**:
```json
{
  "data": null,
  "message": "string",  // Mensaje de error de la excepción
  "success": false
}
```

**Ejemplo de Request**:
```json
{
  "prompt": "¿Cuál es la capital de Francia?"
}
```

**Ejemplo de Respuesta**:
```json
{
  "data": "La capital de Francia es París.",
  "message": "",
  "success": true
}
```

---

## Códigos de Estado HTTP

- **200 OK**: Operación exitosa (GET, PUT)
- **201 Created**: Recurso creado exitosamente (POST)
- **400 Bad Request**: Error en la validación o en los datos enviados
- **500 Internal Server Error**: Error interno del servidor

---

## Notas Importantes

1. **Fechas**: Todas las fechas están en formato UTC (DateTime.UtcNow)
2. **IDs**: Los IDs se generan automáticamente como GUIDs (string)
3. **Validaciones**: 
   - El email debe tener formato válido
   - El DNI debe tener exactamente 7 caracteres
   - No se pueden crear rankings duplicados para el mismo usuario
4. **Puntos en Rankings**: Los puntos se incrementan sumando la cantidad especificada. Puede ser un número negativo para disminuir puntos.
5. **Top Rankings**: Los resultados están ordenados de mayor a menor cantidad de puntos.
6. **BaseResponse**: Todos los endpoints devuelven la estructura BaseResponse, incluso en caso de error (con `success: false`).

---

## Ejemplos de Uso Completo

### Flujo Típico: Crear Usuario y Ranking

1. **Crear Usuario**:
```http
POST /api/v1/users
Content-Type: application/json

{
  "username": "María García",
  "email": "maria.garcia@example.com",
  "dni": "7654321"
}
```

2. **Crear Ranking para el Usuario**:
```http
POST /api/v1/ranks
Content-Type: application/json

{
  "userId": "id-del-usuario-creado-en-paso-1"
}
```

3. **Actualizar Puntos del Ranking**:
```http
PUT /api/v1/ranks
Content-Type: application/json

{
  "rankId": "id-del-ranking-creado-en-paso-2",
  "quantity": 50
}
```

4. **Consultar Ranking del Usuario**:
```http
GET /api/v1/ranks/id-del-usuario
```

5. **Ver Top 5 Rankings**:
```http
GET /api/v1/ranks?count=5
```

