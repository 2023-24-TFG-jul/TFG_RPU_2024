import 'package:flutter/material.dart';
import 'package:kairos/models/user.dart';
import 'package:kairos/views/home.dart';

class UpdateUser extends StatefulWidget {
  final String userEmail;

  const UpdateUser({super.key, required this.userEmail});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
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
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User user = await _userRepository.getUserByEmail(widget.userEmail);
      setState(() {
        _nameController.text = user.name;
        _surnameController.text = user.surname;
        _countryController.text = user.country;
        _bankCodeController.text = user.bankCode;
        _walletController = user.wallet;
      });
    } catch (e) {
      _showDialog('Error', 'Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Your Personal Data'),
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
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width > 600 ? 500.0 : 400.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _nameController,
                      style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                      decoration: InputDecoration(
                        hintText: 'New name',
                        hintStyle:
                            TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
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
                        hintText: 'New surnames',
                        hintStyle:
                            TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _countryController,
                      style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                      decoration: InputDecoration(
                        hintText: 'New country',
                        hintStyle:
                            TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
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
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            style: TextStyle(
                                fontSize: isLargeScreen ? 18.0 : 14.0),
                            decoration: InputDecoration(
                              hintText: 'New password',
                              hintStyle: TextStyle(
                                  fontSize: isLargeScreen ? 18.0 : 14.0),
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
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
                        ),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip:
                              'If you do not want to change the password, enter the same password as confirmation of the data update.',
                          onPressed: () {},
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _passwordRepeatController,
                      obscureText: !_isRepeatPasswordVisible,
                      style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                      decoration: InputDecoration(
                        hintText: 'Repeat your new password',
                        hintStyle:
                            TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
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
                              _isRepeatPasswordVisible =
                                  !_isRepeatPasswordVisible;
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
                        hintText: 'New bank code',
                        hintStyle:
                            TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'New wallet',
                        hintStyle:
                            TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
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
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _updateUser,
                      child: Text(
                        'Update',
                        style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateUser() async {
    String newName = _nameController.text;
    String newSurname = _surnameController.text;
    String newCountry = _countryController.text;
    String newPassword = _passwordController.text;
    String newPasswordRepeat = _passwordRepeatController.text;
    String newBankCode = _bankCodeController.text;

    int newWallet = _walletController;

    final passwordRegex =
        RegExp(r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W).+$');
    final nameSurnameCountryRegex = RegExp(r'^[^0-9]+$');

    if (newName.trim().isEmpty ||
        newSurname.trim().isEmpty ||
        newCountry.trim().isEmpty ||
        newPassword.trim().isEmpty ||
        newBankCode.trim().isEmpty) {
      _showDialog('Missing fields', 'Please complete all fields.');
      return;
    }

    if (!nameSurnameCountryRegex.hasMatch(newName) ||
        !nameSurnameCountryRegex.hasMatch(newSurname) ||
        !nameSurnameCountryRegex.hasMatch(newCountry) ||
        newName == 'null' ||
        newSurname == 'null' ||
        newCountry == 'null') {
      // control para no inyectar null
      _showDialog('Invalid fields',
          'The fields name, surname and country cannot contain numbers.');
      return;
    }

    if (!passwordRegex.hasMatch(newPassword)) {
      _showDialog('Incorrect password',
          'The password must contain at least one number, one lower case letter, one upper case letter and one special character.');
      return;
    }

    if (newPassword != newPasswordRepeat) {
      _showDialog('Incorrect password', 'Both passwords must be the same.');
      return;
    }

    if (newBankCode == 'null') {
      // control para no inyectar null
      _showDialog('Null error', 'There is no bank account with the term null.');
      return;
    }

    if (newWallet < 0) {
      _showDialog('Invalid wallet',
          'Please enter an integer and positive amount of money.');
      return;
    }

    try {
      await _userRepository.updateUser(
        widget.userEmail,
        newName,
        newSurname,
        newCountry,
        newPassword,
        newBankCode,
        newWallet,
      );

      _showDialog('Update Successful', 'Your personal data has been updated.');
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(loginUserEmail: widget.userEmail),
        ),
      );
    } catch (e) {
      _showDialog('Error', 'Error updating user: $e');
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
