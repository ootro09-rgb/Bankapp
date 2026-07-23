# Compilación sin firma en Codemagic

Este flujo omite por completo certificados y perfiles de aprovisionamiento.

Produce:
- `BlunarKBank.app` sin firmar.
- `BlunarKBank-unsigned.app.zip`.
- El registro de `xcodebuild`.

No produce una IPA instalable. Apple exige firma y un perfil válido para instalar la aplicación en un iPhone. Este flujo sirve para verificar que el proyecto compila correctamente en Codemagic antes de configurar la cuenta de desarrollador.
