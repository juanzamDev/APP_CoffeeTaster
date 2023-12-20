import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:fl_chart/fl_chart.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reporte extends StatefulWidget {
  final String catacionId;

  const Reporte({Key? key, required this.catacionId}) : super(key: key);

  @override
  State<Reporte> createState() => _ReporteState();
}

class _ReporteState extends State<Reporte> {
  String producerName = '';
  final _formKey = GlobalKey<FormBuilderState>();
  String sesionName = '';
  String formattedDate = '';

  final gridColor = Colors.deepPurple;
  final titleColor = Colors.deepPurple;
  final fashionColor = Colors.red;
  final artColor = Colors.cyan;
  final boxingColor = Colors.green;
  final entertainmentColor = Colors.white;
  final offRoadColor = Colors.yellow;

  List<Map<String, dynamic>> reportData = [];
  List<double> spiderChartValues = [];

  int selectedDataSetIndex = -1;
  double angleValue = 0;
  bool relativeAngleMode = true;

  final GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _consultarReporte();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Text("Reporte", style: TextStyle(color: Colors.white)),
            const Spacer(),
            Image.asset(
              'assets/sennova.png',
              height: 30,
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  sesionName.isNotEmpty ? sesionName : 'Reporte',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  producerName.isNotEmpty ? producerName : 'Sin productor',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  formattedDate.isNotEmpty ? formattedDate : 'Sin fecha',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Categoria')),
                    DataColumn(label: Text('Valor')),
                  ],
                  rows: reportData.map<DataRow>((row) {
                    return DataRow(cells: [
                      DataCell(Text(row['Categoria'])),
                      DataCell(Text(row['Valor'].toString())),
                    ]);
                  }).toList(),
                ),
                const SizedBox(height: 20),
                if (spiderChartValues.isNotEmpty)
                  Container(
                    height: 300,
                    child: RepaintBoundary(
                      key: globalKey,
                      child: RadarChart(
                        RadarChartData(
                          dataSets: [
                            RadarDataSet(
                              dataEntries: spiderChartValues
                                  .map((value) => RadarEntry(value: value))
                                  .toList(),
                              fillColor: const Color.fromARGB(120, 94, 141, 80),
                              borderColor:
                                  const Color.fromARGB(255, 20, 134, 49),
                              borderWidth: 2.0,
                              entryRadius: 5.0,
                            ),
                          ],
                          borderData: FlBorderData(show: true),
                          radarBorderData: const BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          titlePositionPercentageOffset: 0.2,
                          titleTextStyle: TextStyle(fontSize: 12),
                          getTitle: (index, angle) {
                            final usedAngle = relativeAngleMode
                                ? angle + angleValue
                                : angleValue;
                            switch (index) {
                              case 0:
                                return RadarChartTitle(
                                  text: 'F',
                                  angle: usedAngle,
                                );
                              case 1:
                                return RadarChartTitle(
                                  text: 'A',
                                  angle: usedAngle,
                                );
                              case 2:
                                return RadarChartTitle(
                                  text: 'C',
                                  angle: usedAngle,
                                );
                              case 3:
                                return RadarChartTitle(
                                  text: 'B',
                                  angle: usedAngle,
                                );
                              case 4:
                                return RadarChartTitle(
                                  text: 'S',
                                  angle: usedAngle,
                                );
                              case 5:
                                return RadarChartTitle(
                                  text: 'R',
                                  angle: usedAngle,
                                );
                              case 6:
                                return RadarChartTitle(
                                  text: 'G',
                                  angle: usedAngle,
                                );
                              default:
                                return const RadarChartTitle(text: '');
                            }
                          },
                        ),
                        swapAnimationDuration:
                            const Duration(milliseconds: 150),
                        swapAnimationCurve: Curves.linear,
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                MaterialButton(
                  color: Colors.green,
                  child: const Text(
                    "Descargar reporte",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    _formKey.currentState!.saveAndValidate();
                    await generatePDF();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    final Uint8List radarChartImage = await captureRadarChartToImage();
    pdf.addPage(
      pw.Page(
        build: (context) => _buildPdfContent(radarChartImage),
      ),
    );

    final directory = await getTemporaryDirectory();
    final String path = '${directory.path}/report.pdf';

    final List<int> bytes = await pdf.save();

    final File file = File(path);
    await file.writeAsBytes(bytes);

    OpenFile.open(file.path);
  }

  Future<Uint8List> captureRadarChartToImage() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 1.0);
    ByteData byteData =
        (await image.toByteData(format: ui.ImageByteFormat.png))!;
    return byteData.buffer.asUint8List();
  }

  pw.Widget _buildPdfContent(Uint8List radarChartImage) {
    return pw.Center(
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            sesionName.isNotEmpty ? sesionName : 'Reporte',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            producerName.isNotEmpty ? producerName : 'Sin productor',
            style: pw.TextStyle(fontSize: 15),
          ),
          pw.Text(
            formattedDate.isNotEmpty ? formattedDate : 'Sin fecha',
            style: pw.TextStyle(fontSize: 15),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            data: <List<String>>[
              <String>['Categoria', 'Valor'],
              for (var row in reportData)
                [row['Categoria'] ?? '', row['Valor'].toString()],
            ],
          ),
          pw.SizedBox(height: 21),
          pw.Text("F"),
          pw.Image(pw.MemoryImage(radarChartImage)),
        ],
      ),
    );
  }

  void _consultarReporte() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('cataciones')
          .doc(widget.catacionId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() ?? {};
        sesionName = snapshot.get('name') ?? 'Reporte';
        producerName = snapshot.get('producer') ?? 'Sin productor';

        DateTime date = (data['date'] as Timestamp).toDate();
        formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(date);

        // Definir puntajes de los defectos
        double valorDefecto = 2.0;

        // Calcular puntaje general sumando los puntajes de los defectos
        double puntajeDefecto =
            (data['sabor_quemado'] == true ? valorDefecto : 0.0) +
                (data['sabor_fermentado'] == true ? valorDefecto : 0.0) +
                (data['sabor_moho'] == true ? valorDefecto : 0.0) +
                (data['sabor_sucio'] == true ? valorDefecto : 0.0);

        double puntajeTotal = (data['puntaje_frag']?.toDouble() ?? 0.0) +
            (data['puntaje_acid']?.toDouble() ?? 0.0) +
            (data['puntaje_cuerpo']?.toDouble() ?? 0.0) +
            (data['puntaje_sabor']?.toDouble() ?? 0.0) +
            (data['puntaje_reguste']?.toDouble() ?? 0.0) +
            (data['puntaje_balance']?.toDouble() ?? 0.0) +
            (data['calificacion_general']?.toDouble() ?? 0.0) +
            (data['uniformidad']?.toDouble() ?? 0.0) +
            (data['limpieza_taza']?.toDouble() ?? 0.0) +
            (data['limpieza_taza']?.toDouble() ?? 0.0) +
            (data['Dulzura']?.toDouble() ?? 0.0) -
            puntajeDefecto;

        void _actualizarPuntajeTotal(double puntajeTotal) async {
          try {
            await FirebaseFirestore.instance
                .collection('cataciones')
                .doc(widget.catacionId)
                .update({'puntajeTotal': puntajeTotal});
            print('Puntaje total actualizado en Firestore');
          } catch (e) {
            print('Error al actualizar el puntaje total: $e');
          }
        }

        setState(() {
          reportData = [
            {'Categoria': 'Fragancia', 'Valor': data['puntaje_frag'] ?? ''},
            {'Categoria': 'Acidez', 'Valor': data['puntaje_acid'] ?? ''},
            {'Categoria': 'Cuerpo', 'Valor': data['puntaje_cuerpo'] ?? ''},
            {'Categoria': 'Sabor', 'Valor': data['puntaje_sabor'] ?? ''},
            {'Categoria': 'Reguste', 'Valor': data['puntaje_reguste'] ?? ''},
            {'Categoria': 'Balance', 'Valor': data['puntaje_balance'] ?? ''},
            {
              'Categoria': 'Calificacion general',
              'Valor': data['calificacion_general'] ?? ''
            },
            {'Categoria': 'Uniformidad', 'Valor': data['uniformidad'] ?? ''},
            {
              'Categoria': 'Limpieza de la taza',
              'Valor': data['limpieza_taza'] ?? ''
            },
            {'Categoria': 'Dulzura', 'Valor': data['dulzura'] ?? ''},
            {'Categoria': 'Defectos', 'Valor': puntajeDefecto.toString()},
            {
              'Categoria': 'Puntaje total',
              'Valor': puntajeTotal.toStringAsFixed(2)
            },
          ];

          spiderChartValues = [
            data['puntaje_frag']?.toDouble() ?? 0.0,
            data['puntaje_acid']?.toDouble() ?? 0.0,
            data['puntaje_cuerpo']?.toDouble() ?? 0.0,
            data['puntaje_balance']?.toDouble() ?? 0.0,
            data['puntaje_sabor']?.toDouble() ?? 0.0,
            data['puntaje_reguste']?.toDouble() ?? 0.0,
            data['calificacion_general']?.toDouble() ?? 0.0,
          ];
        });
      } else {
        debugPrint('El documento no existe en Firestore');
      }
    } catch (e) {
      print('Error al consultar el reporte: $e');
    }
  }
}
