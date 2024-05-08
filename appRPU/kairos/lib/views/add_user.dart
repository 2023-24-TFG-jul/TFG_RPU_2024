import 'package:flutter/material.dart';
import 'package:kairos/models/user.dart';

class Register extends StatefulWidget {
  const Register({
    super.key,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  DateTime? _selectedDate;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bankCodeController = TextEditingController();

  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _selectedDate != null
                    ? 'Fecha de Nacimiento: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Seleccionar Fecha de Nacimiento',
              ),
            ),
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: 'País'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _bankCodeController,
              decoration: const InputDecoration(labelText: 'Código de Banco'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _addUser();
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addUser() async {
    String name = _nameController.text;
    String surname = _surnameController.text;
    String country = _countryController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String bankCode = _bankCodeController.text;

    if (_selectedDate == null ||
        name.isEmpty ||
        surname.isEmpty ||
        country.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        bankCode.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Campos faltantes'),
            content: const Text('Por favor complete todos los campos.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Usuario existe?
    bool userExists = await _userRepository.checkUserExists(email);
    if (userExists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('El usuario ya existe.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      await _userRepository.addUser(User(
        name: name,
        surname: surname,
        birthdate: "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
        country: country,
        email: email,
        password: password,
        bankCode: bankCode,
      ));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registro exitoso'),
            content: const Text('Usuario registrado exitosamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error al registrar usuario: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
