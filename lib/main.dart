import 'package:app_meucao/view/dog_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dog CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DogList(),
    );
  }
}
