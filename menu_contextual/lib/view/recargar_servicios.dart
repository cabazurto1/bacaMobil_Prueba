import 'package:flutter/material.dart';
import 'colores.dart';  // Asegúrate de importar el archivo de colores

class RecargarServiciosVista extends StatelessWidget {
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  String? lineaSeleccionada;

  final List<String> lineasTelefonicas = ['Claro', 'Movistar', 'Tuenti', 'CNT'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.colorFondo,  // Fondo cálido
      appBar: AppBar(
        title: const Text('Recargas Telefónicas'),
        backgroundColor: Colores.colorPrincipal,  // Color oscuro principal
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colores.colorFondo,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colores.colorPrincipal.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Seleccione una línea',
                      labelStyle: TextStyle(color: Colores.colorSecundario),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.phone_android, color: Colores.colorPrincipal),
                    ),
                    items: lineasTelefonicas
                        .map((linea) => DropdownMenuItem(
                      value: linea,
                      child: Text(
                        linea,
                        style: TextStyle(color: Colores.colorPrincipal),
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      lineaSeleccionada = value;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Campo de número de teléfono con contorno flotante
              Container(
                decoration: BoxDecoration(
                  color: Colores.colorFondo,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colores.colorPrincipal.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: telefonoController,
                  decoration: InputDecoration(
                    labelText: 'Número de teléfono',
                    labelStyle: TextStyle(color: Colores.colorSecundario),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.phone, color: Colores.colorPrincipal),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(height: 24),

              // Campo de cantidad de recarga con estilo moderno
              Container(
                decoration: BoxDecoration(
                  color: Colores.colorFondo,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colores.colorPrincipal.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: cantidadController,
                  decoration: InputDecoration(
                    labelText: 'Cantidad de recarga',
                    labelStyle: TextStyle(color: Colores.colorSecundario),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.attach_money, color: Colores.colorPrincipal),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(height: 40),

              // Botón de confirmación con animación
              GestureDetector(
                onTap: () {
                  final telefono = telefonoController.text;
                  final cantidad = cantidadController.text;

                  if (lineaSeleccionada == null || telefono.isEmpty || cantidad.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Por favor, completa todos los campos'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('¡Recarga exitosa en la línea $lineaSeleccionada al número $telefono por \$${cantidad}!'),
                      backgroundColor: Colores.colorAccento,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colores.colorAccento,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colores.colorAccento.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Confirmar Recarga',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
