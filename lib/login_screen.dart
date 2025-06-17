import 'package:flutter/material.dart';
import 'package:app/signup_screen.dart';
import 'package:app/welcome_screen.dart';
import 'package:app/dispositivos_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String globalUserId = '';
String globalUserName = '';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool passwordobscure = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> logIn() async {
    var url = Uri.parse("http://10.0.2.2/api/login.php");
    var respuesta = await http.post(url, body: {
      "email": emailController.text,
      "password": passwordController.text,
    });

    var datos = jsonDecode(respuesta.body);
    print(datos["mensaje"] ?? datos["error"]);

    if (datos["mensaje"] == "Inicio de sesión exitoso") {
      globalUserId = datos["id"] ?? '';
      globalUserName = datos["nombre"] ?? '';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const dispositivosScreen()),
      );
    } else {
      showErrorDialog("Invalid email or password!");
    }
  }
//funcion para mostrar un mensaje de error
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height*0.8,
        ),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 39, 112),
                    Color.fromARGB(255, 69, 196, 169)
                  ],
                ),
              ),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Image.asset(
                  'assets/Logo sin fondo.png',
                  height: 100,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 230.0, bottom: 60, left: 15, right: 15),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.check, color: Colors.grey),
                          label: Text(
                            'User',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 39, 112),
                            ),
                          ),
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: passwordobscure,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(passwordobscure ? Icons.visibility_off : Icons.visibility),
                            color: Colors.grey,
                            onPressed: () {
                              setState(() {
                                passwordobscure = !passwordobscure;
                              });
                            },
                          ),
                          label: const Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 39, 112),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 90),
                      SizedBox(
                        height: 55,
                        width: 300,
                        child: ElevatedButton(
                          onPressed: logIn,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 0, 39, 112),
                                  Color.fromARGB(255, 69, 196, 169)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                "SIGN IN",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const signupScreen()),
                                );
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
