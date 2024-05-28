import 'package:flutter/material.dart';
import '../components/navigation_bar.dart'; // Importa la barra de navegación
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore


class SignInPage1 extends StatefulWidget {
  const SignInPage1({super.key});

  @override
  State<SignInPage1> createState() => _SignInPage1State();
}

class _SignInPage1State extends State<SignInPage1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Form(
        key: _formKey,
        child: Center(
          child: Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(32.0),
              constraints: const BoxConstraints(maxWidth: 350),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/bus_login.png',
                      height: 180,
                      width: 180,
                    ),
                    _gap(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Bienvenido",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Ingresa tu Usuario y Contraseña proporcionado por el administrador",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      controller: _usuarioController,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green), // Color del borde cuando el campo está enfocado
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green), // Color del borde cuando hay un error y el campo está enfocado
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      controller: _contrasenaController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green), // Color del borde cuando el campo está enfocado
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green), // Color del borde cuando hay un error y el campo está enfocado
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      obscureText: true,
                    ),
                    _gap(),
                    _gap(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)
                          ),
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          _verificarCredenciales();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);

  Future<void> _verificarCredenciales() async {
    final String usuario = _usuarioController.text.trim();
    final String contrasena = _contrasenaController.text.trim();

    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('conductores')
          .where('nombre_usuario', isEqualTo: usuario)
          .where('contrasena', isEqualTo: contrasena)
          .get();

      if (querySnapshot.docs.isNotEmpty) {

        final String nombreUsuario = (querySnapshot.docs[0].data() as Map<String, dynamic>)['nombre_usuario'];
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Barra_Navegacion(nombreUsuario: nombreUsuario),
          ),
        );
      } else {
        // Mostrar un mensaje de error al usuario
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciales incorrectas. Por favor, inténtalo de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Mostrar un mensaje de error al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al verificar las credenciales. Por favor, inténtalo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }
}