import 'package:app_meucao/database/sql_helper.dart';
import 'package:app_meucao/model/dog_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DogForm extends StatefulWidget {
  final DogModel? dog;

  const DogForm({super.key, this.dog});

  @override
  _DogFormState createState() => _DogFormState();
}

class _DogFormState extends State<DogForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _age = 0;
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.dog != null) {
      _name = widget.dog!.name;
      _age = widget.dog!.age;
      _image = File(widget.dog!.photoPath);
    }
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final dog = DogModel(
        id: widget.dog?.id,
        name: _name,
        age: _age,
        photoPath: _image!.path,
      );

      if (widget.dog == null) {
        await DatabaseHelper.instance.createDog(dog);
      } else {
        await DatabaseHelper.instance.updateDog(dog);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.dog == null ? 'Cadastrar Cachorro' : 'Editar Cachorro'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite um nome';
                  }
                  return null;
                },
                onChanged: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                initialValue: _age.toString(),
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Digite uma idade válida';
                  }
                  return null;
                },
                onChanged: (value) {
                  _age = int.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 10),
              _image == null
                  ? const Text('Nenhuma imagem selecionada.')
                  : Image.file(_image!, height: 200),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Tirar Foto'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
