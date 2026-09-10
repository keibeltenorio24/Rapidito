# Rapidito 🚕📱

Rapidito es una plataforma completa de transporte (Ride-Hailing) tipo Uber/Yango, desarrollada con Flutter para los clientes y conductores. Permite el trazado de rutas en tiempo real, cálculo de tarifas dinámicas y selección de roles dinámicos.

## Características Principales
- **Sistema Multi-rol:** Un mismo usuario puede autenticarse y alternar entre los perfiles de `Cliente` y `Conductor` usando la misma cuenta y token JWT.
- **Geolocalización y Trazado de Rutas:** Integración nativa con la API de Google Maps para mostrar ubicaciones precisas, dibujar polilíneas de ruta (origen-destino) y calcular distancia y costo de los viajes.
- **Arquitectura Limpia:** Estructurada usando **Clean Architecture** (Dominio, Datos, Presentación) para asegurar escalabilidad y un código altamente mantenible.
- **Manejo de Estado Avanzado:** Utilización estricta del patrón **BLoC** (Business Logic Component) a lo largo de toda la aplicación.
- **Firebase Storage:** Almacenamiento optimizado de recursos multimedia en la nube, especialmente para avatares y fotos de perfil, logrando persistencia total.

## Stack Tecnológico 🛠️
- **Frontend:** Flutter y Dart.
- **State Management:** `flutter_bloc`
- **Mapas:** `google_maps_flutter`, `geolocator`, `flutter_polyline_points`, `google_places_autocomplete`
- **Backend Requerido:** API REST (Django / DRF) con Autenticación JWT.

## Configuración Local y Ejecución 🚀

Para correr este proyecto en tu entorno local, necesitas configurar el archivo de variables de entorno para proteger las claves de las APIs:

1. Clona este repositorio.
2. Crea un archivo llamado `.env` en la raíz del proyecto.
3. Añade tu clave de Google Maps en el archivo `.env` de la siguiente manera:
   ```env
   GOOGLE_MAPS_API_KEY=tu_clave_secreta_aqui
   ```
4. Ejecuta `flutter pub get` para instalar todas las dependencias (`flutter_dotenv`, `flutter_bloc`, etc.).
5. Conecta un emulador o dispositivo físico y ejecuta `flutter run`.

## Notas sobre Seguridad 🛡️
Por razones de seguridad, el archivo `.env` está ignorado en Git (`.gitignore`). Jamás subas tus claves API públicas a repositorios públicos para evitar problemas de facturación y cuotas excedidas en Google Cloud.
