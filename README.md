# PianoPracticeLab

PianoPracticeLab es una aplicación nativa para iPadOS desarrollada con Swift y SwiftUI. Está completamente en español y tiene como objetivo ayudar al usuario a mantener el compromiso de estudiar piano.

## V1

La primera versión se centra exclusivamente en **Ritmo de estudio**:

- Configuración de días de estudio.
- Hora preferida para recordatorios.
- Duración mínima que cuenta como práctica.
- Pantalla principal **Hoy**.
- Registro de prácticas con fecha, duración y nota opcional.
- Calendario con estados de práctica y descanso.
- Justificación de ausencias.
- Aviso de recuperación tras dos días de estudio previstos sin práctica ni justificación.
- Recordatorios configurables y desactivables.
- Almacenamiento local.

La V1 no incluye repertorio, partituras, IA, iCloud, cuentas ni Apple Pencil.

## Estado del proyecto

El proyecto inicial ya ha sido creado y probado correctamente en **Swift Playgrounds para iPad** utilizando un **iPad Pro M5**.

Actualmente contiene:

- Proyecto Swift Package de Swift Playgrounds.
- SwiftUI.
- `ContentView.swift`.
- `MyApp.swift`.
- Recursos de la aplicación, incluido el icono.
- El proyecto compila y se ejecuta correctamente.

La arquitectura definitiva todavía no está aprobada. Antes de implementar funcionalidades, **Qwen** analizará la estructura real del proyecto y propondrá una arquitectura adecuada. La arquitectura será revisada y aprobada antes de comenzar la implementación.

## Flujo de desarrollo

El flujo principal del proyecto es:

1. Crear y mantener el proyecto en Swift Playgrounds.
2. Mantener el código y la documentación en GitHub.
3. Utilizar Qwen como agente principal de análisis e implementación.
4. Revisar y aprobar las propuestas arquitectónicas antes de realizar cambios importantes.
5. Implementar las funcionalidades de forma progresiva.
6. Probar la aplicación en Swift Playgrounds.
7. Continuar posteriormente en Xcode cuando sea necesario.

El proyecto podrá trasladarse posteriormente a **Xcode en un MacBook Air 2019**, por lo que las decisiones técnicas deben mantener la compatibilidad con ese flujo.

## Principios técnicos

- Swift y SwiftUI como tecnologías principales.
- Preferencia por APIs nativas de Apple.
- Arquitectura sencilla, modular y mantenible.
- Sin sobrearquitectura prematura.
- Almacenamiento local inicialmente.
- Sin dependencias externas salvo que sean realmente necesarias.
- No añadir Bluetooth, MIDI, red, servidores, cuentas, sincronización en la nube, Foundation Models o permisos innecesarios sin una necesidad funcional concreta.

## Estado actual

**Proyecto base: TERMINADO**

**Arquitectura: PENDIENTE DE ANÁLISIS Y APROBACIÓN**

**Ritmo de estudio: PENDIENTE DE IMPLEMENTACIÓN**

Consulta [`PROJECT.md`](PROJECT.md) para la especificación y el estado detallado del proyecto.