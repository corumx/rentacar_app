import '../models/vehicle.dart';
import 'seed_data.dart';

class VehicleRepository {
  // Lista estática compartida entre pantallas
  static final List<Vehicle> _items = [...SeedData.vehicles];

  /// Devuelve todos los vehículos o los que coincidan con el filtro
  List<Vehicle> all({String? filtro}) {
    if (filtro == null || filtro.isEmpty) return List.unmodifiable(_items);

    final f = filtro.toLowerCase();
    return _items
        .where((v) =>
            v.marca.toLowerCase().contains(f) ||
            v.modelo.toLowerCase().contains(f) ||
            v.anio.toString().contains(f))
        .toList(growable: false);
  }

  /// Busca un vehículo por ID (devuelve null si no existe)
  Vehicle? byId(String id) {
    try {
      return _items.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Agrega un nuevo vehículo
  void add(Vehicle v) => _items.add(v);

  /// Actualiza un vehículo existente
  void update(Vehicle v) {
    final idx = _items.indexWhere((x) => x.id == v.id);
    if (idx >= 0) _items[idx] = v;
  }

  /// Elimina un vehículo por ID
  void remove(String id) => _items.removeWhere((v) => v.id == id);
}
