import 'package:flutter/material.dart';
import '../services/user_service.dart'; // Servicio para manejar el registro y login
import '../models/user_model.dart'; // Modelo de usuario
import 'user_home_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLogin = true; // Alternar entre login y registro
  bool _isLoading = false; // Estado de carga

  // Método para manejar el login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final user = await _userService.loginUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (user != null) {
          // Si el login es exitoso, navegamos a la pantalla de usuario
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

  // Método para manejar el registro
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
        _showErrorSnackbar('Las contraseñas no coinciden');
        return;
      }

      setState(() => _isLoading = true);

      try {
        final newUser = UserModel(
          id: '', // ID generado en el backend
          nombre: _nameController.text.trim(),
          correo: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await _userService.registerUser(newUser);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso. Inicia sesión.')),
        );

        setState(() => _isLogin = true); // Cambiar a login después del registro
      } catch (e) {
        _showErrorSnackbar('Error en el registro: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // Método para mostrar mensajes de error
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Iniciar Sesión' : 'Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo para el Nombre (solo en registro)
              if (!_isLogin)
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, ingresa tu nombre';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 10),

              // Campo para el Correo Electrónico
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, ingresa tu correo electrónico';
                  }
                  if (!value.contains('@')) {
                    return 'Ingresa un correo electrónico válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Campo para la Contraseña
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, ingresa tu contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Campo para Confirmar Contraseña (solo en registro)
              if (!_isLogin)
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Confirmar Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, confirma tu contraseña';
                    }
                    if (value != _passwordController.text.trim()) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 20),

              // Botón de login o registro
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _isLogin ? _login : _register,
                child: Text(_isLogin ? 'Iniciar Sesión' : 'Registrarse'),
              ),
              SizedBox(height: 16),

              // Botón para alternar entre login y registro
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(_isLogin
                    ? '¿No tienes una cuenta? Regístrate'
                    : '¿Ya tienes una cuenta? Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
