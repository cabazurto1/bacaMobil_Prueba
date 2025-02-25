import 'package:flutter/material.dart';
import 'package:menu_contextual/view/home_screen.dart';
import '../models/user_model.dart'; // Importa el modelo de usuario

class UserHomeScreen extends StatelessWidget {
  final UserModel user; // Recibe el usuario como parámetro

  UserHomeScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bienvenido, ${user.correo}', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Correo: ${user.correo}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de pagos
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Ir a Pagos'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de tarjetas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Gestionar Tarjetas'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de transacciones
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Historial de Transacciones'),
            ),
          ],
        ),
      ),
    );
  }
}