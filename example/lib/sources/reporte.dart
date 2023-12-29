import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pw;
import 'package:fl_chart/fl_chart.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class Reporte extends StatefulWidget {
  final String catacionId;

  const Reporte({Key? key, required this.catacionId}) : super(key: key);

  @override
  State<Reporte> createState() => _ReporteState();
}

class _ReporteState extends State<Reporte> {
  Map<String, dynamic> data = {};
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

//Pdf descriptor class

  pw.Widget _buildPdfDescriptor(String label, pw.PdfColor color, String value) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 14, color: color),
        ),
        pw.Text(
          value != 'null' ? value : '',
          style: pw.TextStyle(fontSize: 12, color: color),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

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
            IconButton(
              icon: Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                // Navegar a la pantalla Home al hacer clic en el ícono de inicio
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Home()), // Reemplaza "Home()" con tu clase Home
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('cataciones')
                  .doc(widget.catacionId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text('El documento no existe en Firestore');
                } else {
                  final Map<String, dynamic> data = snapshot.data!.data() ?? {};
                  sesionName = data['name'] ?? 'Reporte';
                  producerName = data['producer'] ?? 'Sin productor';

                  DateTime date = (data['date'] as Timestamp).toDate();
                  formattedDate =
                      DateFormat('dd/MM/yyyy HH:mm:ss').format(date);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(
                        sesionName.isNotEmpty ? sesionName : 'Reporte',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        producerName.isNotEmpty
                            ? producerName
                            : 'Sin productor',
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
                                        .map(
                                            (value) => RadarEntry(value: value))
                                        .toList(),
                                    fillColor:
                                        const Color.fromARGB(120, 94, 141, 80),
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
                                    case 7:
                                      return RadarChartTitle(
                                        text: 'U',
                                        angle: usedAngle,
                                      );
                                    case 8:
                                      return RadarChartTitle(
                                        text: 'L',
                                      );
                                    case 9:
                                      return RadarChartTitle(
                                        text: 'D',
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

                      // Nueva sección de Descriptores
                      const Text(
                        'Descriptores',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDescriptor('', Colors.blue,
                              data['descriptor_acidez'] ?? 'null'),
                          _buildDescriptor('', Colors.green,
                              data['descriptor_cuerpo'] ?? 'null'),
                          _buildDescriptor(
                              '', Colors.orange, data[''] ?? 'null'),
                          _buildDescriptor('', Colors.purple,
                              data['descriptor_reguste'] ?? 'null'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDescriptor('', Colors.yellow,
                              data['descriptor_balance'] ?? 'null'),
                          _buildDescriptor('', Colors.black,
                              data['descriptor_fragancia'] ?? 'null'),
                          _buildDescriptor('', Colors.red,
                              data['descriptor_sabor'] ?? 'null'),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptor(String label, Color color, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: color),
        ),
        Text(
          value != 'null' ? value : '',
          style: TextStyle(fontSize: 12, color: color),
        ),
        const SizedBox(height: 20),
      ],
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
    ui.Image image = await boundary.toImage(pixelRatio: 1);
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
          pw.SizedBox(height: 5),
          pw.TableHelper.fromTextArray(
            data: <List<String>>[
              <String>['Categoria', 'Valor'],
              for (var row in reportData)
                [row['Categoria'] ?? '', row['Valor'].toString()],
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Text("F"),
          pw.Image(pw.MemoryImage(radarChartImage)),
          /*pw.SizedBox(height: 20),
          pw.Text(
            'Descriptores',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              _buildPdfDescriptor('', pw.PdfColor.fromHex('#0000FF'),
                  data['descriptor_acidez'] ?? 'null'),
              _buildPdfDescriptor('', pw.PdfColor.fromHex('#008000'),
                  data['descriptor_cuerpo'] ?? 'null'),
              _buildPdfDescriptor(
                  '', pw.PdfColor.fromHex('#FFA500'), data[''] ?? 'null'),
              _buildPdfDescriptor('', pw.PdfColor.fromHex('#800080'),
                  data['descriptor_reguste'] ?? 'null'),
            ],
          ),*/
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
        data = snapshot.data() ?? {};
        sesionName = snapshot.get('name') ?? 'Reporte';
        producerName = snapshot.get('producer') ?? 'Sin productor';

        DateTime date = (data['date'] as Timestamp).toDate();
        formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
        // Definir puntajes de los defectos
        double valorDefecto = 2.0;

        double puntajeDefecto =
            (data['sabor_quemado'] == true ? valorDefecto : 0.0) +
                (data['sabor_fermentado'] == true ? valorDefecto : 0.0) +
                (data['sabor_moho'] == true ? valorDefecto : 0.0) +
                (data['sabor_sucio'] == true ? valorDefecto : 0.0);

        double puntajeTotal = ((data['puntaje_frag']?.toDouble() ?? 0.0) +
                (data['puntaje_acid']?.toDouble() ?? 0.0) +
                (data['puntaje_cuerpo']?.toDouble() ?? 0.0) +
                (data['puntaje_sabor']?.toDouble() ?? 0.0) +
                (data['puntaje_reguste']?.toDouble() ?? 0.0) +
                (data['puntaje_balance']?.toDouble() ?? 0.0) +
                (data['calificacion_general']?.toDouble() ?? 0.0) +
                (data['uniformidad']?.toDouble() ?? 0.0) +
                (data['limpieza_taza']?.toDouble() ?? 0.0) +
                (data['dulzura']?.toDouble() ?? 0.0)) -
            puntajeDefecto;

        void _guardarPuntajeTotal(double puntajeTotal) async {
          try {
            // Save the calculated value in Firestore
            await FirebaseFirestore.instance
                .collection('cataciones')
                .doc(widget.catacionId)
                .set({'puntajeTotal': puntajeTotal}, SetOptions(merge: true));
            print('Puntaje total guardado en Firestore');
          } catch (e) {
            print('Error al guardar el puntaje total: $e');
          }
        }

        // Calling guardarPuntajeTotal Function
        _guardarPuntajeTotal(puntajeTotal);

        // Tabla del reporte
        setState(() {
          reportData = [
            {'Categoria': 'Tueste', 'Valor': data['tueste'] ?? ''},
            {
              'Categoria': 'Fragancia / Aroma',
              'Valor': data['puntaje_frag'] ?? ''
            },
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
            data['uniformidad']?.toDouble() ?? 0.0,
            data['limpieza_taza']?.toDouble() ?? 0.0,
            data['dulzura']?.toDouble() ?? 0.0,
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
