# 🏠 Nido - Tu hogar, en equilibrio

> **Gestión integral de finanzas del hogar, profesional, 100% LOCAL, diseñada con prioridad MOBILE-FIRST y adaptabilidad fluida a TABLET.**

[![Flutter](https://img.shields.io/badge/Flutter-3.38+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Drift](https://img.shields.io/badge/Database-Drift%20SQLite-00599C)](https://drift.simonbinder.eu)
[![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen)](test/)
[![Arquitectura](https://img.shields.io/badge/Architecture-Feature--First%20Clean-success)](#arquitectura-del-proyecto)
[![Privacidad](https://img.shields.io/badge/Privacidad-100%25%20Local%20%7C%20Zero%20Cloud-2E7D32)](#privacidad-y-restricciones-no-negociables)
[![Formato](https://img.shields.io/badge/UI-Mobile--First%20%26%20Tablet-00796B)](#diseño-y-experiencia-mobile-first-y-tablet)

---

## 📑 Tabla de Contenidos
1. [Identidad del Producto](#identidad-del-producto)
2. [Privacidad y Restricciones No Negociables](#privacidad-y-restricciones-no-negociables)
3. [Diseño y Experiencia Mobile-First y Tablet](#diseño-y-experiencia-mobile-first-y-tablet)
4. [Responsive & Experiencia Multi-Dispositivo](#responsive--experiencia-multi-dispositivo)
5. [Reglas de Negocio Clave](#reglas-de-negocio-clave)
6. [Stack Tecnológico](#stack-tecnológico)
7. [Arquitectura del Proyecto](#arquitectura-del-proyecto)
8. [Módulos Implementados (Fases 0 a 7)](#módulos-implementados-fases-0-a-7)
9. [Guía de Desarrollo Local y Tests](#guía-de-desarrollo-local-y-tests)
10. [Cómo Ejecutar build_runner](#cómo-ejecutar-build_runner)
11. [Cómo Generar APK y AAB para Android (Móviles y Tablets)](#cómo-generar-apk-y-aab-para-android-móviles-y-tablets)
12. [Generación e Instalación del APK Release Firmado](#generación-e-instalación-del-apk-release-firmado)
13. [Respaldo, Restauración y Seguridad](#respaldo-restauración-y-seguridad)
14. [Hoja de Ruta por Fases](#hoja-de-ruta-por-fases)

---

## 🏡 Identidad del Producto

- **Nombre:** Nido
- **Eslogan:** *"Tu hogar, en equilibrio."*
- **Tono:** Cálido, claro, confiable y fácil de recordar. Finanzas que cuidan y ordenan la economía familiar.
- **Ícono:** Casa minimalista en trazo verde esmeralda sobre fondo blanco cálido.
- **Usuario objetivo:** Familias y personas que gestionan sus finanzas personales y del hogar desde su smartphone de uso diario (prioridad Mobile-First) o desde una tablet central en casa.

---

## 🔒 Privacidad y Restricciones No Negociables

1. **100% Local (Zero Cloud):**
   - Sin servidores, sin APIs externas, sin Firebase, sin publicidad, sin analítica ni telemetría.
   - El archivo `android/app/src/main/AndroidManifest.xml` **no tiene declarado el permiso de INTERNET**. Tus datos financieros jamás salen de tu smartphone o tablet.
2. **Almacenamiento Privado Exclusivo:**
   - La base de datos SQLite, los archivos adjuntos (fotos) y los reportes exportados residen estrictamente en el sandbox privado de la aplicación (`path_provider`).
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

## 📱 Diseño y Experiencia Mobile-First y Tablet

Nido fue concebida y desarrollada bajo el principio **Mobile-First**: la experiencia primordial está diseñada para el dispositivo que acompaña al usuario en su día a día (su smartphone), optimizando la ergonomía a una mano, la legibilidad en pantallas compactas y los tiempos de interacción, al tiempo que escala con naturalidad hacia tablets ($\ge 720\,\text{dp}$ / $\ge 840\,\text{dp}$) y formatos amplios.

### 1. Prioridad Mobile-First (Smartphones $< 720\,\text{dp}$)
- **Ergonomía a una sola mano:** Elementos interactivos primarios, selectores de mes, filtros y botones de acción flotante (FAB) posicionados estratégicamente en zonas accesibles con el pulgar.
- **Navegación Móvil Despejada:**
  - `AppBar` compacto con isotipo oficial y badge *"Local"*, maximizando el área útil vertical.
  - Menú lateral deslizante (`Drawer`) organizado con los 10 módulos de la aplicación, manteniendo la interfaz despejada sin barras atestadas.
  - Respeto riguroso de `SafeArea` (arriba y abajo) para convivir fluidamente con muescas (*notches*), cámaras frontales y barras de gestos del sistema Android e iOS.
- **Layout Master-Detail Adaptativo (`MasterDetailLayout`):**
  - En anchos $< 840\,\text{dp}$, el sistema conmuta automáticamente a un selector segmentado interactivo `[ 📋 Lista | 🔍 Detalle ]`.
  - Botón directo *"Volver a la lista"* y transiciones suaves con `AnimatedSwitcher` para inspeccionar detalles y volver sin recargas ni saltos bruscos.
- **Touch Targets Accesibles:** Tamaño mínimo de objetivo táctil de $\ge 48\,\text{dp}$ con márgenes de separación para evitar toques involuntarios en pantallas táctiles densas.

### 2. Escalabilidad Adaptativa a Tablet ($\ge 720\,\text{dp}$ / $\ge 840\,\text{dp}$)
- **Navegación Lateral Persistente:** Se transforma automáticamente en un `NavigationRail` vertical permanente a la izquierda con branding y accesos rápidos directos.
- **Doble Panel Simultáneo (Dual-Pane):** En pantallas $\ge 840\,\text{dp}$, `MasterDetailLayout` muestra ambos paneles lado a lado (panel maestro de 380 dp y panel de detalle expandido) con un divisor vertical sutil.
- **Orientación Flexible:** Fluidez total en orientación vertical (*portrait*) y horizontal (*landscape*).

### 3. Sistema de Diseño (Material 3 Cálido)
- **Primario:** Verde salvia y bosque (`#4B6454` / `#0D5D38`) que transmite orden, solidez y serenidad financiera.
- **Fondo:** Crema y lino cálido (`#FAF8F3`) que proporciona confort visual y reduce la fatiga frente a pantallas blancas frías.
- **Acentos Funcionales:** Terracota suave (`#B84A28`) para alertas y gastos; verde natural (`#15803D`) para ingresos; azul pizarra (`#2563EB`) para transferencias y disponibilidad.
- **Modo Oscuro Integrado:** Paleta grafito cálido que protege la vista de noche y ahorra batería en paneles OLED/AMOLED de smartphones.

---

## 📱 Responsive & Experiencia Multi-Dispositivo

Nido garantiza una experiencia consistente y sin fricciones adaptándose dinámicamente al tamaño de pantalla:

| Característica | Smartphone (Prioridad Mobile-First $< 720\,\text{dp}$) | Tablet (Adaptación $\ge 720\,\text{dp}$ / $\ge 840\,\text{dp}$) |
|---|---|---|
| **Enfoque de Diseño** | **Primario (Mobile-First):** Ergonomía a una mano, navegación ágil y densidad de información optimizada. | **Secundario / Adaptativo:** Aprovechamiento panorámico horizontal y vista simultánea de paneles. |
| **Navegación Principal** | `AppBar` compacto con acceso a menú `Drawer` con los 10 módulos y acceso rápido. | `NavigationRail` lateral fijo con accesos rápidos, branding y badges. |
| **Vistas Master-Detail** | Selector segmentado interactivo `[ 📋 Lista \| 🔍 Detalle ]` con botón rápido *"Volver a la lista"*. | Paneles duales paralelos (Lista de 380 dp a la izquierda y Detalle a la derecha). |
| **Encabezado y Barra** | Barra superior compacta con isotipo oficial Nido y distintivo *"Local"*. | Cabecera expandida con insignia de seguridad *"100% Local"* y reloj/branding. |
| **Entrada de Datos y Modales** | Formularios optimizados en una columna vertical con teclados numéricos específicos. | Diálogos modales y paneles laterales con distribución equilibrada en dos columnas. |
| **Touch Targets** | Objetivos táctiles mínimos $\ge 48\,\text{dp}$ y márgenes para prevención de toques accidentales. | Botones e interactivos $\ge 48\,\text{dp}$ con tooltips interactivos descriptivos. |
| **Gestión de Pantalla** | `SafeArea` estricto en cabecera y pie para interacción libre de cortes por bordes o muescas (*notches*). | Aprovechamiento panorámico con orientación vertical (*portrait*) y horizontal (*landscape*). |

---

## 💡 Reglas de Negocio Clave

- **Resumen Mensual:**
  $$\text{Disponible} = \text{Ingresos} - \text{Gastos Fijos} - \text{Gastos Variables} - \text{Aportes a Proyectos}$$
  Comparación porcentual automática frente al mes inmediatamente anterior ($\pm\%$) y cálculo de la diferencia absoluta en Soles.
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
| **Navegación** | GoRouter (`go_router`) con navegación adaptativa |
| **Gráficos** | FL Chart (`fl_chart` v1.2+) para tortas (`PieChart`) y tendencias (`LineChart`) |
| **Formato e I18n** | `intl` (`es_PE`) + utilidades seguras `AppDateFormats` |
| **Respaldo y Archivos** | `path_provider`, `archive`, `file_picker`, `share_plus` |
| **Fotografías** | `image_picker` con copia en sandbox privado y rutas relativas |
| **Exportación** | CSV RFC 4180 con UTF-8 BOM + Generador nativo PDF 1.4 en Dart puro |
| **Seguridad Local** | `local_auth` (biometría), `flutter_secure_storage` y `crypto` (hashing con sal) |
| **Calidad de Código** | `flutter_lints` estricto |

---

## 📐 Arquitectura del Proyecto

Organización **Feature-First / Clean Architecture** con capas concéntricas:

```text
lib/
├── main.dart                 # Inicialización de Flutter, formato es_PE y ProviderScope
├── app/                      # Configuración global de la aplicación
│   ├── app.dart              # NidoApp, navegación por índice y temas
│   ├── constants/            # Constantes globales (moneda PEN, breakpoints)
│   ├── router/               # Rutas GoRouter adaptadas para móvil y tablet
│   └── theme/                # Tokens de diseño, paleta cálida y temas M3 (Claro y Oscuro)
├── core/                     # Código transversal compartido
│   ├── database/             # AppDatabase Drift, migraciones y seeds
│   │   ├── tables/           # Definición de tablas SQLite
│   │   └── daos/             # Data Access Objects tipados (Cuentas, Movimientos, Proyectos, etc.)
│   ├── money/                # Value Object Money (céntimos, operaciones, formato S/)
│   ├── audit/                # AuditService y AuditedWriter transaccional
│   ├── utils/                # Utilidades de fecha localizadas (AppDateFormats)
│   └── widgets/              # Widgets base responsivos (TabletScaffold, MasterDetailLayout, EmptyStateView)
└── features/                 # Módulos organizados por característica de negocio
    ├── dashboard/            # Resumen financiero mensual, comparativas y gráficos fl_chart
    ├── cuentas/              # Gestión de cuentas, saldos calculados y transferencias
    ├── movimientos/          # Ingresos, gastos, transferencias, filtros y anulación
    ├── gastos_fijos/         # Plantillas recurrentes, vencimientos y "Marcar Pagado"
    ├── presupuesto/          # Presupuesto mensual por categoría y alertas 80%/100%
    ├── proyectos/            # Proyectos de hogar, partidas, comparador y cotizaciones con fotos
    ├── reportes/             # Tendencias 6/12 meses, tabla de evolución y exportación CSV/PDF
    ├── auditoria/            # Bitácora inmutable consultable con diff visual
    ├── onboarding/           # Flujo de bienvenida en 3 pasos con precarga de datos demo
    └── ajustes/              # Moneda, categorías, PIN, modo oscuro, respaldo y restauración
```

---

## 📦 Módulos Implementados (Fases 0 a 7)

### Fase 0: Scaffolding, Base Mobile-First / Tablet y Lints
- Entorno configurado, dependencias resueltas, `AndroidManifest.xml` sin permisos de red (100% privado).
- Sistema de temas Material 3 cálido con soporte para Modo Claro y Modo Oscuro.
- Arquitectura de layout adaptativo: `TabletScaffold` (conmutación entre `Drawer` móvil y `NavigationRail` tablet) y `MasterDetailLayout` (conmutación entre selector segmentado y doble panel).

### Fase 1: Dominio, Base de Datos y Auditoría
- **Value Object `Money`**: Operaciones monetarias exactas con enteros (`cents`), suma, resta, multiplicación, división, comparaciones y formateo en Soles (`S/ 1,250.50`).
- **Drift SQLite v1**: 13 tablas completas (`cuentas`, `categorias`, `movimientos`, `gastos_fijos`, `gastos_fijos_pagos`, `ingresos_fijos`, `ingresos_fijos_cobros`, `presupuestos_mensuales`, `proyectos`, `partidas_proyecto`, `cotizaciones`, `auditoria`, `ajustes`).
- **Semillas Iniciales**: Categorías predeterminadas para el hogar (Alimentación, Servicios, Mantenimiento, etc.) y ajustes de fábrica.
- **Auditoría Transaccional**: `AuditedWriter` encapsula escrituras en transacciones SQLite asegurando que cada mutación guarde un registro en la tabla `auditoria` con snapshots JSON del antes y después.

### Fase 2: Cuentas y Movimientos
- **Cuentas**: CRUD completo para cuentas de Efectivo, Banco, Billetera Digital e Inversión; cálculo dinámico de saldos; transferencias entre cuentas auditadas.
- **Movimientos**: Registro con validación en céntimos; filtros reactivos por mes, tipo, cuenta y buscador; anulación lógica con motivo y reversión; layout Master-Detail adaptativo a móvil y tablet.

### Fase 3: Gastos/Ingresos Fijos y Presupuestos
- **Gastos e Ingresos Fijos**: Plantillas recurrentes; generación mensual idempotente; estados de vencimiento (`PAGADO`, `VENCIDO`, `VENCE HOY`); acción transaccional "Marcar Pagado".
- **Presupuestos Mensuales**: Asignación por categoría; barras de progreso con alertas dinámicas al 80% y 100% (sobregiro); copia idempotente del mes anterior.

### Fase 4: Proyectos del Hogar & Cotizaciones con Fotos
- **Proyectos y Partidas**: Ciclo de estados (`idea` a `terminado`); partidas presupuestarias desglosadas por rubro.
- **Cotizaciones con Foto Física**: Copia en sandbox privado de la app (`getApplicationDocumentsDirectory()/cotizaciones_fotos/`) persistiendo **únicamente la ruta relativa** en SQLite; visor de fotos con zoom (`InteractiveViewer`).
- **Comparador y Adjudicación Atómica**: Resaltado visual de opción más económica; cálculo de ahorro vs presupuesto; selector de cotización ganadora atómico y reversible.
- **Avance Financiero Consolidado**: Presupuesto vs Cotizado Ganador vs Gastado Real; vinculación de movimientos auditados a partidas.

### Fase 5: Dashboard del Hogar, Tendencias & Reportes Visuales
- **Dashboard Mensual Principal**:
  - Selector interactivo de mes (`< OCTUBRE 2026 >`) con navegación ágil entre periodos.
  - Tarjetas de resumen financiero con la Regla de Oro:
    $$\text{Disponible} = \text{Ingresos} - \text{Gastos Fijos} - \text{Gastos Variables} - \text{Aportes a Proyectos}$$
  - **Comparación con el Mes Anterior**: Diferencia absoluta en Soles ($\Delta \text{PEN}$) y variación porcentual ($\pm\%$) para Ingresos, Gastos y Dinero Disponible.
  - **Gráfico de Gastos por Categoría (`fl_chart` `PieChart`)**: Gráfico de dona con paleta cálida, cálculo de porcentajes y leyenda interactiva con montos en Soles.
  - **Tendencia Histórica a 6 y 12 Meses (`fl_chart` `LineChart`)**: Curvas interactivas para Ingresos, Gastos y Disponible, con tooltips táctiles con formato Soles.
  - **Próximos Vencimientos**: Listado compacto de cuotas pendientes del mes con etiquetas (`VENCIDO`, `VENCE HOY`, `Por vencer`).
  - **Avance de Presupuestos**: Barras de progreso por categoría presupuestada con alertas 80% (ámbar) y 100% (sobregirado).
  - **Proyectos en Marcha**: Avance consolidado (Presupuesto Objetivo vs Cotizado vs Gastado).
- **Reportes Financieros & Exportación (100% Local)**:
  - Pantalla dedicada con selector de 6/12 meses y tabla de evolución mensual detallada.
  - **Exportación CSV (RFC 4180)**: Con codificación UTF-8 BOM para apertura nativa en Microsoft Excel y Google Sheets.
  - **Exportación PDF (%PDF-1.4)**: Generador en Dart puro con membrete oficial, resumen ejecutivo, tabla de categorías y listado de movimientos.
  - Diálogo modal de exportación y compartición nativa mediante `SharePlus`.

### Fase 6: Bitácora de Auditoría, PIN y Respaldo ZIP
- **Bitácora de Auditoría (100% Inmutable y Solo Lectura)**:
  - Pantalla Master-Detail adaptativa con historial cronológico de todas las mutaciones del sistema.
  - Filtros combinados por entidad (`Movimiento`, `Cuenta`, `Proyecto`, `PartidaProyecto`, `Cotizacion`, `PresupuestosMensuales`), acción (`crear`, `editar`, `anular`, `restaurar`, `elegir_ganadora`, `exportar`, `importar`) y fecha.
  - Visor visual de diferencias (`AuditoriaDiffViewer`) antes vs después: resalta en verde los valores entrantes y en terracota los valores previos modificados.
  - Solo lectura estricta: sin mecanismos de borrado o manipulación.
- **Seguridad Local (PIN + Hash SHA-256 + Sal de 32 bytes y Biometría)**:
  - Sal aleatoria criptográfica única de 32 bytes (`Random.secure()`) y hash derivado SHA-256, persistidos en el almacenamiento seguro del dispositivo (`flutter_secure_storage`).
  - Teclado numérico accesible ($\ge 48\,\text{dp}$) en `PinLockScreen`, con indicadores animados de dígitos y retroalimentación háptica.
  - Desbloqueo biométrico nativo con hardware del dispositivo (huella dactilar o reconocimiento facial mediante `local_auth`).
  - **Bloqueo automático al volver de segundo plano**: Detección del ciclo de vida (`WidgetsBindingObserver` / `AppLifecycleState.paused` -> `resumed`) para proteger la privacidad visual e interacción al salir de la app.
- **Copia de Seguridad y Restauración Portable (.zip)**:
  - Exportación integral a `.zip`: empaqueta la base de datos `nido.sqlite`, comprobantes adjuntos (`cotizaciones_fotos/`) y el manifiesto `backup_meta.json` con metadatos y checksum SHA-256.
  - Validación de versión de esquema estricta: rechaza archivos si $v_{\text{respaldo}} > v_{\text{actual}}$ y comprueba la integridad física con hash antes de escribir.
  - **Copia previa de seguridad automática** (`nido_db.sqlite.pre_restore_TIMESTAMP`) generada en el almacenamiento privado antes de sobreescribir los datos actuales.
  - Diálogo nativo para compartir el archivo `.zip` resultante mediante `share_plus`.
- **Recordatorio Proactivo de Respaldo (>30 días)**:
  - Banner dinámico en la pantalla de Ajustes que alerta al usuario cuando no se han generado copias de seguridad en más de 30 días o si nunca se ha realizado un respaldo, con botón directo de exportación.

### Fase 7: Onboarding, Experiencia Mobile-First, Modo Oscuro, Datos Demo y Release
- **Flujo guiado de Onboarding interactivo en 3 pasos**:
  - Bienvenida cálida con explicación de privacidad soberana 100% local.
  - Opción de inicio limpio o precarga de datos de demostración realistas en Soles (`PEN`).
  - Configuración inicial de moneda y cuenta principal.
- **Optimización Mobile-First**:
  - Interfaz nativa para Smartphones ($< 720\,\text{dp}$) con `AppBar` compacto, navegación con `Drawer` completo de 10 módulos y selector segmentado `[ 📋 Lista | 🔍 Detalle ]`.
  - Componente accesible `EmptyStateView` para estados vacíos en todos los módulos, con etiquetas Semantics y touch targets $\ge 48\,\text{dp}$.
- **Soporte de Temas Claro y Oscuro**: Configurable dinámicamente desde Ajustes con persistencia local.
- **Generador de Datos Demo Auditados**: Creación de historial financiero realista de 3 meses para exploración inmediata.
- **Identidad Visual Oficial**: Ícono minimalista de la casa verde en todas las densidades de pantalla (mdpi a xxxhdpi) y Splash Screen nativo de lanzamiento.
- **Compilación de Producción**: Generación y firma de APK Release para smartphones y tablets Android.

---

## 🧪 Guía de Desarrollo Local y Tests

### Requisitos Previos
- **Flutter SDK:** $\ge 3.38.0$ (Canal Stable).
- **Dart SDK:** $\ge 3.10.0$.

### Ejecutar Pruebas Automatizadas
La suite de pruebas cubre cálculo de saldos, anulación de movimientos, generación idempotente de gastos fijos, alertas presupuestarias, proyectos y avance financiero, resumen mensual y comparativas del dashboard, tendencias históricas, exportación a CSV/PDF, Value Object `Money`, transaccionalidad de auditoría y renderizado responsivo móvil y tablet:

```bash
flutter test
```

### Ejecutar Análisis Estático
```bash
flutter analyze
```

---

## ⚙️ Cómo Ejecutar build_runner

Drift genera código tipado de base de datos (`app_database.g.dart` y `daos/*.g.dart`). Para regenerar este código:

```bash
dart run build_runner build --force-jit --delete-conflicting-outputs
```

> **Nota:** Se utiliza `--force-jit` para garantizar compatibilidad con paquetes nativos en Windows.

---

## 📱 Cómo Generar APK y AAB para Android (Móviles y Tablets)

Dado que Nido es una aplicación estrictamente local, la compilación de producción para Android genera un paquete seguro, liviano y optimizado tanto para smartphones como para tablets:

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

Para generar un único APK universal instalable en cualquier smartphone o tablet:
```bash
flutter build apk --release
```

### 2. Generar Android App Bundle (AAB)
```bash
flutter build appbundle --release
```

---

## 📦 Generación e Instalación del APK Release Firmado

Para compilar el APK de producción firmado listo para instalar en cualquier teléfono o tablet Android:

```bash
flutter build apk --release
```

El instalador final se genera en:
`build/app/outputs/flutter-apk/app-release.apk`

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

- [x] **Fase 0: Scaffolding, Base Mobile-First / Tablet y Lints**
  - Entorno configurado, dependencias resueltas, AndroidManifest sin red, tema M3, layout adaptativo y pruebas base.
- [x] **Fase 1: Motor de Dominio, Money y Drift con Auditoría**
  - Value Object `Money`, 13 tablas SQLite, índices, `AuditedWriter`, seeds de categorías, ajustes y DAOs.
- [x] **Fase 2: Cuentas, Movimientos y Anulación Lógica**
  - Saldos dinámicos calculados, transferencias, filtros avanzados, anulación justificada, restauración y vistas adaptativas móvil/tablet.
- [x] **Fase 3: Gastos e Ingresos Fijos & Presupuestos**
  - Generación mensual idempotente, vencimientos (`PAGADO`, `VENCIDO`, `VENCE HOY`), acción "Marcar Pagado" vinculada y alertas presupuestarias 80%/100% con copia del mes anterior.
- [x] **Fase 4: Proyectos del Hogar & Cotizaciones con Fotos**
  - Ciclo de proyectos y partidas, fotos en sandbox privado con rutas relativas, comparador de cotizaciones (resaltado más económica), adjudicación ganadora atómica, avance Presupuesto vs Cotizado vs Gastado Real y vinculación de movimientos auditados.
- [x] **Fase 5: Dashboard del Hogar & Reportes Visuales**
  - Dashboard mensual consolidado, tarjetas de métricas, comparación $\pm\%$ y $\Delta$ S/ con mes anterior, gráficos `fl_chart` (pie chart por categoría y tendencia 6/12 meses), vencimientos, presupuestos, proyectos y exportación local a CSV y PDF.
- [x] **Fase 6: Bitácora de Auditoría, PIN y Respaldo ZIP**
  - Visor de diferencias (*diff*), bloqueo biométrico/PIN y respaldo/restauración `.zip`.
- [x] **Fase 7: Onboarding, Experiencia Mobile-First, Modo Oscuro, Datos Demo y APK Release**
  - Flujo guiado de Onboarding interactivo en 3 pasos con opción de precarga de datos familiares demo o inicio con base limpia.
  - Diseño responsivo Mobile-First: optimizado para Smartphones ($< 720\,\text{dp}$) con `AppBar`, `Drawer` con los 10 módulos y selector segmentado `[ 📋 Lista | 🔍 Detalle ]`; escalable a Tablets ($\ge 720\,\text{dp}$ / $\ge 840\,\text{dp}$) con `NavigationRail` lateral y `MasterDetailLayout` dual simultáneo.
  - Componente accesible `EmptyStateView` para estados vacíos en todos los módulos, con etiquetas Semantics y touch targets $\ge 48\,\text{dp}$.
  - Soporte completo para Modo Oscuro (*Dark Theme*) y Modo Claro, configurable dinámicamente desde Ajustes.
  - Generador de datos demo realistas en Soles (PEN) auditados y función de restablecimiento a base limpia.
  - Identidad visual completa: Ícono minimalista de la casa verde en todas las densidades de pantalla (mdpi a xxxhdpi) y Splash Screen nativo de lanzamiento.
  - Keystore de release configurado y APK firmado generado para instalación física: `build/app/outputs/flutter-apk/app-release.apk`.
  - Suite de pruebas automatizadas y 0 advertencias en análisis estático.

---

*Desarrollado con dedicación para cuidar la tranquilidad económica de tu hogar en tu smartphone y en tu tablet.*