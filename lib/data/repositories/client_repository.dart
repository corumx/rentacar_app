import '../models/client.dart';
import 'seed_data.dart';

class ClientRepository {
  // 👇 Esta lista es estática: se comparte entre todas las pantallas
  static final List<Client> _items = [...SeedData.clients];

  /// Devuelve todos los clientes, opcionalmente filtrando por nombre o documento
  List<Client> all({String? filtro}) {
    if (filtro == null || filtro.isEmpty) return List.unmodifiable(_items);
    final f = filtro.toLowerCase();
    return _items
        .where((c) =>
            c.nombre.toLowerCase().contains(f) ||
            c.apellido.toLowerCase().contains(f) ||
            c.documento.toLowerCase().contains(f))
        .toList(growable: false);
  }

  /// Busca un cliente por ID y devuelve null si no se encuentra
  Client? byId(String id) {
    try {
      return _items.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Agrega un nuevo cliente
  void add(Client c) => _items.add(c);

  /// Actualiza un cliente existente
  void update(Client c) {
    final idx = _items.indexWhere((x) => x.id == c.id);
    if (idx >= 0) _items[idx] = c;
  }

  /// Elimina un cliente por su ID
  void remove(String id) => _items.removeWhere((c) => c.id == id);
}
