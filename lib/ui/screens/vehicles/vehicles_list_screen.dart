import 'package:flutter/material.dart';
import '../../../../data/models/vehicle.dart';
import '../../../../data/repositories/vehicle_repository.dart';
import '../../../../core/app_routes.dart';

class VehiclesListScreen extends StatefulWidget {
  const VehiclesListScreen({super.key});

  @override
  State<VehiclesListScreen> createState() => _VehiclesListScreenState();
}

class _VehiclesListScreenState extends State<VehiclesListScreen> {
  final vehicleRepo = VehicleRepository();
  final _searchCtrl = TextEditingController();

  void _goToForm({Vehicle? vehicle}) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.vehicleForm,
      arguments: vehicle,
    );
    setState(() {}); // refrescar lista al volver
  }

  void _deleteVehicle(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar vehículo'),
        content: const Text('¿Deseas eliminar este vehículo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              vehicleRepo.remove(id);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vehículo eliminado')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Aplicar filtro de búsqueda
    final filtro = _searchCtrl.text.trim();
    final vehicles = vehicleRepo.all(filtro: filtro);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehículos'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToForm(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // 🔍 Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar por marca o modelo...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // 👇 Cantidad visible
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mostrando ${vehicles.length} vehículo${vehicles.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

          // 📋 Lista de vehículos
          Expanded(
            child: vehicles.isEmpty
                ? const Center(
                    child: Text('No hay vehículos registrados.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: vehicles.length,
                    itemBuilder: (_, i) {
                      final v = vehicles[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Icon(
                            v.disponible
                                ? Icons.directions_car
                                : Icons.car_rental,
                            color: v.disponible ? Colors.green : Colors.grey,
                            size: 28,
                          ),
                          title: Text('${v.marca} ${v.modelo} (${v.anio})'),
                          subtitle: Text(
                            v.disponible ? 'Disponible' : 'No disponible',
                            style: TextStyle(
                              color:
                                  v.disponible ? Colors.green : Colors.redAccent,
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') _goToForm(vehicle: v);
                              if (value == 'delete') _deleteVehicle(v.id);
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.indigo),
                                    SizedBox(width: 8),
                                    Text('Editar'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Eliminar'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
