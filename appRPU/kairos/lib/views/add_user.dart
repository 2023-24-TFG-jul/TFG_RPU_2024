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
  final TextEditingController _passwordRepeatController =
      TextEditingController();
  final TextEditingController _bankCodeController = TextEditingController();

  late int _walletController = 0;

  final UserRepository _userRepository = UserRepository();

  // whether or not to hide the password
  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User registration'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/kairos_wallpaper.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width > 600 ? 500.0 : 400.0,
                ),
                child: registrationForm(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget registrationForm(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          controller: _nameController,
          style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
          decoration: InputDecoration(
            hintText: 'Name',
            hintStyle: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20.0),
        TextField(
          controller: _surnameController,
          style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
          decoration: InputDecoration(
            hintText: 'Surnames',
            hintStyle: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            Expanded(
              child: Text(
                'Date of birth (over 18 years old)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isLargeScreen ? 20.0 : 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Enter your date of birth',
                style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        TextField(
          controller: _countryController,
          style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
          decoration: InputDecoration(
            hintText: 'Country',
            hintStyle: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20.0),
        TextField(
          controller: _emailController,
          style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20.0),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        TextField(
          controller: _passwordRepeatController,
          obscureText: !_isRepeatPasswordVisible,
          style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
          decoration: InputDecoration(
            hintText: 'Repeat your password',
            hintStyle: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _isRepeatPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isRepeatPasswordVisible = !_isRepeatPasswordVisible;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        TextField(
          controller: _bankCodeController,
          style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
          decoration: InputDecoration(
            hintText: 'Bank code',
            hintStyle: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Wallet',
                  hintStyle: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _walletController = int.tryParse(value) ?? 0;
                },
                style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                _showDialog('Wallet info', 'This field collects the money you wish to debit your account for payments. You can change it in the "Update your personal data" section. If you do not enter any value, we understand that you start from zero.');
              },
              color: Colors.white,
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            _addUser();
          },
          child: Text(
            'Sign up',
            style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
          ),
        ),
      ],
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

  // Check if the user to be registered is of legal age.
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
    int wallet = _walletController;

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final passwordRegex =
        RegExp(r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W).+$');
    final nameSurnameCountryRegex = RegExp(r'^[^0-9]+$');

    if (_selectedDate == null ||
        name.trim().isEmpty ||
        surname.trim().isEmpty ||
        country.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty ||
        passwordRepeat.trim().isEmpty ||
        bankCode.trim().isEmpty) {
      _showDialog('Missing fields', 'Please complete all fields.');
      return;
    }

    if (!nameSurnameCountryRegex.hasMatch(name) ||
        !nameSurnameCountryRegex.hasMatch(surname) ||
        !nameSurnameCountryRegex.hasMatch(country) ||
        name == 'null' ||
        surname == 'null' ||
        country == 'null') {
      // unable to inject null into database
      _showDialog('Invalid fields',
          'The fields name, surname and country cannot contain numbers.');
      return;
    }

    if (!_isUserAdult(_selectedDate!)) {
      _showDialog(
          'Underage user', 'You must be at least 18 years old to register.');
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      _showDialog('Invalid email address',
          'Please enter an email address according to the general form.');
      return;
    }

    if (!passwordRegex.hasMatch(password)) {
      _showDialog('Incorrect password',
          'The password must contain at least one number, one lower case letter, one upper case letter and one special character.');
      return;
    }

    if (password != passwordRepeat) {
      _showDialog('Incorrect password', 'Both passwords must be the same.');
      return;
    }

    if (bankCode == 'null') {
      _showDialog('Null error', 'There is no bank account with the term null.');
      return;
    }

    if (wallet < 0) {
      _showDialog(
          'Invalid wallet', 'Enter an integer greater than or equal to 0.');
      return;
    }

    // Check if the user exists before creating it
    bool userExists = await _userRepository.checkUserExists(email);
    if (userExists) {
      _showDialog('Error', 'The user already exists.');
      return;
    }

    try {
      await _userRepository.addUser(User(
          name: name,
          surname: surname,
          birthdate:
              "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
          country: country,
          email: email,
          password: password,
          bankCode: bankCode,
          wallet: wallet));
      _showDialog('Registration successful', 'User successfully registered.');
    } catch (e) {
      _showDialog('Error', 'Error registering user.: $e');
    }
  }

  // Function defining the warning format of error messages.
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
