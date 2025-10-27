import 'package:flutter/material.dart';
import '../../../../data/repositories/vehicle_repository.dart';
import '../../../../data/repositories/client_repository.dart';
import '../../../../data/repositories/reservation_repository.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final vehicleRepo = VehicleRepository();
  final reservationRepo = ReservationRepository();
  final clientRepo = ClientRepository();

  int reservasActivas = 0;
  int vehiculosDisponibles = 0;
  String clienteTop = "Ninguno";
  int cantidadReservasTop = 0;

  @override
  void initState() {
    super.initState();
    _actualizarStats();
  }

  void _actualizarStats() {
    final reservas = reservationRepo.all();
    final vehiculos = vehicleRepo.all();
    final clientes = clientRepo.all();

    // 🔹 Reservas activas
    reservasActivas = reservas.where((r) => r.activa).length;

    // 🔹 Vehículos disponibles
    vehiculosDisponibles = vehiculos.where((v) => v.disponible).length;

    // 🔹 Cliente con más reservas
    final Map<String, int> conteo = {};
    for (var r in reservas) {
      conteo[r.clientId] = (conteo[r.clientId] ?? 0) + 1;
    }

    if (conteo.isNotEmpty) {
      final idTop = conteo.keys.firstWhere(
        (k) => conteo[k] == conteo.values.reduce((a, b) => a > b ? a : b),
      );
      final cliente = clientes.firstWhere((c) => c.id == idTop);
      clienteTop = "${cliente.nombre} ${cliente.apellido}";
      cantidadReservasTop = conteo[idTop]!;
    } else {
      clienteTop = "Ninguno";
      cantidadReservasTop = 0;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _actualizarStats, // 🔁 botón manual para refrescar
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            StatCard(
              color: Colors.orange.shade100,
              icon: Icons.assignment,
              title: 'Reservas Activas',
              value: reservasActivas.toString(),
              textColor: Colors.orange.shade800,
            ),
            const SizedBox(height: 12),
            StatCard(
              color: Colors.green.shade100,
              icon: Icons.directions_car,
              title: 'Vehículos Disponibles',
              value: vehiculosDisponibles.toString(),
              textColor: Colors.green.shade800,
            ),
            const SizedBox(height: 12),
            StatCard(
              color: Colors.blue.shade100,
              icon: Icons.person,
              title: 'Cliente con Más Reservas',
              value: cantidadReservasTop > 0
                  ? "$clienteTop ($cantidadReservasTop)"
                  : "Ninguno",
              textColor: Colors.blue.shade800,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget para mostrar cada tarjeta de estadística
class StatCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final Color textColor;

  const StatCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: textColor.withOpacity(0.15),
            radius: 24,
            child: Icon(icon, color: textColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
