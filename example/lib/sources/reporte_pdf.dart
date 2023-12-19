import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Catacion {
  final String id;
  final String nameSample;
  final String provider;
  double? puntaje;

  Catacion({
    required this.id,
    required this.nameSample,
    required this.provider,
    this.puntaje,
  });
}

class ReportePdf extends StatefulWidget {
  const ReportePdf({Key? key}) : super(key: key);

  @override
  _ReportePdfState createState() => _ReportePdfState();
}

class _ReportePdfState extends State<ReportePdf> {
  List<Catacion> cataciones = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF'S"),
      ),
      body: FutureBuilder<List<Catacion>>(
        future: getCatacionesFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al obtener las cataciones'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay cataciones disponibles'));
          } else {
            cataciones = snapshot.data!;
            return ListView.builder(
              itemCount: cataciones.length,
              itemBuilder: (context, index) {
                final catacion = cataciones[index];
                return _buildOptionTile(
                  title: '${catacion.nameSample} - ${catacion.provider}',
                  subtitle: 'Puntaje: ${catacion.puntaje ?? "No registrado"}',
                  icon: Icons.picture_as_pdf,
                  onTap: () {
                    // Aquí debes implementar la lógica para descargar o abrir el PDF
                    // Puedes utilizar alguna librería o método para realizar esta acción
                    // Por ejemplo, puedes utilizar la librería open_file para abrir el PDF
                    // openFile('/ruta/del/archivo.pdf');
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Function() onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.green),
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.download),
        onTap: onTap,
      ),
    );
  }

  Future<List<Catacion>> getCatacionesFromFirebase() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('cataciones').get();
      return querySnapshot.docs.map((doc) {
        return Catacion(
          id: doc.id,
          nameSample: doc['nameSample'],
          provider: doc['provider'],
          puntaje: doc['puntaje']?.toDouble(),
        );
      }).toList();
    } catch (e) {
      print('Error al obtener cataciones: $e');
      return [];
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: ReportePdf(),
  ));
}
