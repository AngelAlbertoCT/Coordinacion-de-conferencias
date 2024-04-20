import 'package:booking_events/vistas/vista_usuario/pagina_principal_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/vistas/olvide_contrasena.dart';
import '/vistas/vista_admin/pagina_principal_admin.dart';
import '/vistas/registro_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';


class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  TextEditingController _usuarioController = TextEditingController();
  TextEditingController _contrasenaController = TextEditingController();

  validarSesion() async {
    showDialog(context: context, builder: (context){
      return Center(child: CircularProgressIndicator(),);
    });

    try {
      CollectionReference refUsuarios = FirebaseFirestore.instance.collection("Usuario");
      CollectionReference refAdministradores = FirebaseFirestore.instance.collection("Administrador");

      QuerySnapshot usuarios = await refUsuarios.where("Correo", isEqualTo: _usuarioController.text.trim()).get();
      QuerySnapshot administradores = await refAdministradores.where("Correo", isEqualTo: _usuarioController.text.trim()).get();

      if (usuarios.docs.isNotEmpty) {
        for (int i = 0; i < usuarios.docs.length; i++) {
            print("Usuario Encontrado" );
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _usuarioController.text.trim(),
                password: _contrasenaController.text.trim()
            );
            Navigator.push(context, MaterialPageRoute(builder: (builder) => PaginaPrincipalUsuario(nombre: usuarios.docs[i].get("Nombres"), paterno: usuarios.docs[i].get("Paterno"), materno: usuarios.docs[i].get("Materno"), carrera: usuarios.docs[i].get("Carrera"), numCuenta: usuarios.docs[i].get("NumCuenta"), correo: usuarios.docs[i].get("Correo"),)));
            return;
        }
      }

      if (administradores.docs.isNotEmpty) {
        for (int i = 0; i < administradores.docs.length; i++) {
            print("Usuario Encontrado");
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _usuarioController.text.trim(),
                password: _contrasenaController.text.trim()
            );
            Navigator.push(context, MaterialPageRoute(builder: (builder) => PaginaPrincipalAdministrador(nombre: administradores.docs[i].get("Nombres"), correo: administradores.docs[i].get("Correo"),)));
            return;
        }
      }
      Fluttertoast.showToast(
        msg: "Usuario no encontrado",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.black38,
        fontSize: 16.0,);
      print("Usuario no encontrado");
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Contraseña incorrecta",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.black38,
        fontSize: 16.0,);
      print("Error: " + e.toString());
    }
    Navigator.of(context).pop();
  }

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Iniciar Sesión'),
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
            TextField(
              keyboardType: TextInputType.emailAddress,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9@.\s ]+$')),
                //Filtra correo con dominio @aragon.unam.mx
                //FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')),
              ],
              controller: _usuarioController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Correo (@aragon.unam.mx)',
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _contrasenaController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Contraseña',
                suffixIcon: IconButton(
                  icon: _showPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    validarSesion();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
                  child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => const RegistroUsuario()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
                  child: const Text('Registrarse', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => const olvideContrasena()));
              },
              child: const Text(
                "Olvidé mi contraseña",
                style: TextStyle(
                  color: Colors.white, // Color del texto del enlace
                  decoration: TextDecoration.underline, // Subrayado para indicar que es un enlace
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
