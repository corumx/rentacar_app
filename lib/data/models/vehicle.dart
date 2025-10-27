class Vehicle {
  final String id;
  String marca;
  String modelo;
  int anio;
  bool disponible; // true = "Sí", false = "No"

  Vehicle({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    this.disponible = true,
  });
}
