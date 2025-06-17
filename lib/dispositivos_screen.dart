import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import 'package:app/agregar_screen.dart';
import 'package:app/modificar_screen.dart';
import 'package:app/eliminar_screen.dart';
import 'package:app/welcome_screen.dart';
import 'package:app/login_screen.dart';

class dispositivosScreen extends StatefulWidget {
  const dispositivosScreen({super.key});

  @override
  State<dispositivosScreen> createState() => _dispositivosScreenState();
}

class _dispositivosScreenState extends State<dispositivosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: PopupMenuButton<String>(
         
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              if (value == 'Eliminar cuenta') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirmar eliminación"),
                      content: const Text("¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () async {
                            () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                                );
                                
                              };
                            final url = Uri.parse("http://10.0.2.2/api/eliminar_usuario.php");

                            try {
                              final response = await http.post(url, body: {
                                'user_id': globalUserId.toString(),
                              });
                              final data = jsonDecode(response.body);

                              if (data['success']) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(data['message'])),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: ${data['message']}")),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error de conexión: $e")),
                              );
                            }
                          },
                          child: const Text("Eliminar"),
                        ),
                      ],
                    );
                  },
                );
              }
              else if (value == 'Cerrar sesión') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirmar cierre de sesión"),
                          content: const Text("¿Estás seguro de que quieres cerrar sesión?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                                );
                                
                              },
                              child: const Text("Aceptar"),
                            ),
                          ],
                        );
                      },
                    );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Eliminar cuenta',
                child: Text('Eliminar cuenta'),
              ),
              const PopupMenuItem<String>(
                value: 'Cerrar sesión',
                child: Text('Cerrar sesión'),
              ),
            ],
      ),
        actions: [Padding(
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
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 39, 112),
                  Color.fromARGB(255, 69, 196, 169)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/Nombre sin fondo.png', 
                    height: 150, 
                  ),
                  const SizedBox(height: 45),
                  SizedBox(
                    width: 300.0,
                    height: 65.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AgregarScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, 
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                      child: const Text(
                        "AGREGAR",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color.fromARGB(255, 0, 39, 112), 
                        ),
                      ),
                    ), 
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    width: 300.0,
                    height: 65.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ModificarScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, 
                      padding: const EdgeInsets.all(10), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40), 
                      ),
                    ),
                      child: const Text(
                        "MODIFICAR",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color.fromARGB(255, 0, 39, 112), 
                        ),
                      ),
                    ), 
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    width: 300.0,
                    height: 65.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EliminarDispositivoScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, 
                      padding: const EdgeInsets.all(10), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                      child: const Text(
                        "ELIMINAR",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color.fromARGB(255, 0, 39, 112), 
                        ),
                      ),
                    ), 
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
    );
  }
}
