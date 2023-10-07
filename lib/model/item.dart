import 'dart:io';

class Item {
  int? id;
  String nome = "";
  String descricao = "";
  dynamic valor;
  bool done = false;
  File? image;

  Item(this.nome, this.descricao, this.valor, this.image);

  Item.fromMap(Map<dynamic, dynamic> map) {
    this.id = map['id'];
    this.nome = map['name'];
    this.descricao = map['description'];
    this.valor = map['value'];
    this.done = map['done'] == 1 ? true : false;
    this.image = map['imagePath'] != '' ? File(map['imagePath']) : null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "name": this.nome,
      "description": this.descricao,
      "value": this.valor,
      "done": this.done,
      "imagePath": this.image != null ? this.image!.path : ""
    };
    return map;
  }

  @override
  String toString() {
    return "Item(id: $id, nome: $nome, descricao: $descricao, valor: $valor, done: $done, image: $image)";
  }
}
