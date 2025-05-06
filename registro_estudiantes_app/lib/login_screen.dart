import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  final String usuarioValido = 'admin';
  final String contrasenaValida = '1234';

  void _validarLogin() {
    String usuario = _usuarioController.text;
    String contrasena = _contrasenaController.text;

    if (usuario == usuarioValido && contrasena == contrasenaValida) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Error'),
              content: const Text('Usuario o contraseña incorrectos'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/logo.png', height: 100),
                const SizedBox(height: 20),
                const Text(
                  'Autenticación',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _usuarioController,
                  decoration: const InputDecoration(labelText: 'Usuario'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _contrasenaController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _validarLogin,
                  child: const Text('Ingresar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
