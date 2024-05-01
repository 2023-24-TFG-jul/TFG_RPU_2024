import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Widgets",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
   @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: fondoPantalla(),
    );
  }
}

Widget fondoPantalla(){
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(image: NetworkImage("https://marketplace.canva.com/EAEqsNZQF1o/1/0/225w/canva-azul-y-rosa-acuarela-suave-sin-texto-fondo-de-pantalla-de-tel%C3%A9fono-phP0xrNZh2o.jpg"),
      fit: BoxFit.cover
      )
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          boxUser(),
          boxPassword(),
          SizedBox(height: 10,),
          buttonLogIn()
        ],
      )
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

Widget buttonLogIn(){
  return TextButton(
    onPressed: (){},
    child: Text("Log in")
  );
}