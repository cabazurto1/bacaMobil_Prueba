import 'package:flutter/material.dart';
import '../services/user_service.dart'; // Importamos el servicio para manejar el login y registro
import '../models/user_model.dart'; // Importamos el modelo de usuario
import 'user_home_screen.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLogin = true; // Para alternar entre login y registro
  bool _isLoading = false; // Para manejar el estado de carga

  // Método para manejar el login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = await _userService.loginUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        // Si el login es exitoso, navegamos a la pantalla principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserHomeScreen(user: user), // Pasa el usuario a la pantalla principal
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Método para manejar el registro
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final newUser = UserModel(
          id: '', // El ID se genera en el backend
          correo: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await _userService.registerUser(newUser);
        // Si el registro es exitoso, mostramos un mensaje y cambiamos a login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso. Inicia sesión.')),
        );
        setState(() {
          _isLogin = true;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Iniciar Sesión' : 'Registrarse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de correo electrónico
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu correo electrónico';
                  }
                  if (!value.contains('@')) {
                    return 'Ingresa un correo electrónico válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Campo de contraseña
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu contraseña';
                  }
                  if (value.length < 1) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Campo de confirmación de contraseña (solo en registro)
              if (!_isLogin)
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Confirmar contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirma tu contraseña';
                    }
                    if (value != _passwordController.text) {
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