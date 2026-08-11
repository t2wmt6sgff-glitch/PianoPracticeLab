# AGENTS.md

## Proyecto

PianoPracticeLab es una aplicación iPadOS en SwiftUI, completamente en español.

La V1 se centra exclusivamente en **Ritmo de estudio**. Consulta `PROJECT.md` antes de implementar cualquier funcionalidad.

## Estado actual

**Importante:** el repositorio todavía no contiene un proyecto Xcode.

La creación inicial del proyecto se realizará posteriormente desde **Xcode 16.2** en un **MacBook Air 2019 con macOS Sonoma**.

No se debe:

- crear manualmente un `.xcodeproj` desde Windows;
- editar manualmente `project.pbxproj` para sustituir la creación inicial desde Xcode;
- asumir que Xcode está disponible en el entorno actual;
- marcar la aplicación como compilada o validada sin una prueba real en el entorno Apple correspondiente.

## Forma de trabajar

Antes de modificar archivos:

1. Leer `PROJECT.md`.
2. Identificar la funcionalidad concreta solicitada.
3. Comprobar sus criterios de aceptación.
4. Mantener el cambio limitado al alcance de la tarea.
5. No inventar decisiones que `PROJECT.md` marque como pendientes.

## Alcance V1

La V1 incluye:

- configuración de días de estudio;
- hora preferida de recordatorio;
- duración mínima de práctica;
- pantalla Hoy;
- registro de prácticas;
- calendario;
- estados Practicado, Pendiente, Descanso planificado, No practicado y Justificado;
- justificación de ausencias;
- aviso de recuperación tras dos ausencias no justificadas consecutivas;
- recordatorios configurables;
- persistencia local.

La V1 no incluye:

- obras;
- repertorio;
- partituras;
- PDF;
- notas de profesora;
- Apple Pencil;
- IA;
- Foundation Models;
- APIs externas de IA;
- iCloud;
- cuentas;
- sincronización;
- algoritmos complejos;
- gamificación agresiva.

## Principios de UX

La aplicación debe ayudar a mantener un ritmo de estudio sin generar culpa.

No introducir:

- castigos;
- lenguaje culpabilizador;
- rachas agresivas;
- penalizaciones por descanso planificado;
- penalizaciones por ausencia justificada.

Los descansos planificados no son fallos.

## Arquitectura

Mantener una arquitectura SwiftUI sencilla y separada por responsabilidades.

Como mínimo, distinguir entre:

- vistas/UI;
- modelos;
- estado y lógica de presentación;
- persistencia local;
- notificaciones.

No introducir complejidad arquitectónica innecesaria para V1.

La arquitectura debe permitir crecimiento futuro, pero no implementar ahora las funcionalidades futuras.

## Validación

Una funcionalidad no debe considerarse terminada únicamente porque el agente haya escrito el código.

Cuando exista un proyecto Xcode:

1. Compilar en Xcode.
2. Probar en Simulator.
3. Probar en iPad físico cuando corresponda.
4. Verificar los criterios de aceptación de `PROJECT.md`.

Antes de disponer de Xcode, las comprobaciones deben limitarse a lo que pueda verificarse realmente en el entorno disponible. No afirmar que una app iOS funciona en dispositivo si no se ha ejecutado en un entorno Apple.

## Cambios de especificación

Si una tarea requiere una decisión que no está aprobada:

- no asumirla;
- dejarla claramente identificada;
- explicar por qué es necesaria;
- evitar implementar una solución irreversible si puede esperar.

Toda nueva decisión relevante debe clasificarse en `PROJECT.md` como:

- decisión aprobada;
- decisión provisional;
- pendiente;
- problema detectado;
- funcionalidad terminada.

## Regla fundamental

**No construir por construir.**

Cada cambio debe responder a una funcionalidad o requisito explícito del proyecto y debe poder verificarse posteriormente.
