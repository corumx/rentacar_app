import '../models/vehicle.dart';
import '../models/client.dart';

class SeedData {
  static List<Vehicle> vehicles = [
    Vehicle(id: 'V1', marca: 'Toyota', modelo: 'Corolla', anio: 2020, disponible: true),
    Vehicle(id: 'V2', marca: 'Hyundai', modelo: 'HB20', anio: 2022, disponible: true),
  ];

  static List<Client> clients = [
    Client(id: 'C1', nombre: 'Ana', apellido: 'Gómez', documento: '4567890'),
    Client(id: 'C2', nombre: 'Luis', apellido: 'Pérez', documento: '1234567'),
  ];
}
