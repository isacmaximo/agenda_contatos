//homepage

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'contact_page.dart';

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

    _getAllContacts();

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
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),

      //corpo da HomePage
        // vai ter uma listview dos contatos:
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index){
            //retora o widget do card do contato
            return _contactCard(context, index);
          },
      )
    );
  }

  //widget que vai ser o cartão do contato
  Widget _contactCard(BuildContext context, int index){
    //nesse card terá um GestureDetector para ações que venham a ocorrer durante uma interação com o usuário:
    return GestureDetector(
      //cartão:
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          //linha:
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                //configurando a imagem de contato para ficar circular:
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //foi criada uma pasta images, que vai conter uma imagem padrão caso o contato não tenha foto:
                  //temos que adicionar um assets no pubspec.yaml:  -images/person.png
                  //se já tiver alguma imagem então é  usada a imagem contato:
                  image: DecorationImage(image: contacts[index].img != null ?
                  FileImage(File(contacts[index].img)) :
                  //se não, então utilizamos a imagem padrão:
                  AssetImage("images/person.png")
                  ),
                ),
              ),
              //informações da linha (contato):
             Flexible(
               child: Padding(
                   padding: EdgeInsets.only(left: 10.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       //textos: nome, email e telefone
                       Text(contacts[index].name ?? "", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                       Text(contacts[index].email ?? "", style: TextStyle(fontSize: 18.0), overflow: TextOverflow.ellipsis),
                       Text(contacts[index].phone ?? "", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                     ],

                   )
               ),
             )

            ],
          ),
        ),
      ),
      onTap: (){
        //ao clicar, vai poder editar o respectivo o contato
        _showContactPage(contact: contacts[index]);
      },
      onLongPress: (){
        _showOptions(context, index);
      },
    );
  }

  //função para mostar opções ao clicar no card do contato:
  void _showOptions(BuildContext context, int index){
    //menu de opções do contato:
    showModalBottomSheet(
        context: context,
        builder: (context){
          //(BottomSheet > Container (tem um padding) > Column > Botões)
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  //ocupa a menor quantidade de espaço (que no caso são os botões de de ação do card):
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    //opção 1:
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextButton(
                          onPressed: (){
                            //ligar:
                            launch("tel:${contacts[index].phone}");
                            Navigator.pop(context);
                          },
                          child: Text("Ligar", style: TextStyle(color: Colors.red, fontSize: 20.0)),),
                    ),

                    //opção 2:
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                            _showContactPage(contact: contacts[index]);
                          },
                          child: Text("Editar", style: TextStyle(color: Colors.red, fontSize: 20.0))),
                    ),

                   Padding(
                     padding: EdgeInsets.all(10.0),
                     child:  //opção 3:
                     TextButton(
                         onPressed: (){
                           helper.deleteContact(contacts[index].id);
                           setState(() {
                             contacts.removeAt(index);
                             Navigator.pop(context);
                           });
                         },
                         child: Text("Excluir", style: TextStyle(color: Colors.red, fontSize: 20.0))),
                   )


                  ],
                ),
              );
            },
          );
        }
    );
  }

  //função para ir para tela de contato (editar contato):
  void _showContactPage({Contact contact}) async{
    //usamos o navigator para navegar para outra página
    final recContact = await Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage(contact: contact,)));

    //se receber algum contato
    if(recContact != null){
      //se eu tiver um contato:
      if(contact != null){
        //os contatos vão ser atualizados
        await helper.updateContact(recContact);
      }
      //se não passar um contato, então tem que ser salvo como um novo contato:
      else{
        await helper.saveContact(recContact);
      }
      //obtemos todos os contatos:
      _getAllContacts();
    }
  }

  void _getAllContacts(){

    helper.getAllContacts().then((list) {
      //utilizado para atualizar ua tela em tempo real
      setState(() {
        contacts = list;
      });
    });
  }

}
