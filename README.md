# 🏠 Nido — Tu hogar, en equilibrio

> **Gestión integral de finanzas del hogar, profesional, 100% LOCAL y diseñada exclusivamente para TABLET.**

[![Flutter](https://img.shields.io/badge/Flutter-3.38+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Drift](https://img.shields.io/badge/Database-Drift%20SQLite-00599C)](https://drift.simonbinder.eu)
[![Arquitectura](https://img.shields.io/badge/Architecture-Feature--First%20Clean-success)](#arquitectura-del-proyecto)
[![Privacidad](https://img.shields.io/badge/Privacidad-100%25%20Local%20%7C%20Zero%20Cloud-2E7D32)](#privacidad-y-restricciones-no-negociables)
[![Formato](https://img.shields.io/badge/Tablet-Master--Detail%20%E2%89%A5840dp-E65100)](#diseño-y-experiencia-tablet)

---

## 📋 Tabla de Contenidos
1. [Identidad del Producto](#identidad-del-producto)
2. [Privacidad y Restricciones No Negociables](#privacidad-y-restricciones-no-negociables)
3. [Reglas de Negocio Clave](#reglas-de-negocio-clave)
4. [Stack Tecnológico](#stack-tecnológico)
5. [Arquitectura del Proyecto](#arquitectura-del-proyecto)
6. [Modelo de Datos (SQLite / Drift)](#modelo-de-datos-sqlite--drift)
7. [Guía de Desarrollo Local](#guía-de-desarrollo-local)
8. [Cómo Ejecutar build_runner](#cómo-ejecutar-build_runner)
9. [Cómo Generar APK y AAB para Android Tablet](#cómo-generar-apk-y-aab-para-android-tablet)
10. [Respaldo, Restauración y Seguridad](#respaldo-restauración-y-seguridad)
11. [Hoja de Ruta por Fases](#hoja-de-ruta-por-fases)

---

## 🏡 Identidad del Producto

- **Nombre:** Nido
- **Eslogan:** *"Tu hogar, en equilibrio."*
- **Tono:** Cálido, claro, confiable y fácil de recordar. Finanzas que cuidan y ordenan la economía familiar.
- **Ícono:** Casa minimalista en trazo verde esmeralda sobre fondo blanco cálido.
- **Usuario objetivo:** Una sola familia u hogar gestionando sus finanzas desde una tablet central en casa.

---

## 🛡️ Privacidad y Restricciones No Negociables

1. **100% Local (Zero Cloud):**
   - Sin servidores, sin APIs externas, sin Firebase, sin publicidad, sin analítica ni telemetría.
   - El archivo `android/app/src/main/AndroidManifest.xml` **no tiene declarado el permiso de INTERNET**. Tus datos financieros nunca viajan por la red.
2. **Almacenamiento Privado Exclusivo:**
   - La base de datos SQLite y las fotos de cotizaciones residen en el sandbox privado de la aplicación (`path_provider`).
3. **Manejo Estricto del Dinero:**
   - Todo monto financiero se almacena y opera como entero en céntimos (`int`).
   - **Prohibido el uso de `double`** para montos de dinero para prevenir errores de coma flotante.
   - Encapsulado en el Value Object inmutable `Money` con formateo en Soles peruanos (`es_PE`, `S/`).
4. **Saldos Dinámicos Derivados:**
   - El saldo de una cuenta **no se guarda en una columna de base de datos**. Se calcula de forma reactiva y determinista:
     $$\text{Saldo} = \text{SaldoInicial} + \sum \text{Ingresos} - \sum \text{Gastos} \pm \sum \text{Transferencias}$$
     (excluyendo aquellos movimientos marcados como anulados).
5. **Cero Borrado Físico (Auditoría Total):**
   - Los movimientos nunca se eliminan físicamente: se marcan con borrado lógico (`anulado = true`), motivo obligatorio y fecha de anulación.
   - Cada escritura, modificación o anulación se registra de forma inmutable mediante `AuditedWriter` en la tabla `Auditoria`.

---

## 📐 Diseño y Experiencia Tablet

Nido fue concebida desde cero para pantallas grandes:

- **Orientación:** Horizontal (landscape) como principal, con adaptación fluida a vertical (portrait).
- **Navegación Lateral:** `NavigationRail` persistente en el lateral izquierdo con 9 secciones principales y objetivos táctiles accesibles ($\ge 48\,\text{dp}$).
- **Layout Adaptable en Dos Paneles (`MasterDetailLayout`):**
  - **Ancho $\ge 840\,\text{dp}$:** Panel maestro (lista/resumen a la izquierda) y panel de detalle completo a la derecha.
  - **Ancho $< 840\,\text{dp}$:** Navegación secuencial adaptativa.
- **Sistema de Diseño (Material 3 Cálido):**
  - **Primario:** Verde esmeralda profundo (`#0D5D38`) que transmite solidez y calma hogareña.
  - **Fondo:** Crema y lino cálido (`#FAF8F3`) que evita el blanco frío.
  - **Acentos:** Terracota suave (`#B84A28`) para alertas y gastos; verde natural (`#15803D`) para ingresos.
  - **Modos:** Soporte completo para Modo Claro y Modo Oscuro (grafito cálido).

---

## 💼 Reglas de Negocio Clave

- **Resumen Mensual:**
  $$\text{Disponible} = \text{Ingresos} - \text{Gastos Fijos} - \text{Gastos Variables} - \text{Aportes a Proyectos}$$
  Comparación porcentual automática frente al mes inmediatamente anterior ($\pm\%$).
- **Generación Mensual Idempotente de Fijos:**
  Al abrir un nuevo mes (`yyyy-MM`), se autogeneran las instancias pendientes de gastos e ingresos fijos sin duplicación.
- **Marcar Fijo como Pagado:**
  Operación transaccional ACID: crea el `Movimiento` enlazado con la cuenta elegida, actualiza el estado de la instancia y registra la bitácora de auditoría.
- **Transferencias entre Cuentas:**
  Descuenta de la cuenta de origen y suma a la de destino. No computa como gasto ni ingreso en los reportes de rendimiento.
- **Presupuesto por Categoría:**
  Barra de progreso visual con alerta de prevención al 80% y alerta crítica al 100%.
- **Proyectos y Comparador de Cotizaciones:**
  Presupuesto estimado vs suma de cotizaciones seleccionadas vs gasto real ejecutado. Permite fotografiar cotizaciones físicas y resalta automáticamente la oferta más económica.

---

## 🛠️ Stack Tecnológico

| Componente | Tecnología |
| :--- | :--- |
| **Framework** | Flutter 3.38+ / Dart 3.10+ (Records, Sealed Classes, Null Safety) |
| **Base de Datos** | Drift + `drift_flutter` + SQLite nativo embebido |
| **Gestión de Estado** | Riverpod (`flutter_riverpod`) |
| **Navegación** | GoRouter (`go_router`) |
| **Gráficos** | FL Chart (`fl_chart`) |
| **Formato e I18n** | `intl` (`es_PE`) + `flutter_localizations` |
| **Respaldo y Archivos** | `path_provider`, `archive`, `file_picker`, `share_plus` |
| **Fotografías** | `image_picker` con copia en sandbox privado y rutas relativas |
| **Seguridad Local** | `local_auth` (biometría), `flutter_secure_storage` y `crypto` (hashing con sal) |
| **Calidad de Código** | `flutter_lints` estricto |

---

## 🏛️ Arquitectura del Proyecto

Organización **Feature-First** con capas limpias concéntricas:

```text
lib/
├── main.dart                 # Punto de entrada y arranque de ProviderScope
├── app/                      # Configuración global de la aplicación
│   ├── app.dart              # NidoApp, temas y delegados de localización
│   ├── constants/            # Constantes globales (moneda PEN, breakpoints)
│   ├── router/               # Rutas GoRouter para tablet
│   └── theme/                # Tokens de diseño, paleta cálida y temas M3
├── core/                     # Código transversal compartido
│   ├── database/             # AppDatabase Drift, migraciones y seeds
│   │   ├── tables/           # Definición de tablas SQLite
│   │   └── daos/             # Data Access Objects tipados
│   ├── money/                # Value Object Money (céntimos, operaciones, formato)
│   ├── audit/                # AuditService y AuditedWriter transaccional
│   ├── utils/                # Utilidades de fecha, validadores, periodos yyyy-MM
│   └── widgets/              # Widgets base (TabletScaffold, MasterDetailLayout)
└── features/                 # Módulos organizados por característica de negocio
    ├── onboarding/           # Bienvenida en 3 pasos, configuración inicial
    ├── dashboard/            # Resumen financiero mensual y métricas ejecutivas
    ├── cuentas/              # Gestión de cuentas, bolsillos y transferencias
    ├── movimientos/          # Ingresos, gastos, arqueos y anulación lógica
    ├── gastos_fijos/         # Plantillas recurrentes y generación mensual
    ├── presupuesto/          # Presupuesto mensual por categoría y alertas
    ├── proyectos/            # Proyectos de hogar, partidas y cotizaciones con fotos
    ├── reportes/             # Gráficos de distribución, comparativas y exportación CSV
    ├── auditoria/            # Bitácora inmutable consultable con diff visual
    └── ajustes/              # Moneda, categorías, PIN, respaldo y restauración
```

Cada feature contiene estrictamente sus capas:
- `domain/`: Entidades de negocio, Value Objects y casos de uso.
- `data/`: Repositorios y adaptadores de Drift.
- `presentation/`: Pantallas optimizadas para tablet, controladores/providers y widgets de la vista.

---

## 🗄️ Modelo de Datos (SQLite / Drift)

Todas las tablas cuentan con `id` autoincremental, `creadoEn` y `actualizadoEn`. Montos siempre en céntimos (`int`).

1. **Cuentas:** `nombre`, `tipo` *(efectivo, banco, ahorro, tarjeta, otro)*, `saldoInicialCent`, `activa`, `color`, `icono`.
2. **Categorias:** `nombre`, `tipo` *(ingreso, gastoFijo, gastoVariable, proyecto)*, `icono`, `color`, `esSistema`, `activa`.
3. **Movimientos:** `fecha`, `tipo` *(ingreso, gasto, transferencia)*, `montoCent`, `cuentaOrigenId`, `cuentaDestinoId` *(transferencias)*, `categoriaId`, `descripcion`, `notas`, `gastoFijoPagoId`, `partidaId`, `anulado`, `anuladoEn`, `motivoAnulacion`.
4. **GastosFijos (Plantillas):** `nombre`, `montoEstimadoCent`, `categoriaId`, `cuentaPagoId`, `diaVencimiento` *(1-31)*, `frecuencia`, `fechaInicio`, `fechaFin`, `activo`.
5. **GastosFijosPagos (Instancias Mensuales):** `gastoFijoId`, `periodo` *(yyyy-MM)*, `montoEsperadoCent`, `estado` *(pendiente, pagado, omitido)*, `movimientoId`, `fechaVencimiento`.
6. **IngresosFijos (Plantillas):** `nombre`, `montoEstimadoCent`, `cuentaId`, `diaCobro`, `frecuencia`, `activo`.
7. **IngresosFijosCobros (Instancias Mensuales):** Análoga a gastos fijos para ingresos esperados.
8. **PresupuestosMensuales:** `periodo` *(yyyy-MM)*, `categoriaId`, `montoCent`. Clave única `(periodo, categoriaId)`.
9. **Proyectos:** `nombre`, `descripcion`, `tipo` *(decoracion, construccion, arreglo, mobiliario, otro)*, `estado`, `presupuestoObjetivoCent`, `fechaInicioEstimada`, `fechaFinEstimada`, `prioridad`.
10. **PartidasProyecto:** `proyectoId`, `nombre`, `descripcion`, `presupuestoCent`, `cotizacionElegidaId`, `estado`.
11. **Cotizaciones:** `partidaId`, `proveedor`, `contacto`, `montoCent`, `fecha`, `vigenteHasta`, `notas`, `fotoRutaRelativa`, `elegida`.
12. **Auditoria:** `id`, `fechaHora`, `entidad`, `entidadId`, `accion` *(crear, editar, anular, restaurar, etc.)*, `valorAnteriorJson`, `valorNuevoJson`, `resumen`.
13. **Ajustes:** Configuración clave/valor (`moneda`, `pinHash`, `salt`, `ultimoRespaldo`, etc.).

---

## 💻 Guía de Desarrollo Local

### Requisitos Previos
- **Flutter SDK:** $\ge 3.38.0$ (Canal Stable).
- **Dart SDK:** $\ge 3.10.0$.
- Android Studio / VS Code con extensiones de Flutter y Dart.

### Instalación
1. Ubícate en el directorio del proyecto:
   ```bash
   cd C:\Users\ANDY\source\repos\nido
   ```
2. Descarga e instala las dependencias:
   ```bash
   flutter pub get
   ```
3. Ejecuta el análisis estático y pruebas:
   ```bash
   flutter analyze
   flutter test
   ```

---

## ⚙️ Cómo Ejecutar build_runner

Drift genera código tipado de base de datos (`app_database.g.dart`). Para generar o regenerar este código:

### Ejecución Única (Recomendada al actualizar tablas o DAOs)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Modo Escucha Activa (Durante desarrollo de persistencia)
```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## 📱 Cómo Generar APK y AAB para Android Tablet

Dado que Nido es una aplicación estrictamente local, la compilación de producción para Android genera un paquete seguro y liviano:

### 1. Generar APK de Producción (Release)
Para generar un APK optimizado por arquitectura de procesador:
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
Ubicación:
```text
build/app/outputs/flutter-apk/app-release.apk
```

### 2. Generar Android App Bundle (AAB)
Si se desea empaquetar en formato bundle para distribución en Play Store o tiendas privadas:
```bash
flutter build appbundle --release
```
Ubicación:
```text
build/app/outputs/bundle/release/app-release.aab
```

> **Verificación de Seguridad:** Puedes verificar que el APK final no incluye permisos de red inspeccionando el paquete con Android Asset Packaging Tool (`aapt dump permissions app-release.apk`).

---

## 🔒 Respaldo, Restauración y Seguridad

### 1. Respaldo Autónomo (.zip)
Nido genera un archivo comprimido portátil con el siguiente contenido:
```text
nido_backup_2026-10-10_1830.zip
├── nido.sqlite           # Base de datos SQLite íntegra
├── backup_meta.json      # Versión del esquema, fecha de exportación y hash de integridad
└── fotos/                # Copia de las fotos de cotizaciones físicas
```
- Se puede guardar en una memoria USB, carpeta local elegida por el usuario o compartir vía `share_plus`.

### 2. Restauración Segura
- **Validación previa:** Comprueba compatibilidad de la versión del esquema SQLite.
- **Copia de seguridad preventiva:** Crea automáticamente una copia de la base actual antes de reemplazarla por el respaldo importado.
- Si ocurre algún error en la descompresión, la base de datos se restaura a su estado original sin pérdida de datos.

### 3. Seguridad Local (PIN y Biometría)
- El PIN nunca se almacena en texto plano: se genera un hash criptográfico SHA-256 / PBKDF2 combinado con un `salt` aleatorio único por instalación.
- El hash y el salt se resguardan en `flutter_secure_storage` (KeyStore en Android).
- Soporte para autenticación biométrica (`local_auth`) al iniciar o regresar de segundo plano.

---

## 🚀 Hoja de Ruta por Fases

- [x] **Fase 0: Scaffolding, Base Tablet y Lints**
  - Entorno configurado, dependencias resueltas, AndroidManifest sin red, tema M3, layout dual y pruebas base en verde.
- [ ] **Fase 1: Motor de Dominio, Money y Drift con Auditoría**
  - Value Object `Money`, 12 tablas SQLite, índices, `AuditedWriter`, seeds de categorías y tests unitarios.
- [ ] **Fase 2: Cuentas, Movimientos y Anulación Lógica**
  - Saldos dinámicos, transferencias, anulación justificada y vistas Tablet Master-Detail.
- [ ] **Fase 3: Gastos e Ingresos Fijos & Presupuestos**
  - Generación mensual idempotente, acción "Marcar Pagado" y alertas presupuestarias 80%/100%.
- [ ] **Fase 4: Proyectos del Hogar & Cotizaciones con Fotos**
  - Partidas, fotos de presupuestos en sandbox y comparador con resaltado del menor precio.
- [ ] **Fase 5: Dashboard del Hogar & Reportes Visuales**
  - Métricas ejecutivas, gráficos `fl_chart` y exportación a CSV.
- [ ] **Fase 6: Bitácora de Auditoría, PIN y Respaldo ZIP**
  - Visor de diferencias (*diff*), bloqueo biométrico/PIN y respaldo/restauración `.zip`.
- [ ] **Fase 7: Onboarding en 3 Pasos, Ajustes y Datos Demo**
  - Flujo de bienvenida inicial y generador de datos de prueba.
- [ ] **Fase 8: QA Integral Tablet, Tests Completos y Cierre**

---

*Desarrollado con dedicación para cuidar la tranquilidad económica de tu hogar.*
