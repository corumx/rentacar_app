import 'package:flutter/material.dart';
import '../../../../data/models/client.dart';
import '../../../../data/repositories/client_repository.dart';

class ClientFormScreen extends StatefulWidget {
  const ClientFormScreen({super.key});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final clientRepo = ClientRepository();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreCtrl;
  late TextEditingController _apellidoCtrl;
  late TextEditingController _documentoCtrl;
  String? _id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final client = ModalRoute.of(context)!.settings.arguments as Client?;
    _id = client?.id;
    _nombreCtrl = TextEditingController(text: client?.nombre ?? '');
    _apellidoCtrl = TextEditingController(text: client?.apellido ?? '');
    _documentoCtrl = TextEditingController(text: client?.documento ?? '');
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final client = Client(
        id: _id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreCtrl.text.trim(),
        apellido: _apellidoCtrl.text.trim(),
        documento: _documentoCtrl.text.trim(),
      );

      if (_id == null) {
        clientRepo.add(client);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Cliente registrado')));
      } else {
        clientRepo.update(client);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Cliente actualizado')));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _id != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Cliente' : 'Registrar Cliente'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el nombre' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _apellidoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el apellido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _documentoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Documento',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el documento' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(isEdit ? 'Guardar Cambios' : 'Registrar Cliente'),
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
