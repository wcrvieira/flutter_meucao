import 'dart:io';

import 'package:app_meucao/database/sql_helper.dart';
import 'package:app_meucao/model/dog_model.dart';
import 'package:flutter/material.dart';

import 'dog_form.dart';

class DogList extends StatefulWidget {
  @override
  _DogListState createState() => _DogListState();
}

class _DogListState extends State<DogList> {
  List<DogModel> _dogs = [];

  @override
  void initState() {
    super.initState();
    _loadDogs();
  }

  Future<void> _loadDogs() async {
    final dogs = await DatabaseHelper.instance.getAllDogs();
    setState(() {
      _dogs = dogs;
    });
  }

  void _deleteDog(int id) async {
    await DatabaseHelper.instance.deleteDog(id);
    _loadDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(180, 25, 112, 80),
        title: const Text(
          'Lista de Cachorros',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Tahoma',
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(
                      MaterialPageRoute(builder: (context) => const DogForm()))
                  .then((_) => _loadDogs());
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _dogs.length,
        itemBuilder: (context, index) {
          final dog = _dogs[index];
          return ListTile(
            leading: Image.file(File(dog.photoPath)),
            title: Text(dog.name),
            subtitle: Text('Idade: ${dog.age}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteDog(dog.id!),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => DogForm(dog: dog),
                  ))
                  .then((_) => _loadDogs());
            },
          );
        },
      ),
    );
  }
}
