/// Representa una entrada de bitácora para auditar cambios en el sistema.
class AuditEntry {
  const AuditEntry({
    required this.entidad,
    required this.entidadId,
    required this.accion,
    this.valorAnterior,
    this.valorNuevo,
    required this.resumen,
  });

  /// Nombre de la entidad modificada (ej. 'Movimiento', 'Cuenta', 'GastoFijo', etc.).
  final String entidad;

  /// Identificador primario de la entidad.
  final int entidadId;

  /// Tipo de acción ejecutada ('crear', 'editar', 'anular', 'restaurar', 'importar', etc.).
  final String accion;

  /// Estado de los campos antes del cambio (null si es creación).
  final Map<String, dynamic>? valorAnterior;

  /// Estado de los campos después del cambio (null si es eliminación/anulación total).
  final Map<String, dynamic>? valorNuevo;

  /// Resumen en lenguaje natural legible para el usuario.
  final String resumen;
}
