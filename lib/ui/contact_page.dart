//aqui será a página onde podemos criar o contato, ou editar o contato:

import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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

  //controladores para os textfields:
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  //variável booleana que vai iniciar falsa para editado
  bool _userEdited = false;

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

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            //como a imagem vai ser clicada:
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                //configurando a imagem de contato para ficar circular:
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: _editedContact.img != null ?
                  FileImage(File(_editedContact.img)) :
                  //se não, então utilizamos a imagem padrão:
                  AssetImage("images/person.png")
                  ),
                ),
              ),
            ),

            //campo1:
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nome"),
              //indica se o texto foi alterado:
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editedContact.name = text;
                });
              },
            ),

            //campo2:
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "E-mail"),
              //indica se o texto foi alterado:
              onChanged: (text) {
                _userEdited = true;
                _editedContact.email = text;
              }
            ),

            //campo3:
            //podemos adicionar no pubspec.yaml: masked_text_input_formatter: ^0.0.1
            //para utilizar o formato de que quiser, no caso poderia ser:
            // inputFormatters: [
            //   MaskedTextInputFormatter(
            //       mask: 'x-xxxx-xxxx',
            //       separator: '-')
            // ],
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Phone"),
                //indica se o texto foi alterado:
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.phone = text;
                }
            ),

          ],
        ),
      ),
    );
  }
}
