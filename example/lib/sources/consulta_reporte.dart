import 'package:example/sources/reporte_pdf.dart';
import 'package:flutter/material.dart';

class ConsultaReporte extends StatelessWidget {
  const ConsultaReporte({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.search,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const Text(
              'Inserta el código del reporte',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              width: 200,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Código del reporte',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportePdf()),
                );
                // Aquí puedes agregar la lógica para buscar el reporte
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Cambia el color del botón aquí
              ),
              child: const Text('Buscar'),
            ),
          ],
        ),
      ),
    );
  }
}
