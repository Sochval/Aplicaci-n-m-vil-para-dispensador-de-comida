import 'package:flutter/material.dart';
import 'package:app/login_screen.dart';
import 'package:app/signup_screen.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
              ],
            )
          ),
        child:
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
              padding: const EdgeInsets.only(top: 180.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/Nombre sin fondo.png', 
                    height: 150,  
                  ),
                  const SizedBox(height: 10), 

                  
                ],
              ),
              ),
            )
        ),
        
        Padding(
          padding: const EdgeInsets.all(60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Center(
                          child:  SizedBox(
                            height: 60,
                            width: 300,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const loginScreen()),
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
                                "SING IN",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 0, 39, 112), 
                                ),
                              ),
                            ),
                          )
                        ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child:  SizedBox(
                  height: 60,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const signupScreen()),
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
                        "SING UP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 39, 112),
                        ),
                      ),
                    ),
                  )
                ),
            ],
          ),
        ),
        
        ],
        )
      
      );
  }
}