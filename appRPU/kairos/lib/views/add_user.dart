//add_user.dart
import 'package:flutter/material.dart';
import 'package:kairos/models/user.dart';

class Register extends StatefulWidget {
  const Register ({
    Key? key,
  }) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bankCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _birthdateController,
              decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
            ),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(labelText: 'País'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _bankCodeController,
              decoration: InputDecoration(labelText: 'Código de Banco'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _addUser();
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }

  void _addUser() async {
    String name = _nameController.text;
    String surname = _surnameController.text;
    String birthdate = _birthdateController.text;
    String country = _countryController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String bankCode = _bankCodeController.text;

    // Validación básica de campos (puedes agregar más validaciones según sea necesario)

    if (name.isNotEmpty &&
        surname.isNotEmpty &&
        birthdate.isNotEmpty &&
        country.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        bankCode.isNotEmpty) {
      try {
        await addUser(name, surname, birthdate, country, email, password, bankCode);
        // Registro exitoso, puedes mostrar un mensaje o navegar a otra pantalla
        print('Usuario registrado exitosamente');
      } catch (e) {
        // Error al registrar usuario
        print('Error al registrar usuario: $e');
      }
    } else {
      // Campos faltantes
      print('Por favor complete todos los campos');
    }
  }
}
