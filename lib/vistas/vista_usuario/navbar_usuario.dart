import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/vistas/inicio_sesion.dart';

class NavbarUsuario extends StatefulWidget {
  const NavbarUsuario({super.key, required this.nombre, required this.correo});

  final String nombre;
  final String correo;

  @override
  State<NavbarUsuario> createState() => _NavbarUsuarioState();
}

class _NavbarUsuarioState extends State<NavbarUsuario> {

  void cerrarSesion() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => const InicioSesion()), (Route<dynamic> route) => false);
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[200],
          title: const Text("¡ATENCIÓN!", textAlign: TextAlign.center),
          content: const Text("¿Estás seguro de que quieres cerrar sesión?", textAlign: TextAlign.center),
          actions: [
            MaterialButton(
              onPressed: () {
                cerrarSesion();
                print("Sesión cerrada");
              },
              child: const Text("Cerrar sesión"),
            ),
            MaterialButton(
              onPressed: () {
                //Cancelar guardado
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: Text(widget.nombre),
            accountEmail: Text(widget.correo),
            currentAccountPicture: CircleAvatar(
                child: ClipOval(child: Image.asset('img/fes-aragon-unam-logo.png'),),
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("img/fes-edificio.jpg"), fit: BoxFit.cover)
              ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Cerrar sesión"),
            onTap: () => _showDialog(context)
          )
        ],
      ),
    );
  }
}
