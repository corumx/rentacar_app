import 'package:flutter/material.dart';
import '../../../../data/models/vehicle.dart';
import '../../../../data/repositories/vehicle_repository.dart';

class VehicleFormScreen extends StatefulWidget {
  const VehicleFormScreen({super.key});

  @override
  State<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen> {
  final vehicleRepo = VehicleRepository();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _marcaCtrl;
  late TextEditingController _modeloCtrl;
  late TextEditingController _anioCtrl;
  bool _disponible = true;
  String? _id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vehicle = ModalRoute.of(context)!.settings.arguments as Vehicle?;
    _id = vehicle?.id;
    _marcaCtrl = TextEditingController(text: vehicle?.marca ?? '');
    _modeloCtrl = TextEditingController(text: vehicle?.modelo ?? '');
    _anioCtrl = TextEditingController(
        text: vehicle?.anio != null ? vehicle!.anio.toString() : '');
    _disponible = vehicle?.disponible ?? true;
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final vehicle = Vehicle(
        id: _id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        marca: _marcaCtrl.text.trim(),
        modelo: _modeloCtrl.text.trim(),
        anio: int.parse(_anioCtrl.text.trim()),
        disponible: _disponible,
      );

      if (_id == null) {
        vehicleRepo.add(vehicle);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Vehículo registrado')));
      } else {
        vehicleRepo.update(vehicle);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Vehículo actualizado')));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _id != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Vehículo' : 'Registrar Vehículo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _marcaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese la marca' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _modeloCtrl,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el modelo' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _anioCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Año',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese el año';
                  final year = int.tryParse(v);
                  if (year == null || year < 2000 || year > DateTime.now().year) {
                    return 'Ingrese un año válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Disponible para alquiler'),
                value: _disponible,
                onChanged: (v) => setState(() => _disponible = v),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(isEdit ? 'Guardar Cambios' : 'Registrar Vehículo'),
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
