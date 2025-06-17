import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/login_screen.dart';
import 'package:app/dispositivos_screen.dart';

class EliminarDispositivoScreen extends StatefulWidget {
  const EliminarDispositivoScreen({super.key});

  @override
  State<EliminarDispositivoScreen> createState() => _EliminarDispositivoScreenState();
}

class _EliminarDispositivoScreenState extends State<EliminarDispositivoScreen> {
  List<String> dispositivos = [];
  String? selectedDevice;
  bool isLoading = false;

  Future<void> fetchDispositivos() async {
    final url = Uri.parse('http://10.0.2.2/api/obtener_dispositivos.php');
    try {
      final response = await http.post(url, body: {
        'usuario': globalUserId.toString(),
      });

      final data = jsonDecode(response.body);
      if (data['success']) {
        setState(() {
          dispositivos = List<String>.from(data['dispositivos']);
          selectedDevice = dispositivos.isNotEmpty ? dispositivos[0] : null;
        });
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener dispositivos: $e')),
      );
    }
  }

  Future<void> eliminarDispositivo(String nombre) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar dispositivo?'),
        content: Text('¿Estás seguro de que deseas eliminar "$nombre"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirm != true) return;

    final url = Uri.parse('http://10.0.2.2/api/eliminar_dispositivos.php');
    try {
      final response = await http.post(url, body: {
        'usuario': globalUserId.toString(),
        'nombre': nombre,
      });

      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));

      if (data['success']) {
        await fetchDispositivos();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDispositivos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 39, 112), Color.fromARGB(255, 69, 196, 169)],
            ),
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const dispositivosScreen()));
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(children: [
                const Icon(Icons.person, color: Colors.white, size: 30),
                const SizedBox(width: 5),
                Text(globalUserName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ]),
            ),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Eliminar dispositivo',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 39, 112))),
                const SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  value: selectedDevice,
                  items: dispositivos
                      .map((device) => DropdownMenuItem(value: device, child: Text(device)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedDevice = value),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Seleccionar dispositivo a eliminar',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: selectedDevice != null
                      ? () => eliminarDispositivo(selectedDevice!)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 39, 112),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Eliminar'),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
