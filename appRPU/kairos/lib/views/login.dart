import 'package:flutter/material.dart';
import 'package:kairos/models/user.dart';
import 'package:collection/collection.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pantallaGeneral(context),
    );
  }

  Widget pantallaGeneral(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              "https://www.meisterdrucke.es/kunstwerke/1260px/Francesco_de_Rossi_Salviati_-_KAIROS_%28temps_de_loccasion_opportune%29_-_Time_of_Decision_%28Kairos%29_fresque_de_Fra_-_%28MeisterDrucke-1323120%29.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: const Text(
              'Welcome to Kairos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                boxEmail(),
                boxPassword(),
                const SizedBox(
                  height: 10,
                ),
                buttonLogIn(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget boxEmail() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: TextField(
        controller: _emailController,
        decoration: const InputDecoration(
          hintText: "Email",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget boxPassword() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: "Password",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget buttonLogIn(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final String email = _emailController.text.trim();
          final String password = _passwordController.text.trim();

          _userRepository.getAllUsers().then((List<User> users) {
            User? user = users.firstWhereOrNull(
              (user) => user.email == email && user.password == password,
            );

            if (user != null) {
              Navigator.pushNamed(context, '/home');  // Todo bien
            } else {  // Errores
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
        child: const Text("Log in"),
      ),
    );
  }
}