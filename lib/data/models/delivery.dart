class Delivery {
  final String reservationId;
  final DateTime fechaEntregaReal;
  String? observaciones;
  int? kilometrajeFinal;

  Delivery({
    required this.reservationId,
    required this.fechaEntregaReal,
    this.observaciones,
    this.kilometrajeFinal,
  });
}
