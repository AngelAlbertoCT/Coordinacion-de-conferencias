import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRGenerado extends StatefulWidget {
  QRGenerado({
    Key? key,
    required this.nombreUsuario,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.carrera,
    required this.numCuenta,
    required this.ponente,
    required this.tituloPonencia,
    required this.fechaHora,
    required this.lugarPonencia,
  }) : super(key: key);

  final String nombreUsuario;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String carrera;
  final String numCuenta;
  final String ponente;
  final String tituloPonencia;
  final String fechaHora;
  final String lugarPonencia;

  String generarQR() {
    print("Nombre(s) alumno: ${nombreUsuario}\nApellido paterno: ${apellidoPaterno}\nApellido paterno: ${apellidoMaterno}\nCarrera: ${carrera}\nNúmero de cuenta: ${numCuenta}\nPonente: ${ponente}\nConferencia: ${tituloPonencia}\nFecha y hora: ${fechaHora}\nLugar conferencia: ${lugarPonencia}");
    return "Nombre(s) alumno: ${nombreUsuario}\nApellido paterno: ${apellidoPaterno}\nApellido paterno: ${apellidoMaterno}\nCarrera: ${carrera}\nNúmero de cuenta: ${numCuenta}\nPonente: ${ponente}\nConferencia: ${tituloPonencia}\nFecha y hora: ${fechaHora}\nLugar conferencia: ${lugarPonencia}";
  }

  @override
  State<QRGenerado> createState() => _QRGeneradoState();
}

class _QRGeneradoState extends State<QRGenerado> {
  late String QRData;

  @override
  void initState() {
    super.initState();
    QRData = widget.generarQR();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.tituloPonencia),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: PrettyQrView.data(data: QRData),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
