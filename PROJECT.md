# PianoPracticeLab — Especificación del proyecto

## 1. Visión

PianoPracticeLab es una aplicación para iPadOS, desarrollada con SwiftUI y completamente en español, cuyo propósito es ayudar al usuario a mantener el compromiso de estudiar piano.

La primera versión no intenta gestionar todo el estudio musical. Se centra en una única idea:

> **Ritmo de estudio**

La aplicación debe ayudar a mantener una práctica regular sin utilizar culpa, castigos ni mecanismos agresivos de rachas.

---

## 2. Estado del proyecto

### Decisiones aprobadas

- Plataforma inicial: **iPadOS**.
- Interfaz: **SwiftUI**.
- Idioma de la aplicación: **español**.
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

- Arquitectura SwiftUI concreta: pendiente de confirmar al crear el proyecto.
- Sistema concreto de persistencia local: pendiente de confirmar.
- Diseño visual detallado: pendiente.
- Implementación exacta de recordatorios: pendiente.
- Estrategia concreta para generar/gestionar el proyecto Xcode fuera de Xcode: no se debe decidir ni implementar todavía.

### Pendiente

- Crear el proyecto base desde Xcode 16.2.
- Confirmar la configuración exacta del proyecto en Xcode.
- Definir el modelo de datos final dentro de la implementación.
- Definir la navegación y composición visual definitiva.
- Definir el comportamiento exacto de las notificaciones.
- Validar compatibilidad real con el MacBook Air 2019 y el iPad objetivo.
- Recuperar y consolidar cualquier decisión posterior contenida en otros chats de Work que no esté reflejada aquí.

### Problemas detectados

- El repositorio todavía no contiene `PianoPracticeLab.xcodeproj`.
- La creación inicial del proyecto depende de disponer de Xcode 16.2 en el MacBook Air 2019 con macOS Sonoma.
- No se debe intentar solucionar este problema generando o editando manualmente un `.xcodeproj` desde Windows.
- La V1 todavía no puede considerarse implementada ni validada.

### Funcionalidades terminadas

**Ninguna.**

Todavía no existe código de la aplicación.

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

## 8. Arquitectura SwiftUI recomendada

La arquitectura debe ser sencilla y preparada para crecer.

Separar como mínimo:

- **UI / Views**
- **Modelos**
- **Estado y lógica de presentación**
- **Persistencia local**
- **Notificaciones**

No introducir una arquitectura excesivamente compleja para V1.

La arquitectura debe permitir añadir posteriormente funcionalidades como:

- obras;
- PDF;
- notas de profesora;
- Apple Pencil;
- recomendaciones;
- IA.

Pero esas funcionalidades no deben implementarse en V1.

---

## 9. Configuración inicial de Xcode

Cuando se cree el proyecto desde Xcode 16.2, la configuración exacta deberá confirmarse manualmente.

Como mínimo deberá revisarse:

- plantilla de aplicación iOS/iPadOS;
- interfaz SwiftUI;
- lenguaje Swift;
- identificador del producto;
- equipo de desarrollo/signing;
- deployment target compatible con el entorno disponible;
- orientación y comportamiento adecuados para iPad.

**No inventar valores de configuración que todavía no hayan sido comprobados en el Mac.**

El proyecto debe crearse primero en Xcode y después incorporarse al repositorio.

---

## 10. Compatibilidad

El desarrollo inicial está condicionado por:

- MacBook Air 2019;
- macOS Sonoma;
- Xcode 16.2;
- iPad como dispositivo objetivo.

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
- sistemas de castigo o culpa.

Estas ideas pueden formar parte de versiones futuras, pero no deben ampliar el alcance de V1.

---

## 12. Criterios de aceptación

La V1 se considerará funcional cuando:

1. El usuario pueda configurar sus días de estudio.
2. El usuario pueda configurar una hora de recordatorio.
3. El usuario pueda definir la duración mínima de práctica.
4. La pantalla Hoy muestre correctamente si existe práctica prevista.
5. El usuario pueda registrar una práctica.
6. Una práctica válida marque el día como Practicado.
7. Una práctica inferior a la duración mínima no se considere automáticamente práctica válida.
8. El calendario represente correctamente los cinco estados definidos.
9. El usuario pueda justificar una ausencia.
10. Una ausencia justificada no cuente como ausencia no justificada.
11. Un descanso planificado no cuente como fallo.
12. Dos ausencias no justificadas consecutivas generen el aviso de recuperación.
13. El aviso de recuperación no utilice lenguaje de culpa o castigo.
14. Los recordatorios puedan activarse y desactivarse.
15. Los datos sobrevivan al cierre y reapertura de la aplicación.
16. La interfaz sea usable tanto en orientación vertical como horizontal.
17. No existan dependencias de IA, cuentas o iCloud.
18. La aplicación pueda compilarse y ejecutarse correctamente en el entorno Xcode/iPad definido para el proyecto.

---

## 13. Orden de implementación posterior

No comenzar estas tareas hasta crear correctamente el proyecto base en Xcode.

### Fase 1 — Proyecto

1. Crear proyecto SwiftUI en Xcode.
2. Configurar identificador y signing.
3. Configurar deployment target.
4. Ejecutar la aplicación vacía en Simulator.
5. Ejecutar la aplicación vacía en el iPad.
6. Incorporar el proyecto al repositorio Git.

### Fase 2 — Modelo y persistencia

7. Crear modelos mínimos.
8. Implementar persistencia local.
9. Crear pruebas de persistencia.

### Fase 3 — Configuración

10. Implementar selección de días.
11. Implementar duración mínima.
12. Implementar hora de recordatorio.
13. Implementar activación/desactivación de recordatorios.

### Fase 4 — Registro

14. Crear pantalla de registro.
15. Validar duración.
16. Guardar prácticas.
17. Mostrar el estado Practicado.

### Fase 5 — Calendario

18. Crear calendario.
19. Implementar los cinco estados.
20. Implementar justificaciones.
21. Validar las transiciones de estados.

### Fase 6 — Regla de recuperación

22. Implementar detección de dos ausencias consecutivas.
23. Crear aviso de recuperación.
24. Comprobar que descansos y justificaciones no generen falsos avisos.

### Fase 7 — Hoy

25. Construir la pantalla Hoy.
26. Integrar estado diario.
27. Integrar acceso al registro.
28. Integrar información de recuperación.

### Fase 8 — Validación

29. Probar orientación vertical.
30. Probar orientación horizontal.
31. Probar persistencia.
32. Probar recordatorios.
33. Probar estados del calendario.
34. Probar recuperación.
35. Ejecutar pruebas en Simulator.
36. Ejecutar pruebas en iPad físico.
37. Corregir problemas encontrados.

---

## 14. Regla para agentes

Los agentes de programación deben tratar este documento como especificación de V1.

Antes de implementar una funcionalidad:

1. Identificar qué parte de la especificación afecta.
2. No ampliar el alcance por iniciativa propia.
3. No implementar funcionalidades fuera de alcance.
4. No inventar decisiones que estén marcadas como pendientes.
5. Mantener los cambios pequeños y verificables.
6. Añadir pruebas cuando sea razonable.
7. Explicar cualquier incompatibilidad encontrada.
8. No modificar la configuración de Xcode a ciegas desde Windows.
9. No crear ni editar manualmente un `.xcodeproj` mientras el proyecto todavía no haya sido creado desde Xcode.
10. No considerar una funcionalidad terminada hasta que pueda validarse según sus criterios de aceptación.

---

## 15. Fuente de verdad

Este documento representa el estado conocido de la especificación recuperada de la planificación previa.

Puede actualizarse cuando se recuperen decisiones posteriores de otros chats de Work.

Toda decisión nueva debe clasificarse como:

- **Decisión aprobada**
- **Decisión provisional**
- **Pendiente**
- **Problema detectado**
- **Funcionalidad terminada**

No sobrescribir silenciosamente una decisión aprobada.
