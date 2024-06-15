import 'package:flutter/material.dart';
import 'package:kairos/models/user.dart';
import 'package:collection/collection.dart';
import 'add_user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserRepository _userRepository = UserRepository();

  // whether or not to hide the password
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  // the size of the elements is adjusted according to the dimensions of the screen
                  maxWidth:
                      MediaQuery.of(context).size.width > 600 ? 500.0 : 400.0,
                ),
                child: loginScreen(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginScreen(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Welcome to Kairos',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isLargeScreen ? 40.0 : 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Please enter your credentials to access the application.',
          textAlign: TextAlign.center,
          style: TextStyle(
            // the size of the text elements is adjusted according to the dimensions of the screen
            fontSize: isLargeScreen ? 20.0 : 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        boxEmail(isLargeScreen),
        const SizedBox(height: 10),
        boxPassword(isLargeScreen),
        const SizedBox(height: 10),
        buttonLogIn(context, isLargeScreen),
      ],
    );
  }

  Widget boxEmail(bool isLargeScreen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: TextField(
        controller: _emailController,
        style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
        decoration: InputDecoration(
          hintText: "Email",
          hintStyle: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
          fillColor: Colors.white,
          filled: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget boxPassword(bool isLargeScreen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
        decoration: InputDecoration(
          hintText: "Password",
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
    );
  }

  Widget buttonLogIn(BuildContext context, bool isLargeScreen) {
    return Column(
      children: [
        SizedBox(
          child: ElevatedButton(
            onPressed: () {
              final String email = _emailController.text.trim();
              final String password = _passwordController.text.trim();

              _userRepository.getAllUsers().then((List<User> users) {
                User? user = users.firstWhereOrNull(
                  (user) => user.email == email && user.password == password,
                );

                if (user != null) {
                  Navigator.pushNamed(
                    context,
                    '/home',
                    arguments: email,
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Invalid email or password.'),
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
              });
            },
            child: Text(
              "Log in",
              style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account yet? ",
              style: TextStyle(
                  color: Colors.white, fontSize: isLargeScreen ? 16.0 : 14.0),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Register()),
                );
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              child: Text(
                'Register',
                style: TextStyle(
                    color: Colors.white, fontSize: isLargeScreen ? 16.0 : 14.0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
