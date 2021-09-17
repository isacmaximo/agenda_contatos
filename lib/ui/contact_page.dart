//aqui será a página onde podemos criar o contato, ou editar o contato:

import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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

  //criando um foco para o campo de nome:
  final _nameFocus = FocusNode();

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
    //usaremos o WillPopScope para poder configurar o botão de voltar ao editar ou criar um contato:
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          //se não tiver nome então aparece novo contato, se sim então aparece o nome que está salvo:
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        //botão de salvar
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            //ao pressionar o botão, se tiver algum nome no campo:
            if(_editedContact.name != null && _editedContact.name.isNotEmpty){
              //po volta a tela anterior (pois as telas são como pilhas então ele retira a de cima)
              //e retorna para a tela anterior o _editedContact
              Navigator.pop(context, _editedContact);
            }
            //se for um novo contato
            else{
              FocusScope.of(context).requestFocus(_nameFocus);

            }
          },
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
                onTap: () {
                  //depois posso fazer mais opções para colocar a opção de câmera
                  //aqui pega a  imagem da galeria:
                  ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                    if (file == null){
                      return;
                    }
                    setState(() {
                      _editedContact.img = file.path;
                    });

                  });
                }
              ),

              //campo1:
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
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
      ),
    );
  }

  //função que ao pressionar o botão de voltar na tela de editar ou criar um contato:
  Future<bool> _requestPop(){
    //se o usuário editou/digitou em um campo:
    if(_userEdited){
      //então é perguntado se quer salvar as alterações:
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancelar"), onPressed: (){
                    //retira a última tela(no caso o a tela de alerta)
                    Navigator.pop(context);
                },),
                TextButton( child: Text("Sim"), onPressed: (){
                  //volta duas telas, no caso para homepage
                  Navigator.pop(context);
                  Navigator.pop(context);
                },)
              ],
            );
          }
      );
      //se o usuário editou/digitou ele impede que saia e mostra o alert dialog
      return Future.value(false);
    }
    //se o usuário não digitou
    else{
      //pode voltar sem o alert dialog
      return Future.value(true);
    }
  }
}
