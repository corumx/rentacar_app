class Reservation {
  final String id;
  final String clientId;
  final String vehicleId;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  bool activa; // true hasta que haya entrega

  Reservation({
    required this.id,
    required this.clientId,
    required this.vehicleId,
    required this.fechaInicio,
    required this.fechaFin,
    this.activa = true,
  });
}
