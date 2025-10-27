import 'package:flutter/material.dart';
import '../../../../data/repositories/delivery_repository.dart';
import '../../../../data/models/delivery.dart';
import '../../../../core/app_routes.dart';

class DeliveriesListScreen extends StatefulWidget {
  const DeliveriesListScreen({super.key});

  @override
  State<DeliveriesListScreen> createState() => _DeliveriesListScreenState();
}

class _DeliveriesListScreenState extends State<DeliveriesListScreen> {
  final repo = DeliveryRepository();

  @override
  Widget build(BuildContext context) {
    final List<Delivery> deliveries = repo.all();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entregas'),
        centerTitle: true,
      ),
      body: deliveries.isEmpty
          ? const Center(child: Text('No hay entregas registradas.'))
          : ListView.builder(
              itemCount: deliveries.length,
              itemBuilder: (context, index) {
                final d = deliveries[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.delivery_dining),
                    title: Text('Entrega de reserva ${d.reservationId}'),
                    subtitle: Text(
                      'Fecha: ${d.fechaEntregaReal}\n'
                      'Observaciones: ${d.observaciones ?? "-"}\n'
                      'Km final: ${d.kilometrajeFinal ?? 0}',
                    ),
                    trailing:
                        const Icon(Icons.check_circle, color: Colors.green),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.deliveryForm);
          setState(() {}); // 🔁 refresca la lista al volver
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
