import 'package:booking_events/servicio/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../vista_admin/navbar_admin.dart';
import '/vistas/registro_ponencia.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PaginaPrincipalAdministrador extends StatefulWidget {
  const PaginaPrincipalAdministrador({super.key, required this.nombre, required this.correo});

  final String nombre;
  final String correo;

  @override
  _PaginaPrincipalAdministradorState createState() =>
      _PaginaPrincipalAdministradorState();
}

class _PaginaPrincipalAdministradorState
    extends State<PaginaPrincipalAdministrador> {
  TextEditingController nombrePonenteController = TextEditingController();
  TextEditingController nombrePonenciaController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController lugarSeleccionadoController = TextEditingController();
  TextEditingController lugaresDisponiblesController = TextEditingController();

  late DateTime fechaSeleccionada;

  List<String> opciones = [
    'TEATRO JOSÉ VASCONCELOS',
    'AUDITORIO A1 "HERMILA GALINDO"',
    'AUDITORIO DEL CENTRO TECNOLOGICO "M. EN I. CLAUDIO CARL MERREFIELD CASTRO"',
    'AUDITORIO A9',
    'EXPLANADA L1 - L2',
    'AUDITORIO DUACYD',
    'VIDEOCONFERENCIA'
  ];
  Stream? PonenciaStream;

  //Función para seleccionar fecha
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(fechaSeleccionada),
      );
      if (pickedTime != null) {
        setState(() {
          fechaSeleccionada = DateTime(picked.year, picked.month, picked.day, pickedTime.hour, pickedTime.minute);
          String formattedDate = DateFormat('dd/MM/yyyy').format(fechaSeleccionada);
          String formattedTime = "";
          if(pickedTime.minute<10){
            formattedTime = '${pickedTime.hour}:0${pickedTime.minute}';
          }else{
            formattedTime = '${pickedTime.hour}:${pickedTime.minute}';
          }
          dateTimeController.text = '$formattedDate   -   $formattedTime hrs';
        });
      }
    }
  }

  getontheload() async {
    PonenciaStream = await DatabaseMethods().getDetallesPonencia();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
    fechaSeleccionada = DateTime.now();
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
                              Row(
                                children: [
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      nombrePonenteController.text=ds["Ponente"];
                                      nombrePonenciaController.text=ds["Ponencia"];
                                      dateTimeController.text=ds["Fecha"];
                                      lugarSeleccionadoController.text=ds["LugarPonencia"];
                                      lugaresDisponiblesController.text=ds["LugaresDisponibles"];
                                      editarPonencia(ds["Id"]);
                                    },
                                    child: const Icon(
                                      Icons.edit, color: Color(0xFF3B55CF),
                                    )
                                  ),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () async{
                                      await DatabaseMethods().eliminarPonencia(ds["Id"]);
                                    },
                                    child: const Icon(Icons.delete, color: Color(0xFF3B55CF)),
                                  )
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Ponente: " ,
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
      drawer: NavbarAdmin(nombre: widget.nombre, correo: widget.correo),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [Expanded(child: allDetallesPonencia())],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const RegistroPonencia()));
            },
            tooltip: 'Agregar evento nuevo',
            child: const Icon(
              Icons.playlist_add_rounded,
              color: Color(0xFF06132f),
            ),
          ),
        ],
      ),
    );
  }

  Future editarPonencia(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel)),
                        const SizedBox(
                          width: 60,
                        ),
                        const Text("Editar ponencia",
                            style: TextStyle(
                                color: Colors.cyan,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: nombrePonenteController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Nombre del ponente',
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$')),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: nombrePonenciaController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Nombre de la ponencia',
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-Z0-9áéíóúÁÉÍÓÚüÜñÑ\s(),;./"¡!¿?]+$')),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: dateTimeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Fecha y hora de la ponencia',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDateTime(context),
                        ),
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
                        value: lugarSeleccionadoController.text,//.isNotEmpty ? lugarSeleccionadoController.text : null,
                        onChanged: (String? newValue) {
                          setState(() {
                            lugarSeleccionadoController.text = newValue! ;
                          });
                        },
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text(
                              '  Lugar de la ponencia',
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
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: lugaresDisponiblesController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Lugares disponibles',
                      ),
                    ),
                    ElevatedButton(onPressed: () async{
                      Map<String, dynamic> actualizaInfo={
                        "Ponente": nombrePonenteController.text,
                        "Ponencia": nombrePonenciaController.text,
                        "Fecha": dateTimeController.text,
                        "LugarPonencia": lugarSeleccionadoController.text,
                        "LugaresDisponibles": lugaresDisponiblesController.text,
                      };
                      await DatabaseMethods().actualizarPonencia(id, actualizaInfo).then((value){
                        Navigator.pop(context);
                      });
                    }, child: Text("Actualizar"))
                  ],
                ),
              ),
            )
          ));
}
