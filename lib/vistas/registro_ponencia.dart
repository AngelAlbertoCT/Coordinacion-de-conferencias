import 'package:booking_events/servicio/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

class RegistroPonencia extends StatefulWidget {
  const RegistroPonencia({super.key});

  @override
  _RegistroPonenciaState createState() => _RegistroPonenciaState();
}

class _RegistroPonenciaState extends State<RegistroPonencia> {
  TextEditingController nombrePonenteController = TextEditingController();
  TextEditingController nombrePonenciaController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController lugarSeleccionadoController = TextEditingController();
  String? lugarSeleccionado; // Variable para almacenar la opción seleccionada en dropdown
  TextEditingController lugaresDisponiblesController = TextEditingController();

  late DateTime fechaSeleccionada;

  List<String> opciones = [
    'TEATRO JOSÉ VASCONCELOS',
    'AUDITORIO A1 "HERMILA GALINDO"',
    'AUDITORIO DEL CENTRO TECNOLOGICO "M. EN I. CLAUDIO CARL MERREFIELD CASTRO"',
    'AUDITORIO A9',
    'EXPLANADA L1 - L2',
    'AUDITORIO DUACYD',
    'VIDEOCONFERENCIA'];

  @override
  void initState() {
    super.initState();
    fechaSeleccionada = DateTime.now();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Registrar Ponencia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            TextField(
              controller: nombrePonenteController,
              decoration:  const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Nombre del ponente',
              ),
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$')),],
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: nombrePonenciaController,
              decoration:  const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Nombre de la ponencia',
              ),
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9áéíóúÁÉÍÓÚüÜñÑ\s(),;./"¡!¿?]+$')),],
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
                value: lugarSeleccionado,
                onChanged: (String? newValue) {
                  setState(() {
                    lugarSeleccionado = newValue;
                    lugarSeleccionadoController.text = newValue!;
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
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 4,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              controller: lugaresDisponiblesController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Lugares disponibles',
              ),
            ),
            const SizedBox(height: 20.0),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed:() async{
                //En id se puede usar No cuenta en usuarios para busqueda optimizada
                String id=randomAlphaNumeric(10);
                Map<String, dynamic> agregarMapaPonencia={
                  "Ponente": nombrePonenteController.text,
                  "Ponencia": nombrePonenciaController.text,
                  "Fecha": dateTimeController.text,//
                  "LugarPonencia": lugarSeleccionadoController.text,
                  "LugaresDisponibles": lugaresDisponiblesController.text,
                  "Id": id,
                };
                if(nombrePonenteController.text.isNotEmpty &&
                    nombrePonenciaController.text.isNotEmpty &&
                    dateTimeController.text.isNotEmpty &&
                    lugarSeleccionadoController.text.isNotEmpty &&
                    lugaresDisponiblesController.text.isNotEmpty){
                  await DatabaseMethods().agregarPonencia(agregarMapaPonencia, id).then((value){
                    Fluttertoast.showToast(
                        msg: "Registro guardado con éxito.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.lightGreen,
                        textColor: Colors.black38,
                        fontSize: 16.0
                    );
                  });
                  Navigator.pop(context);
                }else{
                  Fluttertoast.showToast(
                      msg: "Debes llenar todos los campos.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.black38,
                      fontSize: 16.0);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
              child: const Text('Finalizar registro',style: TextStyle(color: Colors.black, fontWeight: FontWeight.w100)),
            ),
          ],
        ),
      ),
    );
  }

}
