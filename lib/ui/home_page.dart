//homepage

import 'package:flutter/material.dart';
import 'package:agenda_de_contatos/helpers/contact_helper.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //precisamos obter a classe ContactHelper para acessar o banco de dados:
  ContactHelper helper = ContactHelper();

  //lista de contatos começa vazia aqui na home page
  List<Contact> contacts = [];

  //quando app iniciar todos os contatos vão ser carregados:
  @override
  void initState() {
    super.initState();

    helper.getAllContacts().then((list) {
      //utilizado para atualizar ua tela em tempo real
    setState(() {
        contacts = list;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    //tela da home page
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      //botão flutuante:
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      //corpo da HomePage
        //vai ter uma listview dos contatos:
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index){

          },
      )
    );
  }
}
