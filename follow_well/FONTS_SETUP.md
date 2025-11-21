# Configuración de Fuentes - Plus Jakarta Sans

## Descargar las fuentes

1. Visita [Google Fonts - Plus Jakarta Sans](https://fonts.google.com/specimen/Plus+Jakarta+Sans)
2. Descarga los siguientes pesos:
   - **Regular** (400) - Para textos largos
   - **Medium** (500) - Para captions
   - **SemiBold** (600) - Para títulos, subtítulos y botones
   - **Bold** (700) - Para headers grandes y números importantes

## Instalación

1. Crea la carpeta `fonts` en la raíz del proyecto:
   ```
   follow_well/fonts/
   ```

2. Coloca los archivos `.ttf` descargados en la carpeta `fonts`:
   ```
   fonts/
     PlusJakartaSans-Regular.ttf
     PlusJakartaSans-Medium.ttf
     PlusJakartaSans-SemiBold.ttf
     PlusJakartaSans-Bold.ttf
   ```

3. Actualiza `pubspec.yaml` agregando la sección de fuentes:

```yaml
flutter:
  # ... otras configuraciones ...
  
  fonts:
    - family: Plus Jakarta Sans
      fonts:
        - asset: fonts/PlusJakartaSans-Regular.ttf
          weight: 400
        - asset: fonts/PlusJakartaSans-Medium.ttf
          weight: 500
        - asset: fonts/PlusJakartaSans-SemiBold.ttf
          weight: 600
        - asset: fonts/PlusJakartaSans-Bold.ttf
          weight: 700
```

4. Ejecuta:
   ```bash
   flutter pub get
   ```

5. Reinicia la aplicación para que los cambios surtan efecto.

## Uso de la tipografía

La tipografía ya está configurada en `lib/core/ui/theme/typography.dart`:

- **Títulos/Headers**: SemiBold (w600) o Bold (w700)
- **Body/Textos largos**: Regular (w400)
- **Botones**: SemiBold (w600)
- **Números (ETAs, presión, glucosa)**: Bold (w700) o SemiBold (w600)

