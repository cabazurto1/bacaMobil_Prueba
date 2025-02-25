import 'package:flutter/material.dart';

class CardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestión de Tarjetas")),
      body: Center(child: Text("Aquí se mostrarán las tarjetas del usuario.")),
    );
  }
}
