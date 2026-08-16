# PianoPracticeLab — Especificación del proyecto

## 1. Visión

PianoPracticeLab es una aplicación para iPadOS, desarrollada con SwiftUI y completamente en español, cuyo propósito es ayudar al usuario a mantener el compromiso de estudiar piano.

La primera versión no intenta gestionar todo el estudio musical. Se centra en una única idea:

> **Ritmo de estudio**

La aplicación debe ayudar a mantener una práctica regular sin utilizar culpa, castigos ni mecanismos agresivos de rachas.

---

## 2. Estado del proyecto

### Decisiones aprobadas

**Tecnologías y plataforma:**
- Plataforma inicial: **iPadOS**.
- Requisito mínimo: **iPadOS 17+**.
- Interfaz: **SwiftUI** (tecnología principal).
- Idioma de la aplicación: **español**.
- APIs nativas de Apple preferentemente, evitando dependencias externas.
- Persistencia local: **SwiftData** (aprobado para la V1).
- Gestión de estado: **Observation / @Observable** (aprobado, a utilizar únicamente cuando exista una necesidad real).
- Arquitectura incremental: crecer según necesidades reales, sin sobrearquitectura.
- **MVVM ligero y bajo demanda**: no se crean ViewModels por defecto; solo cuando una vista tenga lógica de presentación que lo justifique.
- No crear carpetas `Views/`, `ViewModels/` ni `Services/` hasta que exista una necesidad real.
- Mantener inicialmente una estructura plana.
- Utilizar inicialmente un único archivo `Models.swift` para los modelos de la V1, mientras el tamaño sea razonable.
- Separar los modelos en archivos independientes posteriormente solo si el archivo crece demasiado o mejora claramente la mantenibilidad.

**Entorno de desarrollo:**
- Desarrollo inicial en **Swift Playground sobre iPad Pro M5**.
- Futura transición a **Xcode en MacBook Air 2019** (pendiente de comprobación de compatibilidad concreta).
- GitHub como repositorio y fuente de control de versiones.

**Producto:**
- V1 centrada exclusivamente en **Ritmo de estudio**.
- Datos almacenados localmente.
- La pantalla principal se llama **Hoy**.
- El usuario puede configurar:
  - días de estudio;
  - hora preferida del recordatorio;
  - duración mínima de práctica.
- El usuario puede registrar una práctica con:
  - fecha;
  - duración;
  - nota opcional.
- Una práctica marca el día como **Practicado**.
- El calendario utiliza los estados:
  - Practicado;
  - Pendiente;
  - Descanso planificado;
  - No practicado;
  - Justificado.
- El usuario puede justificar una ausencia con una nota opcional.
- Tras dos días de estudio previstos sin práctica ni justificación, se muestra un aviso de recuperación.
- Los recordatorios son configurables y se pueden desactivar.
- No se utilizarán culpa, castigos ni rachas agresivas.
- Los descansos planificados no cuentan como fallos.
- Debe funcionar correctamente en iPad en orientación horizontal y vertical.

### Decisiones provisionales

- Diseño visual detallado: pendiente.
- Implementación exacta de recordatorios: pendiente.

### Pendiente

- Implementar los modelos de datos de la V1.
- Configurar SwiftData en el punto de entrada de la aplicación.
- Definir el modelo de datos final dentro de la implementación.
- Definir la navegación y composición visual definitiva.
- Definir el comportamiento exacto de las notificaciones.
- Validar compatibilidad real con el MacBook Air 2019 y el iPad objetivo.

### Problemas detectados

- La transición futura a Xcode en el MacBook Air 2019 debe comprobarse antes de esa fase, siguiendo la cadena: macOS instalado → versión de Xcode disponible → SDK → versión de Swift → deployment target. No se debe asumir compatibilidad sin restricciones ni inventar versiones concretas de Xcode sin comprobación.

### Funcionalidades terminadas

**Proyecto base: TERMINADO**

- Proyecto base creado en **Swift Playground sobre iPad Pro M5**.
- Proyecto base probado correctamente.
- Hello World funcionando.
- Logo de Piano Practice Lab incorporado.
- Repositorio GitHub creado.
- Documentación inicial preparada.

**Nota:** SwiftData y Observation están **aprobados arquitectónicamente**, pero todavía **NO han sido implementados**.

---

## 3. Objetivo funcional de la V1

La V1 debe permitir que el usuario establezca un ritmo de estudio y registre si ha cumplido con él.

El flujo básico es:

1. Configurar los días de estudio.
2. Configurar una hora de recordatorio.
3. Definir la duración mínima que cuenta como práctica.
4. Consultar la pantalla **Hoy**.
5. Registrar una práctica.
6. Consultar el calendario.
7. Justificar una ausencia cuando corresponda.
8. Recibir un aviso de recuperación cuando se acumulen dos días previstos sin práctica ni justificación.

---

## 4. Pantallas y navegación

### Hoy

Pantalla principal.

Debe mostrar de forma clara:

- si hoy hay práctica prevista;
- el estado actual del día;
- acceso para registrar una práctica;
- información relevante sobre el ritmo de estudio;
- acceso a configuración y calendario.

### Registro de práctica

Permite registrar:

- fecha;
- duración;
- nota opcional.

La duración debe poder compararse con la duración mínima configurada.

### Calendario

Muestra los días y su estado:

- Practicado
- Pendiente
- Descanso planificado
- No practicado
- Justificado

Debe permitir consultar el estado de días anteriores y acceder a la justificación cuando exista.

### Justificar ausencia

Permite marcar una ausencia como justificada y añadir una nota opcional.

Una ausencia justificada no debe generar el aviso de recuperación correspondiente a una ausencia no justificada.

### Configuración

Permite configurar:

- días de estudio;
- hora preferida del recordatorio;
- duración mínima de práctica;
- activación/desactivación de recordatorios.

---

## 5. Modelo de datos mínimo

El modelo debe ser deliberadamente pequeño en V1.

### StudySchedule

Representa la configuración del ritmo de estudio.

Campos conceptuales:

- días de la semana previstos;
- hora preferida del recordatorio;
- duración mínima de práctica;
- recordatorios activados/desactivados.

### PracticeSession

Representa una práctica registrada.

Campos:

- fecha;
- duración;
- nota opcional.

### DayJustification

Representa una ausencia justificada.

Campos:

- fecha;
- nota opcional.

No introducir en V1 entidades para obras, repertorio, partituras, profesores, usuarios, IA, etc.

---

## 6. Estados del calendario

### Practicado

El día tenía práctica prevista y existe una práctica registrada que cumple la duración mínima configurada.

### Pendiente

El día de estudio previsto todavía no tiene una práctica registrada ni una justificación aplicable.

### Descanso planificado

El día no está configurado como día de estudio.

No cuenta como fallo.

### No practicado

El día tenía práctica prevista y terminó sin práctica ni justificación.

### Justificado

El día tenía práctica prevista, no se registró una práctica válida y el usuario marcó la ausencia como justificada.

---

## 7. Regla de recuperación

La regla debe ser simple y explicable.

Un día de estudio previsto se considera **ausencia no justificada** cuando:

- está configurado como día de estudio;
- ha terminado el día;
- no existe una práctica válida;
- no existe una justificación.

Cuando existan **dos días de estudio previstos consecutivos en el historial que hayan terminado como ausencia no justificada**, la aplicación muestra un aviso de recuperación.

El aviso debe ser informativo y orientado a retomar el ritmo. No debe utilizar lenguaje de culpa, castigo ni pérdida de racha.

Los descansos planificados y las ausencias justificadas no incrementan el contador de ausencias.

---

## 8. Arquitectura SwiftUI

### Principios aprobados

- **SwiftUI** como tecnología principal de interfaz.
- **SwiftData** como tecnología de persistencia local para la V1.
- **Observation / @Observable** para gestión de estado, únicamente cuando sea necesario.
- **MVVM ligero y bajo demanda**: sin ViewModels obligatorios.
- **Arquitectura incremental**: crecer según las necesidades reales del proyecto.
- No crear abstracciones, protocolos, servicios, ViewModels o carpetas simplemente "por si algún día hacen falta".

### Estructura inicial prevista

La estructura inicial es deliberadamente plana y mínima:

```
SwiftPlayground/
├── MyApp.swift
├── ContentView.swift
└── Models.swift
```

**Nota importante:** `Models.swift` todavía NO debe crearse en la fase de actualización documental. Se creará únicamente cuando se apruebe explícitamente el inicio de la Fase 2 (implementación de modelos).

Cuando el código crezca y exista una razón real para separar responsabilidades, se podrá dividir. No crear carpetas `Views/`, `ViewModels/`, `Services/`, `Repositories/` ni `Protocols/` prematuramente.

### Preparación para el futuro

La arquitectura debe permitir añadir posteriormente funcionalidades como:

- obras;
- PDF;
- notas de profesora;
- Apple Pencil;
- recomendaciones;
- IA.

Pero esas funcionalidades no deben implementarse en V1.

---

## 9. Entorno de desarrollo

### Estado actual

El proyecto base fue creado directamente en **Swift Playground sobre iPad Pro M5** y funciona correctamente.

**No se creó en Xcode.** La referencia histórica a la creación en Xcode ha sido eliminada porque ya no refleja la realidad del proyecto.

### Formato del proyecto

El proyecto actual es un **App Project de Swift Playground** basado en **Swift Package Manager**.

El archivo `.swiftpm` no debe tratarse como una carpeta normal de Archivos de iPadOS. El flujo actual se basa en GitHub y en archivos individuales cuando sea necesario.

No es necesario modificar esta estructura ni intentar convertir el proyecto a Xcode en esta fase.

### Repositorio GitHub

GitHub se utiliza como pieza central para:

- control de versiones;
- sincronización;
- acceso del agente al código;
- futura transición entre dispositivos.

El nombre correcto del directorio es **SwiftPlayground/** (no SwiftPlaygrounds/).

### Futura transición a Xcode

Posteriormente el proyecto podrá continuar en Xcode en el MacBook Air 2019.

La compatibilidad debe comprobarse siguiendo esta cadena:

**macOS instalado → versión de Xcode disponible → SDK → versión de Swift → deployment target**

El MacBook Air 2019 tiene restricciones respecto a las versiones máximas de macOS y, por tanto, de Xcode que puede utilizar. No se debe asumir compatibilidad sin restricciones ni inventar versiones concretas de Xcode sin comprobación.

La arquitectura actual basada en SwiftUI, SwiftData y Observation debe mantenerse razonablemente compatible con el entorno que realmente podremos utilizar.

---

## 10. Compatibilidad

El desarrollo inicial está condicionado por:

- iPad Pro M5 (entorno actual de desarrollo);
- iPadOS 17+ como requisito mínimo;
- Swift Playground como entorno de creación.

La futura transición dependerá de:

- MacBook Air 2019;
- macOS (versión máxima soportada por el hardware);
- Xcode (versión compatible con ese macOS);
- SDK y versión de Swift correspondientes;
- deployment target compatible.

Antes de adoptar APIs nuevas, debe comprobarse que sean compatibles con la versión de Xcode y el deployment target realmente disponibles.

No asumir compatibilidad simplemente porque una API exista en documentación más reciente.

---

## 11. Fuera de alcance de V1

No implementar:

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
- cuentas de usuario;
- sincronización entre dispositivos;
- algoritmos complejos;
- funcionalidades sociales;
- gamificación agresiva;
- sistemas de castigo o culpa;
- Bluetooth;
- MIDI;
- Internet;
- servidores;
- APIs externas;
- paquetes de terceros;
- permisos innecesarios.

Estas ideas pueden formar parte de versiones futuras, pero no deben ampliar el alcance de V1.

---

## 12. Criterios de aceptación

La V1 se considerará funcional cuando:

01. El usuario pueda configurar sus días de estudio.
02. El usuario pueda configurar una hora de recordatorio.
03. El usuario pueda definir la duración mínima de práctica.
04. La pantalla Hoy muestre correctamente si existe práctica prevista.
05. El usuario pueda registrar una práctica.
06. Una práctica válida marque el día como Practicado.
07. Una práctica inferior a la duración mínima no se considere automáticamente práctica válida.
08. El calendario represente correctamente los cinco estados definidos.
09. El usuario pueda justificar una ausencia.
10. Una ausencia justificada no cuente como ausencia no justificada.
11. Un descanso planificado no cuente como fallo.
12. Dos ausencias no justificadas consecutivas generen el aviso de recuperación.
13. El aviso de recuperación no utilice lenguaje de culpa o castigo.
14. Los recordatorios puedan activarse y desactivarse.
15. Los datos sobrevivan al cierre y reapertura de la aplicación.
16. La interfaz sea usable tanto en orientación vertical como horizontal.
17. No existan dependencias de IA, cuentas o iCloud.
18. La aplicación pueda compilarse y ejecutarse correctamente en el entorno definido para el proyecto.

---

## 13. Orden de implementación posterior

No comenzar estas tareas hasta aprobar explícitamente cada fase.

### Fase 1 — Modelos y persistencia (PENDIENTE DE APROBACIÓN)

1. Crear `Models.swift` con los tres modelos iniciales de la V1.
2. Configurar SwiftData en `MyApp.swift`.
3. Verificar que la aplicación compila y funciona correctamente.

### Fase 2 — Configuración

4. Implementar selección de días.
5. Implementar duración mínima.
6. Implementar hora de recordatorio.
7. Implementar activación/desactivación de recordatorios.

### Fase 3 — Registro

8. Crear pantalla de registro.
9. Validar duración.
10. Guardar prácticas.
11. Mostrar el estado Practicado.

### Fase 4 — Calendario

12. Crear calendario.
13. Implementar los cinco estados.
14. Implementar justificaciones.
15. Validar las transiciones de estados.

### Fase 5 — Regla de recuperación

16. Implementar detección de dos ausencias consecutivas.
17. Crear aviso de recuperación.
18. Comprobar que descansos y justificaciones no generen falsos avisos.

### Fase 6 — Hoy

19. Construir la pantalla Hoy.
20. Integrar estado diario.
21. Integrar acceso al registro.
22. Integrar información de recuperación.

### Fase 7 — Validación

23. Probar orientación vertical.
24. Probar orientación horizontal.
25. Probar persistencia.
26. Probar recordatorios.
27. Probar estados del calendario.
28. Probar recuperación.
29. Corregir problemas encontrados.

---

## 14. Regla para agentes

Los agentes de programación deben tratar este documento como especificación de V1.

Antes de implementar una funcionalidad:

01. Identificar qué parte de la especificación afecta.
02. No ampliar el alcance por iniciativa propia.
03. No implementar funcionalidades fuera de alcance.
04. No inventar decisiones que estén marcadas como pendientes.
05. Mantener los cambios pequeños y verificables.
06. Añadir pruebas cuando sea razonable.
07. Explicar cualquier incompatibilidad encontrada.
08. No modificar la configuración del proyecto a ciegas.
09. No considerar una funcionalidad terminada hasta que pueda validarse según sus criterios de aceptación.

---

## 15. Fuente de verdad

Este documento representa el estado conocido de la especificación del proyecto.

Puede actualizarse cuando se recuperen decisiones posteriores de otros chats.

Toda decisión nueva debe clasificarse como:

- **Decisión aprobada**
- **Decisión provisional**
- **Pendiente**
- **Problema detectado**
- **Funcionalidad terminada**

No sobrescribir silenciosamente una decisión aprobada.