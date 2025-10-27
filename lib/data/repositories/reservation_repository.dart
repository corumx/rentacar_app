import '../models/reservation.dart';

class ReservationRepository {
  static final ReservationRepository _instance = ReservationRepository._internal();
  factory ReservationRepository() => _instance;
  ReservationRepository._internal();

  final List<Reservation> _items = [];

  List<Reservation> all() => List.unmodifiable(_items);

  Reservation? byId(String id) {
    try {
      return _items.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  void add(Reservation r) => _items.add(r);

  void update(Reservation r) {
    final idx = _items.indexWhere((x) => x.id == r.id);
    if (idx >= 0) _items[idx] = r;
  }

  void remove(String id) => _items.removeWhere((r) => r.id == id);
}
