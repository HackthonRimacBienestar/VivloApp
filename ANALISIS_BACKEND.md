# Análisis de Backend API - VivloApi

## 📋 Resumen Ejecutivo

La API **VivloApi** proporciona tres grupos principales de endpoints:
1. **Usuarios** (`/api/v1/users`) - Gestión de usuarios
2. **Rankings** (`/api/v1/ranks`) - Sistema de puntos y rankings
3. **Asistencias** (`/api/v1/assitances`) - Invocación de modelo de IA (Claude 3.5 Sonnet)

**Base URL**: `/api/v1`  
**Formato**: JSON  
**Autenticación**: Actualmente no requerida (pero se usará Auth0 para obtener userId)

---

## 🔐 Integración con Auth0

### Obtención del UserId

El `userId` se obtendrá de **Auth0** desde el objeto `Credentials`:

```dart
// En AuthService, el userId está en:
_auth0.credentials?.user.sub  // o
_auth0.credentials?.user.id   // ID único de Auth0
```

**Nota importante**: El backend espera un `userId` (GUID del sistema), pero Auth0 proporciona un `sub` (subject identifier). Necesitaremos:

1. **Opción A**: Usar el `sub` de Auth0 directamente como `userId` en el backend
2. **Opción B**: Crear un usuario en el backend con el email de Auth0 y usar el `id` generado

---

## 📊 Estructura de Respuesta

Todos los endpoints devuelven `BaseResponse<T>`:

```dart
class BaseResponse<T> {
  final T? data;
  final String message;
  final bool success;
}
```

**Mapeo JSON**:
```json
{
  "data": T,           // Puede ser null en errores
  "message": "string", // Mensaje de error o info
  "success": boolean   // true = éxito, false = error
}
```

---

## 1️⃣ Endpoints de Usuarios (`/api/v1/users`)

### 1.1. POST `/api/v1/users` - Crear Usuario

**Propósito**: Registrar un nuevo usuario en el sistema backend.

**Request Body**:
```dart
{
  "username": "string",  // Requerido
  "email": "string",      // Requerido, formato válido
  "dni": "string"         // Requerido, exactamente 7 caracteres
}
```

**Validaciones**:
- Email: formato válido
- DNI: exactamente 7 caracteres

**Respuesta Exitosa (201)**:
```dart
{
  "data": {
    "id": "string",        // GUID generado
    "username": "string",
    "email": "string",
    "dni": "string",
    "createdAt": "datetime", // UTC
    "updatedAt": null,
    "isDeleted": false
  },
  "message": "",
  "success": true
}
```

**Errores**:
- `400 Bad Request`: "User already exists" u otros errores de validación

**Uso con Auth0**:
- El `email` viene de `credentials.user.email`
- El `username` puede venir de `credentials.user.name` o `nickname`
- El `dni` debe ser capturado en el onboarding

---

### 1.2. GET `/api/v1/users/{email}` - Obtener Usuario

**Propósito**: Buscar usuario existente por email.

**Parámetros**:
- `email` (path): Email del usuario

**Respuesta Exitosa (200)**:
```dart
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

**Errores**:
- `200 OK` con `success: false` si no existe

**Uso con Auth0**:
- Usar `credentials.user.email` para buscar el usuario

---

## 2️⃣ Endpoints de Rankings (`/api/v1/ranks`)

### 2.1. POST `/api/v1/ranks` - Crear Ranking

**Propósito**: Inicializar ranking para un usuario (0 puntos).

**Request Body**:
```dart
{
  "userId": "string"  // ID del usuario (debe existir)
}
```

**Validaciones**:
- El usuario debe existir
- No puede tener ranking duplicado

**Respuesta Exitosa (201)**:
```dart
{
  "data": {
    "id": "string",        // GUID del ranking
    "userId": "string",
    "points": 0,           // Inicializado en 0
    "createdAt": "datetime",
    "updatedAt": null,
    "isDeleted": false
  },
  "message": "",
  "success": true
}
```

**Errores**:
- `400`: "Rank already exists for this user"
- `400`: "User does not exist"

**Uso con Auth0**:
- `userId` será el `id` del usuario obtenido del backend (no el `sub` de Auth0)

---

### 2.2. PUT `/api/v1/ranks` - Actualizar Ranking

**Propósito**: Incrementar/decrementar puntos de un ranking.

**Request Body**:
```dart
{
  "rankId": "string",  // ID del ranking
  "quantity": 0        // Positivo = sumar, negativo = restar
}
```

**Respuesta Exitosa (200)**:
```dart
{
  "data": {
    "id": "string",
    "userId": "string",
    "points": 0,           // Puntos actualizados
    "createdAt": "datetime",
    "updatedAt": "datetime",
    "isDeleted": false
  },
  "message": "",
  "success": true
}
```

**Errores**:
- `400`: "Rank not found"

**Casos de Uso**:
- Sumar puntos al completar tareas
- Restar puntos por penalizaciones
- Actualizar puntos en tiempo real

---

### 2.3. GET `/api/v1/ranks?count={count}` - Top Rankings

**Propósito**: Obtener los rankings más altos.

**Query Parameters**:
- `count` (int, requerido): Número de resultados

**Respuesta Exitosa (200)**:
```dart
{
  "data": [
    {"userId1": 150},  // Diccionario: userId -> points
    {"userId2": 120},
    {"userId3": 100}
  ],
  "message": "",
  "success": true
}
```

**Nota**: Estructura inusual - array de diccionarios con un solo par clave-valor cada uno.

**Uso**:
- Leaderboard/Tabla de clasificación
- Mostrar top N usuarios

---

### 2.4. GET `/api/v1/ranks/{userId}` - Ranking por Usuario

**Propósito**: Obtener ranking específico de un usuario.

**Parámetros**:
- `userId` (path): ID del usuario

**Respuesta Exitosa (200)**:
```dart
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

**Errores**:
- `200 OK` con `success: false`: "Rank for UserId: {userId} not found."

**Uso con Auth0**:
- Obtener puntos del usuario actual
- Mostrar progreso personal

---

## 3️⃣ Endpoints de Asistencias (`/api/v1/assitances`)

### 3.1. POST `/api/v1/assitances/invoke` - Invocar IA

**Propósito**: Procesar prompt con Claude 3.5 Sonnet (AWS Bedrock).

**Modelo**: `anthropic.claude-3-5-sonnet-20240620-v1:0`

**Request Body**:
```dart
{
  "prompt": "string"  // Requerido, no vacío
}
```

**Respuesta Exitosa (200)**:
```dart
{
  "data": "string",   // Respuesta del modelo de IA
  "message": "",
  "success": true
}
```

**Errores**:
- `400`: "ModelId and InputText are required."
- `500`: Errores internos del servidor

**Casos de Uso**:
- Procesar transcripciones de voz
- Generar respuestas inteligentes
- Análisis de texto del usuario

---

## 🔄 Flujo de Integración con Auth0

### Flujo Completo Recomendado:

```
1. Usuario inicia sesión con Auth0
   ↓
2. Obtener datos de Auth0:
   - email: credentials.user.email
   - name: credentials.user.name
   - sub: credentials.user.sub (ID de Auth0)
   ↓
3. Verificar si usuario existe en backend:
   GET /api/v1/users/{email}
   ↓
4a. Si NO existe → Crear usuario:
    POST /api/v1/users
    {
      "username": name,
      "email": email,
      "dni": "1234567" // Capturado en onboarding
    }
   ↓
4b. Si existe → Usar el id del usuario
   ↓
5. Verificar si tiene ranking:
   GET /api/v1/ranks/{userId}
   ↓
6a. Si NO tiene ranking → Crear:
    POST /api/v1/ranks
    {
      "userId": userId
    }
   ↓
6b. Si tiene → Usar el rankId existente
   ↓
7. Usuario puede usar la app normalmente
```

---

## 📦 Modelos de Datos Necesarios

### User Model
```dart
class User {
  final String id;           // GUID del backend
  final String username;
  final String email;
  final String dni;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;
}
```

### Rank Model
```dart
class Rank {
  final String id;           // GUID del ranking
  final String userId;       // ID del usuario
  final int points;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;
}
```

### TopRank Model
```dart
class TopRank {
  final String userId;
  final int points;
}
```

### BaseResponse Model
```dart
class BaseResponse<T> {
  final T? data;
  final String message;
  final bool success;
}
```

---

## 🛠️ Servicios a Crear

### 1. UserService
```dart
class UserService {
  Future<BaseResponse<User>> createUser({
    required String username,
    required String email,
    required String dni,
  });
  
  Future<BaseResponse<User>> getUserByEmail(String email);
}
```

### 2. RankService
```dart
class RankService {
  Future<BaseResponse<Rank>> createRank(String userId);
  Future<BaseResponse<Rank>> updateRank({
    required String rankId,
    required int quantity,
  });
  Future<BaseResponse<List<TopRank>>> getTopRanks(int count);
  Future<BaseResponse<Rank>> getRankByUserId(String userId);
}
```

### 3. AssistanceService
```dart
class AssistanceService {
  Future<BaseResponse<String>> invokeAI(String prompt);
}
```

---

## ⚠️ Consideraciones Importantes

### 1. Mapeo Auth0 → Backend

**Problema**: Auth0 usa `sub` (ej: `auth0|123456`), backend usa GUIDs.

**Solución**:
- Usar el `email` como identificador común
- Al crear usuario, el backend genera un GUID único
- Guardar el mapeo: `auth0Sub -> backendUserId` en StorageService

### 2. Sincronización de Usuario

**Estrategia**:
- Al iniciar sesión, verificar si existe usuario en backend
- Si no existe, crearlo automáticamente
- Si existe, usar el `id` del backend para todas las operaciones

### 3. Manejo de Errores

**Errores Comunes**:
- `400 Bad Request`: Validación fallida
- `200 OK con success: false`: Recurso no encontrado
- `500 Internal Server Error`: Error del servidor

**Estrategia**:
- Siempre verificar `success` antes de usar `data`
- Mostrar `message` al usuario en caso de error
- Implementar retry logic para errores transitorios

### 4. Top Rankings - Estructura Inusual

**Problema**: La respuesta es un array de diccionarios con un solo par clave-valor.

**Solución**:
```dart
// Parsear respuesta
final List<Map<String, dynamic>> rawData = response.data;
final List<TopRank> topRanks = rawData.map((item) {
  final entry = item.entries.first;
  return TopRank(
    userId: entry.key,
    points: entry.value as int,
  );
}).toList();
```

### 5. Fechas UTC

**Nota**: Todas las fechas vienen en formato UTC. Convertir a local si es necesario.

---

## 🔗 Endpoints Resumen

| Método | Endpoint | Propósito | Auth0 Required |
|--------|----------|-----------|----------------|
| POST | `/api/v1/users` | Crear usuario | Email, Name |
| GET | `/api/v1/users/{email}` | Obtener usuario | Email |
| POST | `/api/v1/ranks` | Crear ranking | UserId |
| PUT | `/api/v1/ranks` | Actualizar puntos | RankId |
| GET | `/api/v1/ranks?count={n}` | Top rankings | No |
| GET | `/api/v1/ranks/{userId}` | Ranking usuario | UserId |
| POST | `/api/v1/assitances/invoke` | Invocar IA | No |

---

## 📝 Próximos Pasos

1. **Crear servicios de API**:
   - `UserService`
   - `RankService`
   - `AssistanceService`

2. **Integrar con AuthService**:
   - Obtener email/name de Auth0
   - Sincronizar usuario con backend
   - Guardar userId del backend

3. **Actualizar StorageService**:
   - Agregar `backendUserId`
   - Agregar `rankId`

4. **Implementar lógica de sincronización**:
   - Verificar usuario al login
   - Crear usuario si no existe
   - Crear ranking si no existe

5. **Integrar con features existentes**:
   - Usar `AssistanceService` en voice agent
   - Actualizar puntos en rankings
   - Mostrar leaderboard

---

## 🎯 Puntos Clave

✅ **UserId**: Se obtiene del backend después de crear/buscar usuario  
✅ **Email**: Se usa como identificador común entre Auth0 y backend  
✅ **RankId**: Se obtiene después de crear/buscar ranking  
✅ **BaseResponse**: Todos los endpoints usan esta estructura  
✅ **Errores**: Siempre verificar `success` antes de usar `data`  
✅ **Top Rankings**: Estructura inusual, requiere parsing especial  

