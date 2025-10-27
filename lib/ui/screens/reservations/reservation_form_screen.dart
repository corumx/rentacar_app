import 'package:flutter/material.dart';
import '../../../../data/models/reservation.dart';
import '../../../../data/repositories/client_repository.dart';
import '../../../../data/repositories/vehicle_repository.dart';
import '../../../../data/repositories/reservation_repository.dart';
import '../../../../domain/services/booking_service.dart';

class ReservationFormScreen extends StatefulWidget {
  const ReservationFormScreen({super.key});

  @override
  State<ReservationFormScreen> createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  final clientRepo = ClientRepository();
  final vehicleRepo = VehicleRepository(); // Singleton
  final reservationRepo = ReservationRepository(); // Singleton
  late final BookingService bookingService;

  String? selectedClientId;
  String? selectedVehicleId;
  DateTime? fechaInicio;
  DateTime? fechaFin;

  @override
  void initState() {
    super.initState();
    bookingService = BookingService(vehicleRepo, reservationRepo);
  }

  void _guardarReserva() {
    if (selectedClientId == null ||
        selectedVehicleId == null ||
        fechaInicio == null ||
        fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
      return;
    }

    final nuevaReserva = Reservation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clientId: selectedClientId!,
      vehicleId: selectedVehicleId!,
      fechaInicio: fechaInicio!,
      fechaFin: fechaFin!,
      activa: true,
    );

    final exito = bookingService.createReservation(nuevaReserva);

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva creada con éxito')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El vehículo no está disponible')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clients = clientRepo.all();
    final vehicles =
        vehicleRepo.all().where((v) => v.disponible == true).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Reserva'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Cliente'),
                items: clients.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text('${c.nombre} ${c.apellido}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedClientId = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Vehículo disponible'),
                items: vehicles.map((v) {
                  return DropdownMenuItem(
                    value: v.id,
                    child: Text('${v.marca} ${v.modelo}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedVehicleId = value),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.date_range),
                label: const Text('Seleccionar rango de fechas'),
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      fechaInicio = picked.start;
                      fechaFin = picked.end;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar Reserva'),
                onPressed: _guardarReserva,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
