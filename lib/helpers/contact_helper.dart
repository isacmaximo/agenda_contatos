import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

//declarando as variáveis das colunas do banco de dados
//como as variáveis não vão mudar em nenhum momento, podemos colocar final antes das variáveis
final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";


class ContactHelper{
  //padrão para ter apenas um objeto da classe: singleton
  //estou criando um objeto dessa própia classe (_instance)
  //só pode ser chamado dentro dessa classe
  //em resumo: a classe tem apenas uma instância que pode ser acessada de qualquer local
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  //declarando o banco de dados
  late Database _db;

  Future<Database> get db async {
    //se o banco de dado já estiver inicializado:
    if (_db != null){
      return _db;
    }
    //se o banco de dados não estiver inicializado:
    else{
      _db = await initDB();
      return _db;
    }
  }

  //função que vai inicializar o banco de dados
  Future<Database> initDB() async {
    //temos que esperar, pois não é instantâneo
    //aqui é o caminho:
    final databasesPath = await getDatabasesPath();
    //caminho que tem o arquivo do banco de dados
    final path = join(databasesPath, "contacts.db");

    //abrindo o banco de dados:
    //caminho, versão, função que cria um banco de dados
    //esta função só é ativada para criar o banco de dados pela primeira vez
    return await openDatabase(path, version: 1, onCreate: (Database db, int newVersion) async{
      await db.execute(
        //comando para criar o banco de dados: nometabela(coluna1 tipo, coluna2 tipo)...
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)"

      );
    });
  }


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
