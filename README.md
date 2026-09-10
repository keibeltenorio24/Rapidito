# Rapidito 🚕📱

Rapidito es una aplicación para transporte de pasajeros (tipo Uber/Yango, etc.), desarrollada con Flutter para los clientes y conductores. Permite el trazado de rutas en tiempo real, cálculo de tarifas dinámicas y selección de roles dinámicos.

## Características Principales
- **Sistema Multi-rol:** Un mismo usuario puede autenticarse y alternar entre los perfiles de `Cliente` y `Conductor` usando la misma cuenta y token JWT(siempre y cuando tenga asignado ambos roles, por defecto se asigna cliente, se tiene previsto implementar que el usuario que desee trabajar como conductor debe hacer una solicitud mediante un formulario).
- **Geolocalización y Trazado de Rutas:** Integración con la API de Google Maps para mostrar ubicaciones en tiempo real, dibujar polilíneas de ruta (origen-destino) y calcular distancia y costo de los viajes.
- **Arquitectura Limpia:** Estructurada usando **Clean Architecture** (Dominio, Datos, Presentación) para asegurar escalabilidad y un código mantenible.
- **Manejo de Estado:** Utilización estricta del patrón **BLoC** (Business Logic Component) a lo largo de toda la aplicación.
- **Firebase Storage:** Almacenamiento optimizado de recursos multimedia en la nube, especialmente para avatares y fotos de perfil, logrando persistencia total.

## Stack Tecnológico 🛠️
- **Frontend:** Flutter y Dart.
- **Backend:** API REST (Django / DRF) con Autenticación JWT.
- **State Management:** `flutter_bloc`
- **Mapas:** `google_maps_flutter`, `geolocator`, `flutter_polyline_points`, `google_places_autocomplete`

## Requerimientos 
- **Flutter SDK:** versión 3.20.0 o superior (o la versión que estés usando).
- **Dart SDK:** versión 3.0.0 o superior. 


## Configuración Local y Ejecución 🚀

Para correr este proyecto en tu entorno local, necesitas configurar el archivo de variables de entorno para proteger las claves de las APIs:

1. Clona este repositorio.
2. Crea un archivo llamado `.env` en la raíz del proyecto.
3. Añade tu clave de Google Maps en el archivo `.env` de la siguiente manera:
   ```env
   GOOGLE_MAPS_API_KEY=tu_clave_secreta_aqui
   ```
4. Ejecuta `flutter pub get` para instalar todas las dependencias.
5. Usa un emulador Android o un dispositivo Android y ejecuta `flutter run`.
