import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportePdf extends StatelessWidget {
  final DocumentSnapshot reporte;

  const ReportePdf({Key? key, required this.reporte}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Accede a los datos de la catación usando el DocumentSnapshot
    // Ajusta 'field_name' según los campos de tu modelo de datos
    String titulo = reporte['titulo'];
    String proveedor = reporte['proveedor'];
    double puntaje = reporte['puntaje'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Reporte PDF'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Título: $titulo'),
            Text('Proveedor: $proveedor'),
            Text('Puntaje: $puntaje'),
            // Agrega aquí más widgets para mostrar otros detalles del reporte según tus necesidades
          ],
        ),
      ),
    );
  }
}
