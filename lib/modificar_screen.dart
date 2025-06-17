import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/login_screen.dart';
import 'package:app/dispositivos_screen.dart';

int selectedNumero = 1;

class ModificarScreen extends StatefulWidget {
  const ModificarScreen({super.key});

  @override
  State<ModificarScreen> createState() => _ModificarScreenState();
}

class _ModificarScreenState extends State<ModificarScreen> {
  List<String> dispositivos = [];
  String? selectedDispositivo;

  final List<TextEditingController> hourControllers =
      List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> amountControllers =
      List.generate(4, (_) => TextEditingController());

  bool isLoading = false;

  Future<void> _fetchDispositivos() async {
    final url = Uri.parse('http://10.0.2.2/api/obtener_dispositivos.php');
    try {
      final response = await http.post(url, body: {
        'usuario': globalUserId.toString(),
      });
      final data = jsonDecode(response.body);
      if (data['success']) {
        setState(() {
          dispositivos = List<String>.from(data['dispositivos']);
          if (dispositivos.isNotEmpty) selectedDispositivo = dispositivos.first;
        });
      }
    } catch (_) {}
  }

  Future<void> _modificarDispositivo() async {
    final url = Uri.parse('http://10.0.2.2/api/modificar_dispositivo.php');
    try {
      final body = {
        'nombre': selectedDispositivo!,
        'veces': selectedNumero.toString(),
        'usuario': globalUserId.toString(),
      };

      for (int i = 0; i < selectedNumero; i++) {
        body['hora${i + 1}'] = hourControllers[i].text.trim();
        body['monto${i + 1}'] = amountControllers[i].text.trim();
      }

      final response = await http.post(url, body: body);
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  List<Widget> _buildDynamicFields() {
    return List.generate(selectedNumero, (i) {
      return Column(children: [
        TextField(
          controller: hourControllers[i],
          keyboardType: TextInputType.number,
          maxLength: 5,
          decoration: InputDecoration(
            labelText: 'Hora ${i + 1} (HH:MM)',
            border: OutlineInputBorder(),
            counterText: '',
          ),
          onChanged: (value) {
            if (value.length == 2 && !value.contains(':')) {
              hourControllers[i].text = '$value:';
              hourControllers[i].selection = TextSelection.fromPosition(
                TextPosition(offset: hourControllers[i].text.length),
              );
            }
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: amountControllers[i],
          keyboardType: TextInputType.number,
          maxLength: 3,
          decoration: InputDecoration(
            labelText: 'Cantidad ${i + 1}',
            border: OutlineInputBorder(),
            counterText: '',
          ),
        ),
        const SizedBox(height: 20),
      ]);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchDispositivos();
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
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => const dispositivosScreen()));
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(children: [
                const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.person, color: Colors.white, size: 35),
                ),
                const SizedBox(width: 5),
                Text(globalUserName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              ),
            ),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(40),
              ),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text(
                    'Modificar dispositivo',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 39, 112),
                    ),
                  ),
                  const SizedBox(height: 30),
                  DropdownButtonFormField<String>(
                    value: selectedDispositivo,
                    items: dispositivos
                        .map((device) => DropdownMenuItem(
                              value: device,
                              child: Text(device),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDispositivo = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Seleccionar dispositivo',
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<int>(
                    value: selectedNumero,
                    items: List.generate(4, (i) => i + 1)
                        .map((n) => DropdownMenuItem(
                              value: n,
                              child: Text('$n'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedNumero = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Seleccionar número de veces',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._buildDynamicFields(),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: isLoading ? null : _modificarDispositivo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 39, 112),
                      foregroundColor: Colors.white,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Guardar cambios'),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
