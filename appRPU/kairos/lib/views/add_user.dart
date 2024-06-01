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
  final TextEditingController _passwordRepeatController = TextEditingController();
  final TextEditingController _bankCodeController = TextEditingController();
  final TextEditingController _walletController = TextEditingController();

  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Surnames'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _selectedDate != null
                    ? 'Date of birth: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Enter your date of birth',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: 'Country'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'New password'),
              obscureText: true,
            ),
            TextField(
              controller: _passwordRepeatController,
              decoration: const InputDecoration(labelText: 'Repeat your new password'),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _bankCodeController,
              decoration: const InputDecoration(labelText: 'Bank code'),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _walletController,
                    decoration: const InputDecoration(labelText: 'Wallet'),
                    obscureText: true,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'This field collects the money you wish to debit your account for payments. You can change it in the "Update your personal data" section.',
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _addUser();
              },
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? birthday = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (birthday != null) {
      setState(() {
        _selectedDate = birthday;
      });
    }
  }

  bool _isUserAdult(DateTime birthdate) {
    final today = DateTime.now();
    final age = today.year - birthdate.year;
    if (today.month < birthdate.month ||
        (today.month == birthdate.month && today.day < birthdate.day)) {
      return age - 1 >= 18;
    }
    return age >= 18;
  }

  void _addUser() async {
    String name = _nameController.text;
    String surname = _surnameController.text;
    String country = _countryController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String passwordRepeat = _passwordRepeatController.text;
    String bankCode = _bankCodeController.text;
    String wallet = _walletController.text;

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final passwordRegex = RegExp(r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W).+$');
    final nameSurnameCountryRegex = RegExp(r'^[^0-9]+$');
    final walletRegex = RegExp(r'^\d+(\.\d+)?$');

    if (_selectedDate == null ||
        name.isEmpty ||
        surname.isEmpty ||
        country.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        bankCode.isEmpty) {
      _showDialog('Missing fields', 'Please complete all fields.');
      return;
    }

    if (!nameSurnameCountryRegex.hasMatch(name) ||
        !nameSurnameCountryRegex.hasMatch(surname) ||
        !nameSurnameCountryRegex.hasMatch(country) ||
        name == 'null' || surname == 'null' || country == 'null') { // control para no inyectar null
      _showDialog('Invalid fields', 'The fields name, surname and country cannot contain numbers.');
      return;
    }

    if (!_isUserAdult(_selectedDate!)) {
      _showDialog('Underage user', 'You must be at least 18 years old to register.');
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      _showDialog('Invalid email address', 'Please enter an email address according to the general form.');
      return;
    }

    if (!passwordRegex.hasMatch(password)) {
      _showDialog('Incorrect password', 'The password must contain at least one number, one lower case letter, one upper case letter and one special character.');
      return;
    }

    if (password != passwordRepeat) {
      _showDialog('Incorrect password', 'Both passwords must be the same.');
      return;
    }

    if (bankCode == 'null') { // control para no inyectar null
      _showDialog('Null error', 'There is no bank account with the term null.');
      return;
    }

    if (!walletRegex.hasMatch(wallet)) {
      _showDialog('Invalid wallet', 'Please enter an integer and positive money.');
      return;
    }

    // Usuario existe?
    bool userExists = await _userRepository.checkUserExists(email);
    if (userExists) {
      _showDialog('Error', 'The user already exists.');
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
        wallet: wallet
      ));
      _showDialog('Registration successful', 'User successfully registered.');
    } catch (e) {
      _showDialog('Error', 'Error registering user.: $e');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
