# BancaMovil - Proyecto de Banca Móvil

Este es un proyecto de banca móvil desarrollado con una arquitectura basada en microservicios, utilizando **Spring Boot** para el backend con PostgreSQL, **Flask** con MongoDB y **Flutter** para el frontend.

## Estructura del Proyecto

```
BANCAMOVIL_PRUEBA/
│── backend/
│   ├── backend-flask/         # Backend en Flask con MongoDB
│   ├── backend-springboot/    # Backend en Spring Boot con PostgreSQL
│   ├── docker-compose.yml     # Configuración de contenedores para Docker
│── frontend/                  # Aplicación móvil desarrollada en Flutter
│── menu_contextual/           # Código de funciones adicionales
│── README.md                  # Documentación del proyecto
```

## Instalación y Configuración

### Backend

1. **Clonar el repositorio**:

   ```sh
   git clone https://github.com/tuusuario/bancamovil.git
   cd bancamovil/backend
   ```

2. **Levantar los servicios con Docker**:

   ```sh
   docker-compose up --build
   ```

3. **Acceder a los servicios**:
   - Spring Boot (Java) corriendo en: `http://localhost:8080`
   - Flask (Python) corriendo en: `http://localhost:5000`

### Frontend

1. **Ir al directorio del frontend**:

   ```sh
   cd frontend
   ```

2. **Instalar dependencias y ejecutar la app**:

   ```sh
   flutter pub get
   flutter run
   ```

## API Endpoints

### Usuarios (`/api/users`)
- **POST** `/register` → Registrar usuario
- **POST** `/login` → Iniciar sesión
- **GET** `/{userId}` → Obtener datos del usuario
- **PUT** `/{userId}` → Actualizar usuario
- **DELETE** `/{userId}` → Eliminar usuario

### Tarjetas (`/api/cards`)
- **POST** `/` → Agregar tarjeta
- **PUT** `/{cardId}/freeze` → Congelar/Descongelar tarjeta
- **DELETE** `/{cardId}` → Eliminar tarjeta

## Contribución

1. Realiza un **fork** del repositorio.
2. Crea una nueva rama (`git checkout -b feature-nueva-funcionalidad`).
3. Realiza los cambios y haz un commit (`git commit -m "Añadida nueva funcionalidad"`).
4. Sube los cambios (`git push origin feature-nueva-funcionalidad`).
5. Crea un **Pull Request**.

## Contacto

- 📧 Email: contacto@tubanca.com
- 📌 Desarrollado por [Tu Nombre](https://github.com/tuusuario)
