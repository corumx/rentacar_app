import 'package:flutter/material.dart';
import '../../../../data/models/delivery.dart';
import '../../../../data/repositories/delivery_repository.dart';
import '../../../../data/repositories/reservation_repository.dart';
import '../../../../data/repositories/vehicle_repository.dart';
import '../../../../domain/services/delivery_service.dart';

class DeliveryFormScreen extends StatefulWidget {
  const DeliveryFormScreen({super.key});

  @override
  State<DeliveryFormScreen> createState() => _DeliveryFormScreenState();
}

class _DeliveryFormScreenState extends State<DeliveryFormScreen> {
  final deliveryRepo = DeliveryRepository();
  final reservationRepo = ReservationRepository();
  final vehicleRepo = VehicleRepository();

  String? selectedReservationId;
  String? observaciones;
  int? kilometrajeFinal;

  void _guardarEntrega() {
    if (selectedReservationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar una reserva')),
      );
      return;
    }

    final entrega = Delivery(
      reservationId: selectedReservationId!,
      fechaEntregaReal: DateTime.now(),
      observaciones: observaciones,
      kilometrajeFinal: kilometrajeFinal,
    );

    final service = DeliveryService(
      deliveryRepo: deliveryRepo,
      reservationRepo: reservationRepo,
      vehicleRepo: vehicleRepo,
    );

    final exito = service.registrarEntrega(entrega);

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrega registrada con éxito')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: la reserva no existe o ya fue entregada')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Solo mostrar reservas activas
    final reservasActivas =
        reservationRepo.all().where((r) => r.activa == true).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Entrega'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Reserva a entregar'),
                items: reservasActivas.map((r) {
                  return DropdownMenuItem(
                    value: r.id,
                    child: Text('Reserva ${r.id} — Vehículo: ${r.vehicleId}'),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => selectedReservationId = value),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Observaciones'),
                onChanged: (value) => observaciones = value,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Kilometraje final'),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    kilometrajeFinal = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar Entrega'),
                onPressed: _guardarEntrega,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
