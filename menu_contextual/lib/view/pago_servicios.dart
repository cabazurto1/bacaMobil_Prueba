import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'colores.dart';  // Asegúrate de importar el archivo de colores

class PagoServiciosVista extends StatefulWidget {
  @override
  _PagoServiciosVistaState createState() => _PagoServiciosVistaState();
}

class _PagoServiciosVistaState extends State<PagoServiciosVista> {
  final String apiUrl = 'https://678d153bf067bf9e24e935b2.mockapi.io/api/servicios/servicios';
  List<dynamic> serviciosAleatorios = [];

  @override
  void initState() {
    super.initState();
    fetchServicios();
  }

  Future<void> fetchServicios() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          serviciosAleatorios = obtenerServiciosAleatorios(data);
        });
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  List<dynamic> obtenerServiciosAleatorios(List<dynamic> servicios) {
    final random = Random();
    int cantidad = random.nextInt(5) + 1; // Genera entre 1 y 5.
    List<dynamic> aleatorios = List.from(servicios)..shuffle();
    return aleatorios.take(cantidad).toList();
  }

  void pagarServicio(int index) {
    final servicio = serviciosAleatorios[index];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Servicio "${servicio['name']}" pagado'),
        backgroundColor: Colores.colorAccento,
      ),
    );
    setState(() {
      serviciosAleatorios.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.colorFondo,  // Fondo cálido
      appBar: AppBar(
        title: const Text('Pago a Servicios'),
        backgroundColor: Colores.colorPrincipal,  // Color principal oscuro
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: serviciosAleatorios.isEmpty
          ? const Center(
        child: Text(
          'No hay servicios pendientes',
          style: TextStyle(color: Colores.colorSecundario, fontSize: 18),
        ),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView.builder(
          itemCount: serviciosAleatorios.length,
          itemBuilder: (context, index) {
            final servicio = serviciosAleatorios[index];
            return Card(
              color: Colores.colorSecundario,  // Fondo gris suave
              elevation: 6,
              margin: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    servicio['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  servicio['name'],
                  style: TextStyle(
                    color: Colores.colorPrincipal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Valor a pagar: \$${servicio['price']}',
                  style: TextStyle(color: Colores.colorAccento),
                ),
                trailing: ElevatedButton(
                  onPressed: () => pagarServicio(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colores.colorPrincipal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                  child: Text(
                    'Pagar',
                    style: TextStyle(
                      color: Colores.colorFondo,  // Letra blanca
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
