import '../../data/models/reservation.dart';
import '../../data/models/vehicle.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../data/repositories/reservation_repository.dart';

class BookingService {
  final VehicleRepository vehicleRepo;
  final ReservationRepository reservationRepo;

  BookingService(this.vehicleRepo, this.reservationRepo);

  /// Crea una reserva solo si el vehículo está disponible.
  /// Devuelve true si se pudo crear, false si no.
  bool createReservation(Reservation r) {
    // Buscar el vehículo asociado
    final vehicle = vehicleRepo.byId(r.vehicleId);

    // Si no existe o no está disponible, no se puede reservar
    if (vehicle == null || vehicle.disponible == false) {
      return false;
    }

    // Agregar la reserva
    reservationRepo.add(r);

    // Marcar el vehículo como no disponible
    final actualizado = Vehicle(
      id: vehicle.id,
      marca: vehicle.marca,
      modelo: vehicle.modelo,
      anio: vehicle.anio,
      disponible: false,
    );
    vehicleRepo.update(actualizado);

    return true;
  }
}
