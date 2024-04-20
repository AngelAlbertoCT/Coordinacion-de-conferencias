import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:booking_events/servicio/database.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  TextEditingController _nombresController = TextEditingController();
  TextEditingController _paternoController = TextEditingController();
  TextEditingController _maternoController = TextEditingController();
  TextEditingController _correoController = TextEditingController();
  TextEditingController _numCuentaController = TextEditingController();
  TextEditingController _carreraController = TextEditingController();
  TextEditingController _contrasenaController = TextEditingController();

  // Lista de opciones para el DropdownButton
  List<String> opciones = [
    'INGENIERÍA CIVIL',
    'INGENIERÍA EN COMPUTACIÓN',
    'iNGENIERÍA ELÉCTRICA ELECTRÓNICA',
    'INGENIERÍA INDUSTRIAL',
    'INGENIERÍA MECÁNICA'
  ];

  // Variable para almacenar la opción seleccionada
  String? opcionSeleccionada;

  @override
  void initState() {
    super.initState();
  }

  bool validarCorreo(String correo) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    //RegExp regex = RegExp(r'^[a-zA-Z0-9_.+-]+@aragon\.unam\.mx$');
    return regex.hasMatch(correo);
  }

// Función para mostrar el diálogo
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[200],
          title: const Text(
            "¡ATENCIÓN!",
            textAlign: TextAlign.center,
          ),
          content: const Text(
              "¿Estás seguro de que tu información es correcta?",
              textAlign: TextAlign.center),
          actions: [
            MaterialButton(
              onPressed: () async {
                //En id se puede usar No cuenta en usuarios para busqueda optimizada
                Map<String, dynamic> agregarMapaPonencia = {
                  "Nombres": _nombresController.text,
                  "Paterno": _paternoController.text,
                  "Materno": _maternoController.text, //
                  "Correo": _correoController.text,
                  "NumCuenta": _numCuentaController.text,
                  "Carrera": _carreraController.text,
                  "Contraseña": _contrasenaController.text,
                  "Privilegio": "0",
                  "Id": _numCuentaController.text,
                };
                if(_nombresController.text.isNotEmpty &&
                    _paternoController.text.isNotEmpty &&
                    _maternoController.text.isNotEmpty &&
                    _correoController.text.isNotEmpty &&
                    _numCuentaController.text.isNotEmpty &&
                    _carreraController.text.isNotEmpty &&
                    _contrasenaController.text.isNotEmpty){
                  if(validarCorreo(_correoController.text)==true){
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _correoController.text.trim(),
                        password: _contrasenaController.text.trim()
                    );
                    await DatabaseMethods().agregarUsuario(agregarMapaPonencia, _numCuentaController.text).then((value) {
                      Fluttertoast.showToast(
                          msg: "Registro guardado con éxito",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.lightGreen,
                          textColor: Colors.black38,
                          fontSize: 16.0);
                    });
                    Navigator.pop(context);
                  }else{
                    Fluttertoast.showToast(
                        msg: "Correo no valido.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.black38,
                        fontSize: 16.0);
                    Navigator.pop(context);
                  }
                }else{
                  Fluttertoast.showToast(
                      msg: "Debes llenar todos los campos",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.black38,
                      fontSize: 16.0,);
                  Navigator.pop(context);
                }
              }, //Guardar información
              child: const Text("Guardar"),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Registrar usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            TextField(
              controller: _nombresController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Nombre(s)',
              ),
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$')),
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _paternoController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Apellido paterno',
              ),
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$')),
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _maternoController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Apellido materno',
              ),
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$')),
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _correoController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Correo institucional (@aragon.unam.mx)',
              ),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9@.\s ]+$')),
                //FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_.+-]+@aragon\.unam\.mx$')),
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 9,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: _numCuentaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Número de cuenta',
              ),
            ),
            const SizedBox(height: 20.0),
            InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.only(bottom: 12),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: opcionSeleccionada,
                onChanged: (String? newValue) {
                  setState(() {
                    opcionSeleccionada = newValue;
                    _carreraController.text = newValue!;
                  });
                },
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text(
                      '  Selecciona tu carrera',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  ...opciones.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _contrasenaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Contraseña',
              ),
            ),
            const SizedBox(height: 20.0),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () => _showDialog(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.inversePrimary),
              child: const Text('Finalizar registro',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w100)),
            ),
          ],
        ),
      ),
    );
  }
}
