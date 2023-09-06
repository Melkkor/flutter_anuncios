import 'package:flutter/material.dart';
import 'package:flutter_anuncios/model/item.dart';
import 'package:flutter_anuncios/screens/cadastro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> _lista = List.empty(growable: true);

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
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                setState(() {
                  print("removeu");
                  _lista.removeAt(index);
                });
              }
            },
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                Item editedItem = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroScreen(itens: produto),
                    ));
                if (editedItem != null) {
                  setState(() {
                    _lista.removeAt(index);
                    _lista.insert(index, editedItem);
                  });
                }
                return false;
              } else if (direction == DismissDirection.startToEnd) {
                return true;
              }
            },
            child: ListTile(
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
              onLongPress: () async {
                Item editedItem = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroScreen(itens: produto),
                    ));
                if (editedItem != null) {
                  setState(() {
                    _lista.removeAt(index);
                    _lista.insert(index, editedItem);
                  });
                }
              },
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
            setState(() {
              _lista.add(item);
            });
          } catch (error) {
            print("Error: ${error.toString()}");
          }
        },
      ),
    );
  }
}
