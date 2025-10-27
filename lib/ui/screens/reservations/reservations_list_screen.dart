import 'package:flutter/material.dart';
import '../../../../data/repositories/reservation_repository.dart';
import '../../../../data/models/reservation.dart';
import '../../../../core/app_routes.dart';

class ReservationsListScreen extends StatefulWidget {
  const ReservationsListScreen({super.key});

  @override
  State<ReservationsListScreen> createState() => _ReservationsListScreenState();
}

class _ReservationsListScreenState extends State<ReservationsListScreen> {
  final repo = ReservationRepository();

  @override
  Widget build(BuildContext context) {
    final List<Reservation> reservations = repo.all();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
        centerTitle: true,
      ),
      body: reservations.isEmpty
          ? const Center(child: Text('No hay reservas registradas.'))
          : ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final r = reservations[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.assignment),
                    title: Text('Reserva ${r.id}'),
                    subtitle: Text(
                      'Cliente: ${r.clientId} • Vehículo: ${r.vehicleId}\n'
                      '${r.fechaInicio.toLocal()} - ${r.fechaFin.toLocal()}',
                    ),
                    trailing: r.activa
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.cancel, color: Colors.red),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Espera a que el formulario termine antes de actualizar
          await Navigator.pushNamed(context, AppRoutes.reservationForm);
          setState(() {}); // 🔹 refresca la lista al volver
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
