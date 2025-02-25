import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'user_home_screen.dart';
import 'colores.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final user = await _userService.loginUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserHomeScreen(user: user),
            ),
          );
        } else {
          _showErrorSnackbar('Correo o contraseña incorrectos');
        }
      } catch (e) {
        _showErrorSnackbar('Error en el inicio de sesión: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
        _showErrorSnackbar('Las contraseñas no coinciden');
        return;
      }

      setState(() => _isLoading = true);

      try {
        final newUser = UserModel(
          id: '',
          nombre: _nameController.text.trim(),
          correo: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          saldoDisponible: 0.0,
        );

        await _userService.registerUser(newUser);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso. Inicia sesión.')),
        );

        setState(() => _isLogin = true);
      } catch (e) {
        _showErrorSnackbar('Error en el registro: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String fechaActual = DateFormat('d/MM/yyyy').format(DateTime.now());
    final String horaActual = DateFormat('HH:mm:ss').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colores.colorFondo,
      appBar: AppBar(
        backgroundColor: Colores.colorPrincipal,
        elevation: 0,
        iconTheme: IconThemeData(color: Colores.colorDestacado),
        title: Text(
          _isLogin ? 'Iniciar Sesión' : 'Registrarse',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isLogin ? '¡Bienvenido de nuevo! 👋🏼' : '¡Crea tu cuenta! 🎉',
                style: TextStyle(color: Colores.colorPrincipal, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Fecha: $fechaActual - Hora: $horaActual',
                style: TextStyle(color: Colores.colorAccento, fontSize: 14),
              ),
              SizedBox(height: 16),

              if (!_isLogin)
                _buildTextField(_nameController, 'Nombre', Icons.person),
              SizedBox(height: 10),

              _buildTextField(_emailController, 'Correo Electrónico', Icons.email),
              SizedBox(height: 10),

              _buildTextField(_passwordController, 'Contraseña', Icons.lock, obscureText: true),
              SizedBox(height: 10),

              if (!_isLogin)
                _buildTextField(_confirmPasswordController, 'Confirmar Contraseña', Icons.lock, obscureText: true),
              SizedBox(height: 20),

              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GestureDetector(
                onTap: _isLogin ? _login : _register,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colores.colorAccento,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colores.colorAccento.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _isLogin ? 'Iniciar Sesión' : 'Registrarse',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin ? '¿No tienes una cuenta? Regístrate' : '¿Ya tienes una cuenta? Inicia sesión',
                  style: TextStyle(color: Colores.colorPrincipal, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool obscureText = false,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colores.colorPrincipal.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colores.colorSecundario),
          prefixIcon: Icon(icon, color: Colores.colorPrincipal),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor, ingresa tu $label';
          }
          return null;
        },
      ),
    );
  }
}
