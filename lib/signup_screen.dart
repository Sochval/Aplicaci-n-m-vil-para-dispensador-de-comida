
import 'package:app/login_screen.dart';
import 'package:app/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class signupScreen extends StatefulWidget {
   const signupScreen({super.key});


  @override
  State<signupScreen> createState() => _signupScreenState();
}


class _signupScreenState extends State<signupScreen> {
bool passwordobscure=true;
//controladores para leer los valores de los TextFields
final TextEditingController usernameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

bool _acceptedPolicy = false;

Future<void> registrarUsuario() async {
    var url = Uri.parse("http://10.0.2.2/api/registrar.php");
    var respuesta = await http.post(url, body: {
      "nombre": usernameController.text,
      "email": emailController.text,
      "password": passwordController.text,
    });

        var datos = jsonDecode(respuesta.body);

    if (datos["error"] != null) {
      showErrorDialog(datos["error"]);
    } else {
      showNoErrorDialog();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const loginScreen()),
      );
    }
  }

//funcion para comprobar formato del email
bool isValidEmail(String email) {
  String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regex = RegExp(emailPattern);
  return regex.hasMatch(email);
}




//función para validar todos los campos
void validateAndCreateAccount() {
  String username = usernameController.text.trim();
  String email = emailController.text.trim();
  String password = passwordController.text.trim();
  String confirmPassword = confirmPasswordController.text.trim();
  

  if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    showErrorDialog("All fields must be filled!");
    return;
  }

 if (!isValidEmail(email)) {
    showErrorDialog("Invalid email format!");
    return;
  }

  if (password != confirmPassword) {
    showErrorDialog("Passwords do not match!");
    return;
  }

  if (_acceptedPolicy  == false) {
    showErrorDialog("You must aceept the Privacy Policy");
    return;
  }

   //si todo esta bien, se crea la cuenta

  showNoErrorDialog();
  registrarUsuario();
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  const loginScreen()),
    );
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
  //funcion para mostrar mensaje de cuenta creada
  void showNoErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return  AlertDialog(
          title:  const Text("Account created"),
          content: const Text('You can now sign in'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
 //funcion para mostrar la politica de privacidad
  void _showPrivacyPolicy() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Política de Privacidad"),
        content: const SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              "Bienvenido/a a Glotonmate App. Nosotros nos tomamos muy en serio la privacidad de nuestros usuarios y queremos informarte sobre cómo recopilamos, usamos y protegemos tus datos personales.\n\n"

              "1. Información que Recopilamos\n"
              "Cuando utilizas Glotonmate App, podemos recopilar los siguientes datos:\n"

              "Información personal: Nombre, correo electrónico y contraseña.\n"
              "Ubicación: Para mejorar la experiencia y sugerir contenido relevante.\n"
              "Datos de uso: Información sobre cómo utilizas la App.\n"
              "Cookies y tecnologías similares: Para mejorar la navegación y personalización.\n\n"

              "2. Uso de la Información\n"
              "Utilizamos los datos recopilados para:\n"

              "Mejorar tu experiencia dentro de la App.\n"
              "Enviar notificaciones relacionadas con el servicio.\n"
              "Personalizar el contenido y las recomendaciones.\n"
              "Garantizar la seguridad y el funcionamiento adecuado de la App.\n\n"
              "3. Compartición de Datos\n"
              "No compartimos tu información con terceros. Toda la información recopilada se utiliza exclusivamente para el funcionamiento y mejora de Glotonmate App.\n\n"

              "4. Uso de Cookies\n"
              "Podemos utilizar cookies y tecnologías similares para mejorar la experiencia de usuario. Puedes gestionar o deshabilitar las cookies desde la configuración de tu dispositivo.\n\n"

              "5. Seguridad de los Datos\n"
              "Implementamos medidas de seguridad para proteger tu información. Sin embargo, ningún sistema es completamente seguro, por lo que no podemos garantizar protección absoluta contra accesos no autorizados.\n\n"

              "6. Eliminación de Cuenta y Datos\n"
              "Si deseas eliminar tu cuenta y todos tus datos, puedes hacerlo desde la configuración de la App o contactándonos en [correo de contacto].\n\n"

              "7. Cambios en la Política de Privacidad\n"
              "Nos reservamos el derecho de modificar esta política en cualquier momento. Te notificaremos cualquier cambio importante dentro de la App.\n\n"

              "Si tienes dudas o necesitas más información, contáctanos en [correo de contacto].\n",
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cerrar"),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255,0,39,112),
                Color.fromARGB(255, 69,196,169)
              ])
          ),
          child:
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/Logo sin fondo.png',  
                    height: 100,       
                  ),
                  const SizedBox(height: 10),  
                  
                ],
              ),
              ),
            )
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
          Padding(
            padding: const EdgeInsets.only(top: 230.0, bottom: 60, left: 15, right: 15),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)
                ),
                color: Colors.white,
              ),
              
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text('User Name', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255,0,39,112),
                        ),)
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text('Email', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255,0,39,112),
                        ),)
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: passwordobscure,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordobscure ? Icons.visibility_off : Icons.visibility,
                          ),
                          color: Colors.grey,
                          onPressed: () {
                            setState(() {
                              passwordobscure = !passwordobscure;
                            });
                          },
                        ),
                        label: const Text('Password', style: TextStyle(
                          fontWeight:FontWeight.bold,
                          color: Color.fromARGB(255,0,39,112),
                        ),
                        )
                      ),
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: passwordobscure,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordobscure ? Icons.visibility_off : Icons.visibility,
                          ),
                          color: Colors.grey,
                          onPressed: () {
                            setState(() {
                              passwordobscure = !passwordobscure; 
                            });
                          },
                        ),
                        label: const Text('Repeat Password', style: TextStyle(
                          fontWeight:FontWeight.bold,
                          color: Color.fromARGB(255,0,39,112),
                        ),
                        )
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
              children: [
                Checkbox(
                  value: _acceptedPolicy,
                  onChanged: (bool? value) {
                    setState(() {
                      _acceptedPolicy = value ?? false;
                    });
                  },
                ),
                GestureDetector(
                  onTap: _showPrivacyPolicy,
                  child: const Text(
                    "Política de privacidad",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container (
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255,0,39,112),
                            Color.fromARGB(255, 69,196,169)
                          ]),
                      ),
                      child: Center(
                        child: ElevatedButton(
                          
                          onPressed: validateAndCreateAccount, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, 
                            
                            padding: EdgeInsets.zero, 
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
                                  "CREATE ACCOUNT",
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
                    ),
                    const SizedBox(
                      height: 140,
                    ),
                     Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Do you have an account?", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                          ),),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const loginScreen()),
                              );
                            },
                            child: const Text(
                              "Sign in",
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
          ),
        ],
      ),
    );
  }
}