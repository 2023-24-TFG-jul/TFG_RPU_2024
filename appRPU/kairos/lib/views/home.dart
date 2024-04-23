import 'package:flutter/material.dart';
import 'package:kairos/models/user.dart';

class Home extends StatefulWidget {
  const Home ({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text ('Home'),
      ),
      body: FutureBuilder(
        future: getUsers(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: ((context, index){
                return Text(snapshot.data?[index]['name']);
              }));
          } else {
            return const Center(
              child: CircularProgressIndicator()
            );
          }
        }
      )
    );
  }
}