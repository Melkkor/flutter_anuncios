import 'package:flutter/material.dart';
import 'package:flutter_anuncios/model/item.dart';
import 'package:flutter_anuncios/screens/cadastro_screen.dart';
import 'package:flutter_anuncios/database/item_helper.dart';
import 'package:flutter_anuncios/persistance/file_persistance.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> _lista = List.empty(growable: true);
  ItemHelper _helper = ItemHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _helper.getAll().then((data) {
      setState(() {
        if (data != null) {
          _lista = data;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Anuncios",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),
      body: ListView.separated(
        itemCount: _lista.length,
        itemBuilder: (context, index) {
          Item produto = _lista[index];
          return Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
              child: const Align(
                  alignment: Alignment(-0.95, 0),
                  child: Icon(Icons.delete, color: Colors.white)),
            ),
            secondaryBackground: Container(
              color: Colors.orange,
              child: const Align(
                  alignment: Alignment(0.95, 0),
                  child: Icon(Icons.edit, color: Colors.white)),
            ),
            onDismissed: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                var result = await _helper.deleteItem(produto);
                if (result != null) {
                  setState(() {
                    _lista.removeAt(index);

                    const snackbar = SnackBar(
                      content: Text("Tarefa apagada com sucesso!"),
                      backgroundColor: Colors.red,
                    );
                  });
                }
              }
            },
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                Item editedItem = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroScreen(itens: produto),
                    ));
                var result = await _helper.updateItem(editedItem);

                if (result != null) {
                  setState(() {
                    _lista.removeAt(index);
                    _lista.insert(index, editedItem);

                    const snackbar = SnackBar(
                      content: Text("Tarefa Editada com sucesso!"),
                      backgroundColor: Colors.orange,
                    );
                  });
                }
                return false;
              } else if (direction == DismissDirection.startToEnd) {
                return true;
              }
            },
            child: ListTile(
              leading: produto.image != null
                  ? CircleAvatar(
                      child: ClipOval(
                        child: Image.file(produto.image!),
                      ),
                    )
                  : const SizedBox(),
              title: Text(
                produto.nome,
                style: TextStyle(
                  fontSize: 18,
                  color: produto.done ? Colors.grey : Colors.black,
                  decoration: produto.done
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                produto.descricao,
                style: TextStyle(
                  color: produto.done ? Colors.grey : Colors.black,
                  decoration: produto.done
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: Text(
                "R\$ ${produto.valor}",
                style: TextStyle(
                  fontSize: 18,
                  color: produto.done ? Colors.grey : Colors.black,
                  decoration: produto.done
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              onTap: () {
                setState(
                  () {
                    produto.done = !produto.done;
                  },
                );
              },
              // onLongPress: () async {
              //   Item editedItem = await Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => CadastroScreen(itens: produto),
              //       ));
              //   if (editedItem != null) {
              //     setState(() {
              //       _lista.removeAt(index);
              //       _lista.insert(index, editedItem);
              //     });
              //   }
              // },
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          try {
            Item item = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => CadastroScreen()));
            Item? savedItem = await _helper.saveItem(item);
            if (savedItem != null) {
              setState(() {
                _lista.add(item);
                final snackBar = SnackBar(
                  content: Text('Item criado com sucesso!'),
                  backgroundColor: Colors.green,
                );
              });
            }
          } catch (error) {
            print("Error: ${error.toString()}");
          }
        },
      ),
    );
  }
}
