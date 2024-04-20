import 'package:booking_events/servicio/database.dart';
import 'package:booking_events/vistas/vista_usuario/navbar_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'qr_generador.dart';
import 'package:flutter/services.dart';

class PaginaPrincipalUsuario extends StatefulWidget {
  const PaginaPrincipalUsuario({super.key, required this.nombre, required this.paterno, required this.materno, required this.carrera, required this.numCuenta, required this.correo});

  final String nombre;
  final String paterno;
  final String materno;
  final String carrera;
  final String numCuenta;
  final String correo;

  @override
  _PaginaPrincipalUsuarioState createState() => _PaginaPrincipalUsuarioState();
}

class _PaginaPrincipalUsuarioState extends State<PaginaPrincipalUsuario> {
  TextEditingController lugaresDisponiblesController = TextEditingController();

  Stream? PonenciaStream;
  Stream? UsuarioStream;

  final user = FirebaseAuth.instance.currentUser?.updatePassword("newPassword");

  getontheload() async {
    PonenciaStream = await DatabaseMethods().getDetallesPonencia();
    UsuarioStream = await DatabaseMethods().getDetallesUsuario();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Future<void> registrarUsuario(DocumentSnapshot ds) async {
    int lugaresDisponibles = int.parse(ds["LugaresDisponibles"]);
    if (lugaresDisponibles > 0) {
      lugaresDisponibles--;
      lugaresDisponiblesController.text = lugaresDisponibles.toString();
      ds.reference
          .update({"LugaresDisponibles": lugaresDisponiblesController.text});
      // Navegar a la página QRGenerado después de registrar al usuario
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRGenerado(
            nombreUsuario: widget.nombre,
            apellidoPaterno: widget.paterno,
            apellidoMaterno: widget.materno,
            carrera: widget.carrera,
            numCuenta: widget.numCuenta,
            ponente: ds["Ponente"],
            tituloPonencia: ds["Ponencia"],
            fechaHora: ds["Fecha"],
            lugarPonencia: ds["LugarPonencia"],
          ),
        ),
      );
      print('Evento registrado correctamente.');
      Fluttertoast.showToast(
          msg: "Evento registrado correctamente.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.black38,
          fontSize: 16.0);
    } else {
      print('No hay lugares disponibles');
      Fluttertoast.showToast(
          msg: "No hay lugares disponibles",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black38,
          fontSize: 16.0);
    }
  }

  Widget allDetallesPonencia() {
    return StreamBuilder(
        stream: PonenciaStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xFFCFB53B),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Ponente: ",
                                    style: TextStyle(
                                        color: Color(0xFF3B55CF),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Text(
                                      ds["Ponente"],
                                      style: const TextStyle(
                                          color: Color(0xFF6BA45B),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Ponencia: ",
                                    style: TextStyle(
                                        color: Color(0xFF3B55CF),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Text(
                                      ds["Ponencia"],
                                      style: const TextStyle(
                                          color: Color(0xFF6BA45B),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Fecha y hora: ",
                                    style: TextStyle(
                                        color: Color(0xFF3B55CF),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ds["Fecha"],
                                    style: const TextStyle(
                                        color: Color(0xFF6BA45B),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Lugar: ",
                                    style: TextStyle(
                                        color: Color(0xFF3B55CF),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Text(
                                      ds["LugarPonencia"],
                                      style: const TextStyle(
                                          color: Color(0xFF6BA45B),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Lugares disponibles: ",
                                    style: TextStyle(
                                        color: Color(0xFF3B55CF),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ds["LugaresDisponibles"],
                                    style: const TextStyle(
                                        color: Color(0xFF6BA45B),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    registrarUsuario(ds);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(
                                        0xFF3B55CF), // Cambia el color de fondo del botón
                                  ),
                                  child: const Text(
                                    'Registrarse',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio ' + widget.nombre),
      ),
      drawer: NavbarUsuario(nombre: widget.nombre, correo: widget.correo),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [Expanded(child: allDetallesPonencia())],
        ),
      ),
    );
  }
}
