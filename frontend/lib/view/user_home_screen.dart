import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para manejar sesión

import '../models/user_model.dart';
import 'home_screen.dart';
import 'colores.dart'; // Archivo de colores
import 'transferir_dinero.dart';
import 'pago_servicios.dart';
import 'recargar_servicios.dart';
import 'ProfileScreen.dart';
class UserHomeScreen extends StatelessWidget {
  final UserModel user;

  UserHomeScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final String fechaActual = DateFormat('d/MM/yyyy').format(DateTime.now());
    final String horaActual = DateFormat('HH:mm:ss').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colores.colorFondo,
      appBar: AppBar(
        backgroundColor: Colores.colorPrincipal,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colores.colorDestacado,
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.account_balance, size: 30, color: Colores.colorDestacado),
            ),
            SizedBox(width: 8),
            Text(
              'Banca ',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              'Móvil',
              style: TextStyle(color: Colores.colorDestacado, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, color: Colores.colorDestacado),
          ),
        ],
      ),

      // Menú lateral (Drawer)
      drawer: Drawer(
        backgroundColor: Colores.colorPrincipal,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colores.colorSecundario),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_outline, size: 50, color: Colores.colorDestacado),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.nombre,
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user.correo,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.white),
              title: Text('Perfil', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: user),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_rounded, color: Colors.white),
              title: Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
              onTap: () async {
                // Cierra el menú lateral antes de salir
                Navigator.pop(context);

                // Limpiar sesión (si usas SharedPreferences)
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Redirigir a la pantalla de inicio de sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Bienvenido, ${user.nombre}! 👋🏼',
              style: TextStyle(color: Colores.colorPrincipal, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Último ingreso: $fechaActual / $horaActual',
              style: TextStyle(color: Colores.colorAccento, fontSize: 14),
            ),
            SizedBox(height: 16),

            // Tarjeta de saldo
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colores.colorDestacado, Colores.colorAccento],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mi Cuenta Principal',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nro. ********1104',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Saldo Disponible',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${user.saldoDisponible.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Botones de acceso rápido
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  IconData icon;
                  String texto;
                  Widget pantalla;

                  switch (index) {
                    case 0:
                      icon = Icons.send;
                      texto = 'Transferir Dinero';
                      pantalla = TransferirDineroVista();
                      break;
                    case 1:
                      icon = Icons.payment;
                      texto = 'Pagar Servicios';
                      pantalla = PagoServiciosVista();
                      break;
                    case 2:
                      icon = Icons.refresh;
                      texto = 'Recargar Servicios';
                      pantalla = RecargarServiciosVista();
                      break;
                    default:
                      icon = Icons.error;
                      texto = 'Error';
                      pantalla = HomeScreen();
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => pantalla));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colores.colorSecundario,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, size: 40, color: Colores.colorDestacado),
                            SizedBox(height: 8),
                            Text(
                              texto,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
