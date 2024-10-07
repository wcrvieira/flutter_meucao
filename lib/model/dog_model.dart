class DogModel {
  final int? id;
  final String name;
  final int age;
  final String photoPath;

  DogModel(
      {this.id,
      required this.name,
      required this.age,
      required this.photoPath});

  // Convertendo um Dog em um Map para inserir no banco
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'photoPath': photoPath,
    };
  }

  // Convertendo um Map para um objeto Dog
  factory DogModel.fromMap(Map<String, dynamic> map) {
    return DogModel(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      photoPath: map['photoPath'],
    );
  }
}
