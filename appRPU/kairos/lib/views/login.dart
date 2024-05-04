import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login ({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: fondoPantalla(context),
    );
  }
}

Widget fondoPantalla(BuildContext context){
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage("https://marketplace.canva.com/EAEqsNZQF1o/1/0/225w/canva-azul-y-rosa-acuarela-suave-sin-texto-fondo-de-pantalla-de-tel%C3%A9fono-phP0xrNZh2o.jpg"),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          boxUser(),
          boxPassword(),
          SizedBox(height: 10,),
          buttonLogIn(context), // Pasar el contexto a la función
        ],
      ),
    ),
  );
}

Widget boxUser(){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    child: TextField(
      decoration: InputDecoration(
        hintText: "User",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget boxPassword(){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Password",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget buttonLogIn(BuildContext context){ // Añadir el contexto como parámetro
  return SizedBox(
    width: double.infinity, // Ancho del botón igual al ancho disponible
    child: ElevatedButton(
      onPressed: (){
        // Navegar a la página de inicio
        Navigator.pushNamed(context, '/home');
      },
      child: Text("Log in"),
    ),
  );
}
