import '../../data/models/delivery.dart';
import '../../data/models/vehicle.dart';
import '../../data/repositories/delivery_repository.dart';
import '../../data/repositories/reservation_repository.dart';
import '../../data/repositories/vehicle_repository.dart';

class DeliveryService {
  final DeliveryRepository deliveryRepo;
  final ReservationRepository reservationRepo;
  final VehicleRepository vehicleRepo;

  DeliveryService({
    required this.deliveryRepo,
    required this.reservationRepo,
    required this.vehicleRepo,
  });

  /// Registra una entrega: marca reserva como inactiva y vehículo como disponible.
  bool registrarEntrega(Delivery entrega) {
    final reserva = reservationRepo.byId(entrega.reservationId);
    if (reserva == null || reserva.activa == false) {
      return false; // No existe o ya fue entregada
    }

    // Registrar entrega
    deliveryRepo.add(entrega);

    // Marcar reserva como finalizada
    reserva.activa = false;
    reservationRepo.update(reserva);

    // Actualizar vehículo
    final vehicle = vehicleRepo.byId(reserva.vehicleId);
    if (vehicle != null) {
      final actualizado = Vehicle(
        id: vehicle.id,
        marca: vehicle.marca,
        modelo: vehicle.modelo,
        anio: vehicle.anio,
        disponible: true, // vuelve a estar disponible
      );
      vehicleRepo.update(actualizado);
    }

    return true;
  }
}
