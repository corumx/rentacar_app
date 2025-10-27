import '../models/delivery.dart';

class DeliveryRepository {
  // 🔹 Lista estática compartida por toda la app
  static final List<Delivery> _items = [];

  List<Delivery> all() => List.unmodifiable(_items);

  Delivery? byId(String id) {
    try {
      return _items.firstWhere((d) => d.reservationId == id);
    } catch (e) {
      return null;
    }
  }

  void add(Delivery d) => _items.add(d);

  void update(Delivery d) {
    final idx = _items.indexWhere((x) => x.reservationId == d.reservationId);
    if (idx >= 0) _items[idx] = d;
  }

  void remove(String idReserva) =>
      _items.removeWhere((d) => d.reservationId == idReserva);
}
