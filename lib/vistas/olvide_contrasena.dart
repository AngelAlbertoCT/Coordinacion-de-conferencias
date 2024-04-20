import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class olvideContrasena extends StatefulWidget {
  const olvideContrasena({Key? key}) : super(key: key);

  @override
  State<olvideContrasena> createState() => _olvideContrasenaState();
}

class _olvideContrasenaState extends State<olvideContrasena> {
  final TextEditingController _correoController = TextEditingController();

  validarCorreo() async {

    try {
      CollectionReference refUsuarios = FirebaseFirestore.instance.collection("Usuario");
      CollectionReference refAdministradores = FirebaseFirestore.instance.collection("Administrador");

      QuerySnapshot usuarios = await refUsuarios.where("Correo", isEqualTo: _correoController.text.trim()).get();
      QuerySnapshot administradores = await refAdministradores.where("Correo", isEqualTo: _correoController.text.trim()).get();

      if (usuarios.docs.isNotEmpty) {
        print("Se entró a documentos");
        for (int i = 0; i < usuarios.docs.length; i++) {
          if (usuarios.docs[i].get("Correo") == _correoController.text.trim()) {
            print("Se encontró usuario: " + usuarios.docs[i].get("Correo"));
            await FirebaseAuth.instance.sendPasswordResetEmail(email: _correoController.text.trim());
            Fluttertoast.showToast(
              msg: "Correo enviado a " + _correoController.text.trim(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.black38,
              fontSize: 16.0,);
            print("Correo enviado");
            Navigator.of(context).pop();
            return;
          }
        }
      }/*else{
        Fluttertoast.showToast(
          msg: "No se encontró al usuario ingresado. Verifica que el correo esté escrito correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black38,
          fontSize: 16.0,);
      }*/

      if (administradores.docs.isNotEmpty) {
        print("Se entró a documentos");
        for (int i = 0; i < administradores.docs.length; i++) {
          if (administradores.docs[i].get("Correo") == _correoController.text.trim()) {
            print("Se encontró usuario: " + administradores.docs[i].get("Correo"));
            await FirebaseAuth.instance.sendPasswordResetEmail(email: _correoController.text.trim());
            Fluttertoast.showToast(
              msg: "Correo enviado a " + _correoController.text.trim(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.black38,
              fontSize: 16.0,);
            print("Correo enviado");
            Navigator.of(context).pop();
            return;
          }
        }
      }/*else{
        Fluttertoast.showToast(
          msg: "No se encontró al usuario ingresado. Verifica que el correo esté escrito correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black38,
          fontSize: 16.0,);
      }*/
    } on FirebaseAuthException catch (e) {
      print("Error: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Olvidé Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Image.asset(
              '/img/fes-unam-logo.png', // Ruta de la imagen
              height: 100, // Ajusta el alto de la imagen según tu necesidad
              width: 100, // Ajusta el ancho de la imagen según tu necesidad
            ),*/
            const Text(
              'Por favor ingresa tu correo institucional (@aragon.unam.mx) para poder reestablecer tu contraseña.',
              style: TextStyle(
                color: Colors.white, // Color blanco
                fontSize: 16, // Tamaño de fuente opcional
              ),
              textAlign: TextAlign.center, // Ajustar el texto al centro
            ),
            const SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _correoController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Correo institucional (@aragon.unam.mx)',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                validarCorreo();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
              child: const Text('Recuperar Contraseña', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
