# 🏠 Nido - Tu hogar, en equilibrio

> **Gestión integral de finanzas del hogar, profesional, 100% LOCAL y diseñada exclusivamente para TABLET.**

[![Flutter](https://img.shields.io/badge/Flutter-3.38+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Drift](https://img.shields.io/badge/Database-Drift%20SQLite-00599C)](https://drift.simonbinder.eu)
[![Tests](https://img.shields.io/badge/Tests-39%20Passing-brightgreen)](test/)
[![Arquitectura](https://img.shields.io/badge/Architecture-Feature--First%20Clean-success)](#arquitectura-del-proyecto)
[![Privacidad](https://img.shields.io/badge/Privacidad-100%25%20Local%20%7C%20Zero%20Cloud-2E7D32)](#privacidad-y-restricciones-no-negociables)
[![Formato](https://img.shields.io/badge/Tablet-Master--Detail%20%E2%89%A5840dp-E65100)](#diseño-y-experiencia-tablet)

---

## 📑 Tabla de Contenidos
1. [Identidad del Producto](#identidad-del-producto)
2. [Privacidad y Restricciones No Negociables](#privacidad-y-restricciones-no-negociables)
3. [Reglas de Negocio Clave](#reglas-de-negocio-clave)
4. [Stack Tecnológico](#stack-tecnológico)
5. [Arquitectura del Proyecto](#arquitectura-del-proyecto)
6. [Modelo de Datos (SQLite / Drift)](#modelo-de-datos-sqlite--drift)
7. [Módulos Implementados (Fases 0 a 4)](#módulos-implementados-fases-0-a-4)
8. [Guía de Desarrollo Local y Tests](#guía-de-desarrollo-local-y-tests)
9. [Cómo Ejecutar build_runner](#cómo-ejecutar-build_runner)
10. [Cómo Generar APK y AAB para Android Tablet](#cómo-generar-apk-y-aab-para-android-tablet)
11. [Respaldo, Restauración y Seguridad](#respaldo-restauración-y-seguridad)
12. [Hoja de Ruta por Fases](#hoja-de-ruta-por-fases)

---

## 🏡 Identidad del Producto

- **Nombre:** Nido
- **Eslogan:** *"Tu hogar, en equilibrio."*
- **Tono:** Cálido, claro, confiable y fácil de recordar. Finanzas que cuidan y ordenan la economía familiar.
- **Ícono:** Casa minimalista en trazo verde esmeralda sobre fondo blanco cálido.
- **Usuario objetivo:** Una sola familia u hogar gestionando sus finanzas desde una tablet central en casa.

---

## 🔒 Privacidad y Restricciones No Negociables

1. **100% Local (Zero Cloud):**
   - Sin servidores, sin APIs externas, sin Firebase, sin publicidad, sin analítica ni telemetría.
   - El archivo `android/app/src/main/AndroidManifest.xml` **no tiene declarado el permiso de INTERNET**. Tus datos financieros jamás salen de la tablet.
2. **Almacenamiento Privado Exclusivo:**
   - La base de datos SQLite y los archivos adjuntos (fotos de cotizaciones) residen estrictamente en el sandbox privado de la aplicación (`path_provider`).
3. **Manejo Estricto del Dinero:**
   - Todo monto financiero se almacena y opera como un número entero en céntimos (`int`).
   - **Prohibido el uso de `double`** para montos de dinero para prevenir errores de redondeo de coma flotante.
   - Encapsulado en el Value Object inmutable `Money` con formateo en Soles peruanos (`es_PE`, `PEN`, `S/ `).
4. **Saldos Dinámicos Derivados (Regla de Oro):**
   - El saldo de una cuenta **no se guarda en una columna de base de datos**. Se calcula de forma reactiva y determinista:
     $$\text{Saldo} = \text{SaldoInicial} + \sum \text{Ingresos} - \sum \text{Gastos} + \sum \text{Transferencias Entrantes} - \sum \text{Transferencias Salientes}$$
     (excluyendo aquellos movimientos marcados como anulados).
5. **Cero Borrado Físico (Auditoría Total):**
   - Los movimientos nunca se eliminan físicamente: se marcan con borrado lógico (`anulado = true`), motivo obligatorio y fecha de anulación.
   - Cada escritura, modificación o anulación se registra de forma inmutable mediante `AuditedWriter` en la tabla `auditoria` con el JSON del estado antes y después.

---

## 📱 Diseño y Experiencia Tablet

Nido fue concebida desde el primer momento para pantallas grandes ($\ge 840\,\text{dp}$):

- **Orientación:** Horizontal (*landscape*) como principal, con adaptación fluida a vertical (*portrait*).
- **Navegación Lateral:** `NavigationRail` persistente en el lateral izquierdo con objetivos táctiles accesibles ($\ge 48\,\text{dp}$).
- **Layout Adaptable en Dos Paneles (`MasterDetailLayout`):**
  - **Ancho $\ge 840\,\text{dp}$:** Panel maestro (lista/resumen a la izquierda de 380 dp) y panel de detalle interactivo a la derecha.
  - **Ancho $< 840\,\text{dp}$:** Navegación secuencial adaptativa.
- **Sistema de Diseño (Material 3 Cálido):**
  - **Primario:** Verde salvia y bosque (`#4B6454` / `#0D5D38`) que transmite solidez y serenidad hogareña.
  - **Fondo:** Crema y lino cálido (`#FAF8F3`) que evita el blanco frío industrial.
  - **Acentos:** Terracota suave (`#B84A28`) para alertas y gastos; verde natural (`#15803D`) para ingresos; azul pizarra (`#2563EB`) para transferencias.
  - **Modos:** Soporte completo para Modo Claro y Modo Oscuro (grafito cálido).

---

## 💡 Reglas de Negocio Clave

- **Resumen Mensual:**
  $$\text{Disponible} = \text{Ingresos} - \text{Gastos Fijos} - \text{Gastos Variables} - \text{Aportes a Proyectos}$$
  Comparación porcentual automática frente al mes inmediatamente anterior ($\pm\%$).
- **Generación Mensual Idempotente de Fijos:**
  Al abrir un nuevo mes (`yyyy-MM`), se autogeneran las cuotas pendientes de gastos fijos sin duplicación (`generarInstanciasMensuales`).
- **Marcar Fijo como Pagado:**
  Operación transaccional ACID: crea el `Movimiento` de gasto enlazado con la cuenta elegida, actualiza el estado de la instancia en `gastos_fijos_pagos` y registra la bitácora de auditoría.
- **Transferencias entre Cuentas:**
  Descuenta de la cuenta de origen y suma a la de destino. No computa como gasto ni ingreso en los reportes de rendimiento neto.
- **Presupuesto por Categoría:**
  Barra de progreso visual con alerta de advertencia al 80% (ámbar) y alerta crítica al 100% (terracota sobregirado).
- **Copia de Presupuestos:**
  Posibilidad de copiar íntegramente las asignaciones del mes anterior con un solo toque y de forma idempotente.
- **Avance Consolidado de Proyectos:**
  $$\text{Avance} = \text{Presupuesto Base} \quad\text{vs}\quad \text{Total Cotizado Adjudicado} \quad\text{vs}\quad \text{Gastado Real Ejecutado}$$
  Permite monitorear el ahorro proyectado frente al presupuesto y el control de desembolsos reales por partida.

---

## 🛠️ Stack Tecnológico

| Componente | Tecnología |
| :--- | :--- |
| **Framework** | Flutter 3.38+ / Dart 3.10+ (Records, Sealed Classes, Null Safety) |
| **Base de Datos** | Drift 2.22+ + `drift_flutter` + SQLite nativo embebido |
| **Gestión de Estado** | Riverpod 2.6+ (`flutter_riverpod`) |
| **Aritmética Financiera** | `Money` Value Object (céntimos enteros `int`, formato `es_PE`) |
| **Navegación** | GoRouter (`go_router`) |
| **Gráficos** | FL Chart (`fl_chart`) |
| **Formato e I18n** | `intl` (`es_PE`) + utilidades seguras `AppDateFormats` |
| **Respaldo y Archivos** | `path_provider`, `archive`, `file_picker`, `share_plus` |
| **Fotografías** | `image_picker` con copia en sandbox privado y rutas relativas |
| **Seguridad Local** | `local_auth` (biometría), `flutter_secure_storage` y `crypto` (hashing con sal) |
| **Calidad de Código** | `flutter_lints` estricto |

---

## 📐 Arquitectura del Proyecto

Organización **Feature-First / Clean Architecture** con capas concéntricas:

```text
lib/
├── main.dart                 # Inicialización de Flutter, formato es_PE y ProviderScope
├── app/                      # Configuración global de la aplicación
│   ├── app.dart              # NidoApp, temas y delegados de localización
│   ├── constants/            # Constantes globales (moneda PEN, breakpoints)
│   ├── router/               # Rutas GoRouter para tablet
│   └── theme/                # Tokens de diseño, paleta cálida y temas M3
├── core/                     # Código transversal compartido
│   ├── database/             # AppDatabase Drift, migraciones y seeds
│   │   ├── tables/           # Definición de tablas SQLite
│   │   └── daos/             # Data Access Objects tipados (Cuentas, Movimientos, Proyectos, etc.)
│   ├── money/                # Value Object Money (céntimos, operaciones, formato S/)
│   ├── audit/                # AuditService y AuditedWriter transaccional
│   ├── utils/                # Utilidades de fecha localizadas (AppDateFormats)
│   └── widgets/              # Widgets base para tablet (TabletScaffold, MasterDetailLayout)
└── features/                 # Módulos organizados por característica de negocio
    ├── dashboard/            # Resumen financiero mensual y métricas ejecutivas
    ├── cuentas/              # Gestión de cuentas, saldos calculados y transferencias
    ├── movimientos/          # Ingresos, gastos, transferencias, filtros y anulación
    ├── gastos_fijos/         # Plantillas recurrentes, vencimientos y "Marcar Pagado"
    ├── presupuesto/          # Presupuesto mensual por categoría y alertas 80%/100%
    ├── proyectos/            # Proyectos de hogar, partidas, comparador y cotizaciones con fotos
    ├── reportes/             # Gráficos de distribución, comparativas y exportación CSV
    ├── auditoria/            # Bitácora inmutable consultable con diff visual
    └── ajustes/              # Moneda, categorías, PIN, respaldo y restauración
```

---

## 📦 Módulos Implementados (Fases 0 a 4)

### Fase 1: Dominio, Base de Datos y Auditoría
- **Value Object `Money`**: Operaciones monetarias exactas con enteros (`cents`), suma, resta, multiplicación, división, comparaciones y formateo en Soles (`S/ 1,250.50`).
- **Drift SQLite v1**: 13 tablas completas (`cuentas`, `categorias`, `movimientos`, `gastos_fijos`, `gastos_fijos_pagos`, `ingresos_fijos`, `ingresos_fijos_cobros`, `presupuestos_mensuales`, `proyectos`, `partidas_proyecto`, `cotizaciones`, `auditoria`, `ajustes`).
- **Semillas Iniciales**: Categorías predeterminadas para el hogar (Alimentación, Servicios, Mantenimiento, etc.) y ajustes de fábrica.
- **Auditoría Transaccional**: `AuditedWriter` encapsula escrituras en transacciones SQLite asegurando que cada mutación guarde un registro en la tabla `auditoria` con snapshots JSON del antes y después.

### Fase 2: Cuentas y Movimientos
- **Cuentas**:
  - CRUD completo para cuentas de Efectivo, Banco, Billetera Digital e Inversión.
  - Cálculo de saldos en tiempo real sin columna en la BD.
  - Dialog modal para transferencias entre cuentas auditadas.
- **Movimientos**:
  - Registro de Ingresos, Gastos y Transferencias con validación en céntimos.
  - Filtros reactivos por mes, tipo de movimiento, cuenta asociada y buscador en tiempo real.
  - Anulación lógica obligatoria con motivo justificado y fecha.
  - Reversión/restauración de movimientos anulados.
  - Layout Master-Detail de 2 paneles optimizado para tablet.

### Fase 3: Gastos/Ingresos Fijos y Presupuestos
- **Gastos e Ingresos Fijos**:
  - Plantillas recurrentes con día de vencimiento (1 al 31) y cuenta asignada.
  - Generación mensual idempotente que evita duplicar cuotas del mismo periodo.
  - Control de estados de vencimiento: `PAGADO`, `VENCIDO`, `VENCE HOY` y `Vence en X días`.
  - Acción "Marcar Pagado" que genera un movimiento vinculado y descuenta el saldo de la cuenta atómicamente.
- **Presupuestos Mensuales**:
  - Asignación por categoría para el periodo (`yyyy-MM`).
  - Barras de progreso con código de color dinámico.
  - Alerta de advertencia al superar el **80%** de ejecución.
  - Alerta crítica al alcanzar o superar el **100%** con indicador de sobregiro.
  - Acción para copiar presupuestos del mes anterior de manera idempotente.

### Fase 4: Proyectos del Hogar & Cotizaciones con Fotos
- **Proyectos con Estados**:
  - Tipos: Decoración, Construcción, Arreglo, Mobiliario u Otro.
  - Ciclo de estados: `idea`, `cotizando`, `aprobado`, `enEjecucion`, `terminado` y `cancelado`.
  - Prioridad: Alta, Media, Baja.
  - Fechas estimadas de inicio y fin con presupuesto objetivo en Soles (`Money`).
- **Partidas Presupuestarias**:
  - Desglose por rubros/partidas dentro de cada proyecto con presupuesto asignado.
  - Estados por partida: `pendiente`, `cotizado`, `adjudicado` y `completado`.
- **Cotizaciones con Foto Física (Local Sandbox)**:
  - Registro de proveedores, monto en Soles, vigencia y notas.
  - Captura con cámara o galería mediante `image_picker`.
  - Las fotos se copian al directorio privado de la app (`getApplicationDocumentsDirectory()/cotizaciones_fotos/`) persistiendo **únicamente la ruta relativa** en SQLite, garantizando portabilidad de respaldos.
  - Visor modal de fotografía con zoom interactivo (`InteractiveViewer`).
- **Comparador de Cotizaciones**:
  - Lista comparativa por partida que resalta visualmente la opción **"MÁS ECONÓMICA"**.
  - Cálculo de ahorro o sobrecosto frente al presupuesto asignado.
  - Selector de **"Elegir Ganadora"**: adjudicación atómica que vincula la cotización elegida a la partida, actualiza su estado a `adjudicado` y desmarca cotizaciones previas. Acción completamente reversible.
- **Avance Consolidado: Presupuesto vs Cotizado vs Gastado Real**:
  - Tarjeta de avance financiero con métricas clave:
    - Presupuesto objetivo del proyecto vs Suma de partidas.
    - Total de cotizaciones ganadoras adjudicadas.
    - Total gastado real desembolsado.
    - Saldo disponible restante.
    - Barras de progreso duales (porcentaje cotizado y porcentaje ejecutado).
- **Vinculación de Movimientos a Partidas**:
  - Modal para registrar gastos reales directos vinculados a una partida específica.
  - Descuenta el saldo de la cuenta bancaria seleccionada e incrementa el gasto real del proyecto con trazabilidad en tiempo real y bitácora de auditoría.

---

## 🧪 Guía de Desarrollo Local y Tests

### Requisitos Previos
- **Flutter SDK:** $\ge 3.38.0$ (Canal Stable).
- **Dart SDK:** $\ge 3.10.0$.

### Ejecutar Pruebas Automatizadas
La suite de pruebas cubre cálculo dinámico de saldos, anulación de movimientos, generación idempotente de gastos fijos, alertas presupuestarias, proyectos y avance financiero, adjudicación atómica de cotizaciones, Value Object `Money`, transaccionalidad de auditoría y renderizado tablet:

```bash
flutter test
```

Salida esperada:
```text
00:05 +39: All tests passed!
```

### Ejecutar Análisis Estático
```bash
flutter analyze
```
Salida esperada:
```text
No issues found!
```

---

## ⚙️ Cómo Ejecutar build_runner

Drift genera código tipado de base de datos (`app_database.g.dart` y `daos/*.g.dart`). Para regenerar este código:

```bash
dart run build_runner build --force-jit --delete-conflicting-outputs
```

> **Nota:** Se utiliza `--force-jit` para garantizar compatibilidad con paquetes nativos en Windows.

---

## 📱 Cómo Generar APK y AAB para Android Tablet

Dado que Nido es una aplicación estrictamente local, la compilación de producción para Android genera un paquete seguro y liviano:

### 1. Generar APK de Producción (Release)
Para generar un APK optimizado por arquitectura:
```bash
flutter build apk --release --split-per-abi
```
Los archivos `.apk` se ubicarán en:
```text
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
build/app/outputs/flutter-apk/app-x86_64-release.apk
```

Para generar un único APK universal instalable en cualquier tablet:
```bash
flutter build apk --release
```

### 2. Generar Android App Bundle (AAB)
```bash
flutter build appbundle --release
```

---

## 💾 Respaldo, Restauración y Seguridad

### 1. Respaldo Autónomo (.zip)
Nido genera un archivo comprimido portátil con el siguiente contenido:
```text
nido_backup_2026-10-10_1830.zip
├── nido.sqlite           # Base de datos SQLite íntegra
├── backup_meta.json      # Versión del esquema, fecha de exportación y hash de integridad
└── cotizaciones_fotos/   # Copia de las fotos de cotizaciones físicas
```

### 2. Restauración Segura
- **Validación previa:** Comprueba compatibilidad de la versión del esquema SQLite.
- **Copia de seguridad preventiva:** Crea automáticamente una copia de la base actual antes de reemplazarla por el respaldo importado.

### 3. Seguridad Local (PIN y Biometría)
- El PIN nunca se almacena en texto plano: se genera un hash criptográfico PBKDF2 combinado con un `salt` aleatorio único por instalación guardado en `flutter_secure_storage`.
- Soporte para autenticación biométrica (`local_auth`) al iniciar o regresar de segundo plano.

---

## 🗺️ Hoja de Ruta por Fases

- [x] **Fase 0: Scaffolding, Base Tablet y Lints**
  - Entorno configurado, dependencias resueltas, AndroidManifest sin red, tema M3, layout dual y pruebas base.
- [x] **Fase 1: Motor de Dominio, Money y Drift con Auditoría**
  - Value Object `Money`, 13 tablas SQLite, índices, `AuditedWriter`, seeds de categorías, ajustes y DAOs.
- [x] **Fase 2: Cuentas, Movimientos y Anulación Lógica**
  - Saldos dinámicos calculados, transferencias, filtros avanzados, anulación justificada, restauración y vistas Tablet Master-Detail.
- [x] **Fase 3: Gastos e Ingresos Fijos & Presupuestos**
  - Generación mensual idempotente, vencimientos (`PAGADO`, `VENCIDO`, `VENCE HOY`), acción "Marcar Pagado" vinculada y alertas presupuestarias 80%/100% con copia del mes anterior.
- [x] **Fase 4: Proyectos del Hogar & Cotizaciones con Fotos**
  - Ciclo de proyectos y partidas, fotos en sandbox privado con rutas relativas, comparador de cotizaciones (resaltado más económica), adjudicación ganadora atómica, avance Presupuesto vs Cotizado vs Gastado Real y vinculación de movimientos auditados.
- [ ] **Fase 5: Dashboard del Hogar & Reportes Visuales**
  - Métricas ejecutivas, gráficos `fl_chart` y exportación a CSV.
- [ ] **Fase 6: Bitácora de Auditoría, PIN y Respaldo ZIP**
  - Visor de diferencias (*diff*), bloqueo biométrico/PIN y respaldo/restauración `.zip`.
- [ ] **Fase 7: Onboarding en 3 Pasos, Ajustes y Datos Demo**
  - Flujo de bienvenida inicial y generador de datos de prueba.
- [ ] **Fase 8: QA Integral Tablet, Tests Completos y Cierre**

---

*Desarrollado con dedicación para cuidar la tranquilidad económica de tu hogar.*