import 'package:flutter/material.dart';
import 'package:flutter_anuncios/model/item.dart';

class CadastroScreen extends StatefulWidget {
  Item? itens;
  CadastroScreen({this.itens});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _valorController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.itens != null) {
      setState(() {
        _nomeController.text = widget.itens!.nome;
        _descricaoController.text = widget.itens!.descricao;
        _valorController.text = widget.itens!.valor.toString();
      });
    }
  }

  String _validateDouble(String value) {
    try {
      // Tenta fazer o parsing do valor para double
      double.parse(value);
      return 'true'; // Valor é um double válido
    } catch (e) {
      return 'Digite um número válido'; // Valor não é um double válido
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cadastro de Item",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: TextFormField(
                controller: _nomeController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: "Produto",
                  labelStyle: TextStyle(fontSize: 18),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Preenchimento Obrigatorio!";
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: TextFormField(
                controller: _descricaoController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: "Descricão",
                  labelStyle: TextStyle(fontSize: 18),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Preenchimento Obrigatorio!";
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: TextFormField(
                controller: _valorController,
                style: const TextStyle(fontSize: 18),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    label: Text(
                      "Digite o valor do produto",
                      style: TextStyle(fontSize: 18),
                    ),
                    prefixText: "R\$ "),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Preenchimento Obrigatorio!";
                  }
                },
              ),
            ),
            Row(children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  child: ElevatedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () {
                      try {
                        print("batata2");
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          Item newItem = Item(
                            _nomeController.text,
                            _descricaoController.text,
                            double.parse(_valorController.text),
                          );
                          Navigator.pop(context, newItem);
                        }
                      } catch (error) {
                        print("batata3");
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text(
                              'Digite um valor valido para o produto',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  child: ElevatedButton(
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
