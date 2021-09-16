import 'package:sqflite/sqflite.dart';

//declarando as variáveis das colunas do banco de dados
//como as variáveis não vão mudar em nenhum momento, podemos colocar final antes das variáveis
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";


class ContactHelper{

}

//molde de como esse contato vai ser criado:
//como não conseguimos guardar uma imagem diretamente no banco de dados utilizamos uma string
//utilizamos late pois a variável ainda não foi inicializada
//utilizaremos um construtor fromMap, pois nós vamos armazenar os contatos em formato de mapa
class Contact{
  late int id;
  late String name;
  late String email;
  late String phone;
  late String img;

  //pegado do mapa e passando pro contato
  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  //para guardar essas informações no sqlite precisamos transformar os contatos em um mapa
  Map toMap(){
    Map<String,dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    //id só será armazenado se ele existir
    if (id != null){
      map[idColumn] = id;
    }
    return map;
  }

  //para printar oas informações do contato de forma mais "amigável":
  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, image: $img";
  }


}
