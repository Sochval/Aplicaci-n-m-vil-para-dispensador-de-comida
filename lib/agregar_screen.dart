
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/login_screen.dart';
import 'package:app/dispositivos_screen.dart';

int selectedNumero = 1;

class AgregarScreen extends StatefulWidget {
  const AgregarScreen({super.key});

  @override
  State<AgregarScreen> createState() => _AgregarScreenState();
}

class _AgregarScreenState extends State<AgregarScreen> {
  List<String> dispositivos = ['Agregar dispositivo'];
  String? selectedDispositivo = 'Agregar dispositivo';

  final TextEditingController newDeviceController = TextEditingController();
  final TextEditingController macController = TextEditingController();
  final List<TextEditingController> hourControllers =
      List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> amountControllers =
      List.generate(4, (_) => TextEditingController());

  bool isLoading = false;

  Future<void> _sendDeviceToServer() async {
    final url = Uri.parse('http://10.0.2.2/api/guardar_dispositivo.php');

    try {
      final body = {
        'nombre': newDeviceController.text.trim(),
        'veces': selectedNumero.toString(),
        'usuario': globalUserId.toString(),
        'mac': macController.text.trim(),
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
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }
  //funcion para validar la hora
  bool _validarHora(String hora) {
  hora = hora.trim();
  final reg = RegExp(r'^\d{2}:\d{2}$');
  if (!reg.hasMatch(hora)) return false;

  final parts = hora.split(':');
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);

  return h != null && m != null && h >= 0 && h <= 23 && m >= 0 && m <= 59;
}


  void _addOrUpdateDispositivo() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    if (newDeviceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese un nombre')),
      );
      setState(() => isLoading = false);
      return;
    }
    if (macController.text.trim().isEmpty ||
      !RegExp(r’ˆ([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}\$’)
      .hasMatch(macController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
      content: Text(
      'Introduce una direccion MAC valida (formato: XX:XX:XX:XX:XX:XX)')),
      );
      setState(() => isLoading = false);
      return;
    }

    for (int i = 0; i < selectedNumero; i++) {
      final hora = hourControllers[i].text.trim();
      final monto = amountControllers[i].text.trim();

      if (hora.isEmpty || monto.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Complete hora y cantidad ${i + 1}')),
        );
        setState(() => isLoading = false);
        return;
      }

      if (!_validarHora(hora)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hora ${i + 1} inválida (HH:MM)')),
        );
        setState(() => isLoading = false);
        return;
      }

      final parsedMonto = int.tryParse(monto);
      if (parsedMonto == null || parsedMonto < 0 || parsedMonto > 999) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cantidad ${i + 1} inválida (0-999)')),
        );
        setState(() => isLoading = false);
        return;
      }
    }

    await _sendDeviceToServer();

    setState(() {
      dispositivos.add(newDeviceController.text.trim());
      selectedDispositivo = newDeviceController.text.trim();
      newDeviceController.clear();
      for (var c in hourControllers) c.clear();
      for (var c in amountControllers) c.clear();
      isLoading = false;
    });
  }

  List<Widget> _buildDynamicFields() {
    return List.generate(selectedNumero, (i) {
      return Column(
        children: [
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
        ],
      );
    });
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
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.person, color: Colors.white, size: 35),
                  ),
                  const SizedBox(width: 5),
                  Text(globalUserName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
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
                    'Agregar dispositivo',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 39, 112),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  TextField(
                      controller: newDeviceController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del nuevo dispositivo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: macController,
                    decoration: const InputDecoration(
                     labelText: 'Dirección MAC (formato XX:XX:XX:XX:XX:XX)',
                     border: OutlineInputBorder(),
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
                    onPressed: isLoading ? null : _addOrUpdateDispositivo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 39, 112),
                      foregroundColor: Colors.white,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Guardar'),
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
