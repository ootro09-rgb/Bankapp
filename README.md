# BlunarKBank iOS

Proyecto SwiftUI preparado para generar con XcodeGen y compilar en Codemagic.

## Funciones incluidas
- Escaneo automático de QR mediante AVFoundation.
- Reconocimiento automático del número impreso mediante Vision OCR.
- Extracción exclusiva de tarjetas de 16 dígitos; prioriza números cubanos que comienzan por `92`.
- Copia automática al portapapeles y confirmación háptica.
- Selección de tarjeta antes de una transferencia.
- Selector real de Contactos antes de recargar un móvil.
- Acciones USSD bancarias y de Cubacel.
- Prueba inicial de 7 días y pantalla bloqueante de suscripción.
- Planes consultados desde `https://tu-servidor.com/api/subscription/plans`.

## Antes de producción
1. Cambia `com.blunark.bank` por tu Bundle ID definitivo.
2. Cambia la URL de API en `Services/AppStore.swift`.
3. Sustituye `activateDemo` por un checkout y validación firmada desde el servidor.
4. Guarda tarjetas en Keychain, no en UserDefaults.
5. Configura firma iOS en Codemagic.
6. Comprueba cada USSD con BANMET, BPA, BANDEC y una línea Cubacel real.
7. Añade política de privacidad, términos y canal de soporte.

## Codemagic
Sube esta carpeta a GitHub, conecta el repositorio en Codemagic y ejecuta el workflow `BlunarKBank iOS`.
