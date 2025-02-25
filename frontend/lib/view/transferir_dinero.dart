import 'package:flutter/material.dart';
import 'colores.dart';  // Asegúrate de importar el archivo de colores

class TransferirDineroVista extends StatelessWidget {
  final TextEditingController cuentaController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.colorFondo,  // Fondo cálido
      appBar: AppBar(
        title: const Text('Transferir Dinero'),
        backgroundColor: Colores.colorPrincipal,  // Color principal oscuro
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
                child: TextField(
                  controller: cuentaController,
                  decoration: InputDecoration(
                    labelText: 'Número de cuenta',
                    labelStyle: TextStyle(color: Colores.colorSecundario),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.account_balance, color: Colores.colorPrincipal),
                    contentPadding: const EdgeInsets.all(1),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 15),
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
                    labelText: 'Cantidad a transferir',
                    labelStyle: TextStyle(color: Colores.colorSecundario),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.attach_money, color: Colores.colorPrincipal),
                    contentPadding: const EdgeInsets.all(5),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  final cuenta = cuentaController.text;
                  final cantidad = cantidadController.text;

                  if (cuenta.isEmpty || cantidad.isEmpty) {
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
                      content: Text('¡Transferencia exitosa a la cuenta $cuenta por \$${cantidad}!'),
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
                    'Confirmar Transferencia',
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
