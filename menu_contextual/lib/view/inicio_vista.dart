import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transferir_dinero.dart';
import 'pago_servicios.dart';
import 'recargar_servicios.dart';
import 'colores.dart';

class InicioVista extends StatelessWidget {
  final String usuarioNombre = "Usuario Ejemplo";
  final String usuarioCorreo = "usuario@gmail.com";
  final double saldoDisponible = 1906.04;

  @override
  Widget build(BuildContext context) {
    final String fechaActual = DateFormat('d/MM/yyyy').format(DateTime.now());
    final String horaActual = DateFormat('HH:mm:ss').format(DateTime.now());

    // Función para mostrar una pantalla flotante
    void _mostrarPantallaFlotante(BuildContext context, Widget pantalla) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colores.colorFondo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: pantalla,
          );
        },
      );
    }

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
              backgroundColor: Colors.white, // Color de fondo del círculo
              child: Icon(
                Icons.account_balance, // Icono de un banco
                size: 30, // Tamaño del icono
                color: Colores.colorDestacado, // Color del icono
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Banca ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Movil',
              style: TextStyle(
                color: Colores.colorDestacado,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_outlined, color: Colores.colorDestacado),
          ),
        ],
      ),
      // Agregando el Drawer para el menú lateral
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
                    child: Icon(
                      Icons.person_outline,
                      size: 50,
                      color: Colores.colorDestacado,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          usuarioNombre,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          usuarioCorreo,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.white),
              title: Text(
                'Perfil',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navegar a la pantalla de perfil
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_rounded, color: Colors.white),
              title: Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Lógica para cerrar sesión
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
              '¡Bienvenido, $usuarioNombre!👋🏼',
              style: TextStyle(
                color: Colores.colorPrincipal,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Último ingreso: $fechaActual / $horaActual',
              style: TextStyle(
                color: Colores.colorAccento,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nro. ********1104',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Saldo Disponible',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${saldoDisponible.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Cuadrícula de 2 columnas con iconos grandes
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columnas
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5, // Hacer las celdas cuadradas
                ),
                itemCount: 3, // Número de elementos (botones)
                itemBuilder: (context, index) {
                  // Iconos y textos según el índice
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
                      pantalla = Container();
                  }

                  return GestureDetector(
                    onTap: () {
                      _mostrarPantallaFlotante(context, pantalla);
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
                            Icon(
                              icon,
                              size: 40,
                              color: Colores.colorDestacado,
                            ),
                            SizedBox(height: 8),
                            Text(
                              texto,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
