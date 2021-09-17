//aqui será a página onde podemos criar o contato, ou editar o contato:

import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

//como podemos interagir, será stateful
class ContactPage extends StatefulWidget {

  //esse construtor vai servir para que eu possa passar um contato que eu queira editar:
  final Contact contact;
  //o parâmetro é opicional então colocamos entre chaves
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  //aqui vai ser representado o contato editado:
  Contact _editedContact;

  //quando a página iniciar
  @override
  void initState() {
    super.initState();
    //se o contato for nulo:
    //usamos widget. para acessar coisas de outra classe:
    if (widget.contact == null){
      //então será um novo contato:
      _editedContact = Contact();
    }
    else{
      //criando um novo contato através de um mapa:
      //basicamente estamos duplicando um contato e colocando no _editedContact:
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }

  }

  @override
  Widget build(BuildContext context) {
    //layout da página:
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        //se não tiver nome então aparece novo contato, se sim então aparece o nome que está salvo:
        title: Text(_editedContact.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      //botão de salvar
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
    );
  }
}
