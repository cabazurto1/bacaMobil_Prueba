import '../models/banca_modelo.dart';

class BancaControlador {
  BancaModelo obtenerUsuario() {
    // Datos simulados del usuario
    return BancaModelo(nombre: 'Carlos', correo: 'carlos@gmail.com');
  }

  void cambiarContrasena(String actual, String nueva) {
    // Implementa la lógica para cambiar la contraseña
    print('Contraseña actual: $actual');
    print('Nueva contraseña: $nueva');
    print('Cambio de contraseña solicitado.');
  }

  void cerrarSesion() {
    // Implementa la lógica para cerrar sesión
    print('Sesión cerrada.');
  }
}