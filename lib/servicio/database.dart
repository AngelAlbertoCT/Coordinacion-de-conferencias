import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  //CRUD PONENCIA
  Future agregarPonencia(Map<String, dynamic> mapaPonencia, String id) async{
      return await FirebaseFirestore.instance.collection("Ponencia").doc(id).set(mapaPonencia);
  }

  Future<Stream<QuerySnapshot>> getDetallesPonencia() async{
    return FirebaseFirestore.instance.collection("Ponencia").snapshots();
  }

  Future actualizarPonencia(String id, Map<String, dynamic> actualizaInfo) async{
    return await FirebaseFirestore.instance.collection("Ponencia").doc(id).update(actualizaInfo);
  }

  Future eliminarPonencia(String id) async{
    return await FirebaseFirestore.instance.collection("Ponencia").doc(id).delete();
  }

  //CRUD USUARIOS
  Future agregarUsuario(Map<String, dynamic> mapaPonencia, String id) async{
    return await FirebaseFirestore.instance.collection("Usuario").doc(id).set(mapaPonencia);
  }

  Future<Stream<QuerySnapshot>> getDetallesUsuario() async{
    return FirebaseFirestore.instance.collection("Usuario").snapshots();
  }

  Future actualizarUsuario(String id, Map<String, dynamic> actualizaInfo) async{
    return await FirebaseFirestore.instance.collection("Usuario").doc(id).update(actualizaInfo);
  }

  Future eliminarUsuario(String id) async{
    return await FirebaseFirestore.instance.collection("Usuario").doc(id).delete();
  }

  //CRUD Administradores
  Future agregarAdmin(Map<String, dynamic> mapaPonencia, String id) async{
    return await FirebaseFirestore.instance.collection("Administrador").doc(id).set(mapaPonencia);
  }

  Future<Stream<QuerySnapshot>> getDetallesAdmin() async{
    return FirebaseFirestore.instance.collection("Administrador").snapshots();
  }

  Future actualizarAdmin(String id, Map<String, dynamic> actualizaInfo) async{
    return await FirebaseFirestore.instance.collection("Administrador").doc(id).update(actualizaInfo);
  }

  Future eliminarAdmin(String id) async{
    return await FirebaseFirestore.instance.collection("Administrador").doc(id).delete();
  }

}