//App Agenda de Contatos

//plugins necessários:
// sqflite: ^1.1.5
// url_launcher: ^5.0.2
// image_picker: ^0.6.0+3

//vamos adicionar uma pasta dentro de lib chamada helpers,
//está pasta contém as classes que ajudarão o código

//dentro da pasta helpers vai ter um dart file chamado contact_helper,
//que sera´uma classe que irá ajudar a obter os contatos

//as telas estarão na pasta ui

//libraries necessárias
import 'package:flutter/material.dart';
import 'package:agenda_de_contatos/ui/home_page.dart';

//função principal
void main(){
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
