import 'package:flutter/material.dart';
import '../../../../data/models/client.dart';
import '../../../../data/repositories/client_repository.dart';
import '../../../../core/app_routes.dart';

class ClientsListScreen extends StatefulWidget {
  const ClientsListScreen({super.key});

  @override
  State<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  final clientRepo = ClientRepository();
  final _searchCtrl = TextEditingController();

  void _goToForm({Client? client}) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.clientForm,
      arguments: client,
    );
    setState(() {}); // refresca al volver
  }

  void _deleteClient(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: const Text('¿Deseas eliminar este cliente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              clientRepo.remove(id);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cliente eliminado')),
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
    final filtro = _searchCtrl.text.trim();
    final clients = clientRepo.all(filtro: filtro);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
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
                hintText: 'Buscar por nombre, apellido o documento...',
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

          // 📊 Total mostrado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mostrando ${clients.length} cliente${clients.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

          // 📋 Lista de clientes
          Expanded(
            child: clients.isEmpty
                ? const Center(
                    child: Text('No hay clientes registrados.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: clients.length,
                    itemBuilder: (_, i) {
                      final c = clients[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading:
                              const Icon(Icons.person, color: Colors.indigo),
                          title: Text('${c.nombre} ${c.apellido}'),
                          subtitle: Text('Documento: ${c.documento}'),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') _goToForm(client: c);
                              if (value == 'delete') _deleteClient(c.id);
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
