import 'package:example/sources/reporte.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Catacion extends StatefulWidget {
  final String catacionId;

  const Catacion({Key? key, required this.catacionId}) : super(key: key);

  @override
  State<Catacion> createState() => _DynamicFieldsState();
}

class _DynamicFieldsState extends State<Catacion> {
  final _formKey = GlobalKey<FormBuilderState>();
  String savedValue = '';

  List<String> fraganciaOptions = [
    'Floral',
    'Frutal',
    'Chocolate',
    'Dulce',
    'Cereal',
    'Picante',
    'Hierba',
    'Vegetal',
    // Agrega más opciones según sea necesario
  ];

  List<String> acidezOptions = [
    'Agria',
    'Brillante',
    'Viva',
    'Suave',
    // Agrega más opciones según sea necesario
  ];

  List<String> cuerpoOptions = [
    'Ligero',
    'Medio',
    'Pesado',
    // Agrega más opciones según sea necesario
  ];

  List<String> saborOptions = [
    'Dulce',
    'Salado',
    'Amargo',
    'Ácido',
    // Agrega más opciones según sea necesario
  ];

  List<String> regusteOptions = [
    'Limpio',
    'Complejo',
    'Persistente',
    'Astringente',
    'Seco',
    // Agrega más opciones según sea necesario
  ];

  List<String> balanceOptions = [
    'Armonioso',
    'Equilibrado',
    'Uniforme',
    // Agrega más opciones según sea necesario
  ];

  @override
  void initState() {
    savedValue = _formKey.currentState?.value.toString() ?? '';
    super.initState();
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Text("Catación", style: TextStyle(color: Colors.white)),
            const Spacer(),
            Image.asset(
              'assets/sennova.png',
              height: 30,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            clearValueOnUnregister: true,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                  'Selecciona el Tueste',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FormBuilderDropdown<String>(
                  name: 'tueste',
                  decoration: const InputDecoration(
                    labelText: 'Tueste',
                  ),
                  initialValue: 'Medio',
                  items: [
                    'Ligero',
                    'Ligero medio',
                    'Medio',
                    'Medio oscuro',
                    'Oscuro'
                  ]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Fragancia/ Aroma',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderRadioGroup<String>(
                        decoration: const InputDecoration(
                          labelText: 'Elige los descriptores',
                        ),
                        name: 'descriptor_fragancia',
                        orientation: OptionsOrientation.horizontal,
                        activeColor: Colors.green,
                        options: fraganciaOptions
                            .map((type) => FormBuilderFieldOption(value: type))
                            .toList(),
                        onChanged: (String? selected) {
                          if (selected != null) {
                            debugPrint("Selected: $selected");
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderSlider(
                        name: 'sequedad',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.min(0),
                          FormBuilderValidators.max(5),
                        ]),
                        onChanged: _onChanged,
                        min: 0.0,
                        max: 5.0,
                        initialValue: 3.0,
                        divisions: 10,
                        activeColor: Colors.red,
                        inactiveColor: Colors.pink[100],
                        decoration: const InputDecoration(
                          labelText: 'Sequedad',
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: FormBuilderSlider(
                        name: 'sabor',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.min(0),
                          FormBuilderValidators.max(5),
                        ]),
                        onChanged: _onChanged,
                        min: 0.0,
                        max: 5.0,
                        initialValue: 3.0,
                        divisions: 10,
                        activeColor: Colors.red,
                        inactiveColor: Colors.pink[100],
                        decoration: const InputDecoration(
                          labelText: 'Sabor',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Puntaje general',
                        style: TextStyle(fontSize: 16),
                      ),
                      FormBuilderSlider(
                        name: 'puntaje_frag',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.min(6),
                          FormBuilderValidators.max(10),
                        ]),
                        onChanged: _onChanged,
                        min: 6.0,
                        max: 10.0,
                        initialValue: 8.0,
                        divisions: 10,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue[100],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Acidez',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // Reemplazar FormBuilderCheckboxGroup con FormBuilderRadioGroup
                FormBuilderRadioGroup<String>(
                  name: 'descriptor_acidez',
                  orientation: OptionsOrientation.horizontal,
                  activeColor: Colors.green,
                  options: acidezOptions
                      .map((descriptor) => FormBuilderFieldOption(
                            value: descriptor,
                            child: Text(descriptor),
                          ))
                      .toList(),
                ),

                FormBuilderSlider(
                  name: 'nivel_acidez',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.min(0),
                    FormBuilderValidators.max(5),
                  ]),
                  onChanged: _onChanged,
                  min: 0.0,
                  max: 5.0,
                  initialValue: 3.0,
                  divisions: 10,
                  activeColor: Colors.red,
                  inactiveColor: Colors.pink[100],
                  decoration: const InputDecoration(
                    labelText: 'Nivel de Acidez',
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Puntaje general',
                        style: TextStyle(fontSize: 16),
                      ),
                      FormBuilderSlider(
                        name: 'puntaje_acid',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.min(6),
                          FormBuilderValidators.max(10),
                        ]),
                        onChanged: _onChanged,
                        min: 6.0,
                        max: 10.0,
                        initialValue: 8.0,
                        divisions: 10,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue[100],
                      ),
                    ],
                  ),
                ),
                // Sección de Cuerpo
                const SizedBox(height: 20),
                const Text(
                  'Cuerpo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FormBuilderRadioGroup<String>(
                  name: 'descriptor_cuerpo',
                  orientation: OptionsOrientation.horizontal,
                  activeColor: Colors.green,
                  options: cuerpoOptions
                      .map((descriptor) => FormBuilderFieldOption(
                            value: descriptor,
                            child: Text(descriptor),
                          ))
                      .toList(),
                ),
                FormBuilderSlider(
                  name: 'nivel_cuerpo',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.min(0),
                    FormBuilderValidators.max(5),
                  ]),
                  onChanged: _onChanged,
                  min: 0.0,
                  max: 5.0,
                  initialValue: 3.0,
                  divisions: 10,
                  activeColor: Colors.red,
                  inactiveColor: Colors.pink[100],
                  decoration: const InputDecoration(
                    labelText: 'Nivel de Cuerpo',
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Puntaje general',
                        style: TextStyle(fontSize: 16),
                      ),
                      FormBuilderSlider(
                        name: 'puntaje_cuerpo',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.min(6),
                          FormBuilderValidators.max(10),
                        ]),
                        onChanged: _onChanged,
                        min: 6.0,
                        max: 10.0,
                        initialValue: 8.0,
                        divisions: 10,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue[100],
                      ),
                    ],
                  ),
                ),
                // Sección de Sabor
                const SizedBox(height: 20),
                const Text(
                  'Sabor',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FormBuilderRadioGroup<String>(
                  name: 'descriptor_sabor',
                  orientation: OptionsOrientation.horizontal,
                  activeColor: Colors.green,
                  options: saborOptions
                      .map((descriptor) => FormBuilderFieldOption(
                            value: descriptor,
                            child: Text(descriptor),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Puntaje general',
                        style: TextStyle(fontSize: 16),
                      ),
                      FormBuilderSlider(
                        name: 'puntaje_sabor',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.min(6),
                          FormBuilderValidators.max(10),
                        ]),
                        onChanged: _onChanged,
                        min: 6.0,
                        max: 10.0,
                        initialValue: 8.0,
                        divisions: 10,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue[100],
                      ),
                    ],
                  ),
                ),
                // Sección de Reguste
                const SizedBox(height: 20),
                const Text(
                  'Reguste',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FormBuilderRadioGroup<String>(
                  name: 'descriptor_reguste',
                  orientation: OptionsOrientation.horizontal,
                  activeColor: Colors.green,
                  options: regusteOptions
                      .map((descriptor) => FormBuilderFieldOption(
                            value: descriptor,
                            child: Text(descriptor),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Puntaje general',
                        style: TextStyle(fontSize: 16),
                      ),
                      FormBuilderSlider(
                        name: 'puntaje_reguste',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.min(6),
                          FormBuilderValidators.max(10),
                        ]),
                        onChanged: _onChanged,
                        min: 6.0,
                        max: 10.0,
                        initialValue: 8.0,
                        divisions: 10,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue[100],
                      ),
                    ],
                  ),
                ),
                // Sección balance
                const SizedBox(height: 20),
                const Text(
                  'Balance',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FormBuilderRadioGroup<String>(
                  name: 'descriptor_balance',
                  orientation: OptionsOrientation.horizontal,
                  activeColor: Colors.green,
                  options: balanceOptions
                      .map((descriptor) => FormBuilderFieldOption(
                            value: descriptor,
                            child: Text(descriptor),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Puntaje general',
                        style: TextStyle(fontSize: 16),
                      ),
                      FormBuilderSlider(
                        name: 'puntaje_balance',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.min(6),
                          FormBuilderValidators.max(10),
                        ]),
                        onChanged: _onChanged,
                        min: 6.0,
                        max: 10.0,
                        initialValue: 8.0,
                        divisions: 10,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue[100],
                      ),
                    ],
                  ),
                ),
                FormBuilderSlider(
                  name: 'calificacion_general',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.min(6),
                    FormBuilderValidators.max(10),
                  ]),
                  onChanged: _onChanged,
                  min: 6.0,
                  max: 10.0,
                  initialValue: 8.0,
                  divisions: 10,
                  activeColor: Colors.green,
                  inactiveColor: Colors.pink[100],
                  decoration: const InputDecoration(
                    labelText: 'Calificación General',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Calidad',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FormBuilderSlider(
                  name: 'uniformidad',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.min(0),
                    FormBuilderValidators.max(10),
                  ]),
                  onChanged: _onChanged,
                  min: 0.0,
                  max: 10.0,
                  initialValue: 10.0,
                  divisions: 5,
                  activeColor: Colors.red,
                  inactiveColor: Colors.pink[100],
                  decoration: const InputDecoration(
                    labelText: 'Uniformidad',
                  ),
                ),
                FormBuilderSlider(
                  name: 'limpieza_taza',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.min(0),
                    FormBuilderValidators.max(10),
                  ]),
                  onChanged: _onChanged,
                  min: 0.0,
                  max: 10.0,
                  initialValue: 10.0,
                  divisions: 5,
                  activeColor: Colors.red,
                  inactiveColor: Colors.pink[100],
                  decoration: const InputDecoration(
                    labelText: 'Limpieza de la taza',
                  ),
                ),
                FormBuilderSlider(
                  name: 'dulzura',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.min(0),
                    FormBuilderValidators.max(10),
                  ]),
                  onChanged: _onChanged,
                  min: 0.0,
                  max: 10.0,
                  initialValue: 10.0,
                  divisions: 5,
                  activeColor: Colors.red,
                  inactiveColor: Colors.pink[100],
                  decoration: const InputDecoration(
                    labelText: 'Dulzura',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Defectos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FormBuilderCheckbox(
                  name: 'sabor_quemado',
                  title: const Text('Sabor Quemado'),
                ),
                FormBuilderCheckbox(
                  name: 'sabor_fermentado',
                  title: const Text('Sabor Fermentado'),
                ),
                FormBuilderCheckbox(
                  name: 'sabor_moho',
                  title: const Text('Sabor a Moho'),
                ),
                FormBuilderCheckbox(
                  name: 'sabor_sucio',
                  title: const Text('Sabor Sucio'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Añade Notas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FormBuilderTextField(
                  name: 'notas',
                  decoration: const InputDecoration(labelText: 'Notas'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: Colors.green,
                        child: const Text(
                          "Enviar",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          _formKey.currentState!.save();
                          Map<String, dynamic> formData =
                              _formKey.currentState!.value;

                          // Save data to Firestore
                          await FirebaseFirestore.instance
                              .collection('cataciones')
                              .doc(widget.catacionId)
                              .update({
                            'tueste': formData['tueste'],
                            'descriptor_fragancia':
                                formData['desgriptor_fragancia'],
                            'sequedad': formData['sequedad'],
                            'sabor': formData['sabor'],
                            'puntaje_frag': formData['puntaje_frag'],
                            'descriptor_acidez': formData['descriptor_acidez'],
                            'nivel_acidez': formData['nivel_acidez'],
                            'puntaje_acid': formData['puntaje_acid'],
                            'descriptor_cuerpo': formData['descriptor_cuerpo'],
                            'nivel_cuerpo': formData['nivel_cuerpo'],
                            'puntaje_cuerpo': formData['puntaje_cuerpo'],
                            'descriptor_sabor': formData['descriptor_sabor'],
                            'puntaje_sabor': formData['puntaje_sabor'],
                            'descriptor_reguste':
                                formData['descriptor_reguste'],
                            'puntaje_reguste': formData['puntaje_reguste'],
                            'descriptor_balance':
                                formData['descriptor_balance'],
                            'puntaje_balance': formData['puntaje_balance'],
                            'calificacion_general':
                                formData['calificacion_general'],
                            'uniformidad': formData['uniformidad'],
                            'limpieza_taza': formData['limpieza_taza'],
                            'dulzura': formData['dulzura'],
                            'sabor_quemado': formData['sabor_quemado'],
                            'sabor_fermentado': formData['sabor_fermentado'],
                            'sabor_moho': formData['sabor_moho'],
                            'sabor_sucio': formData['sabor_sucio'],
                            'notas': formData['notas'],
                            // Agrega otros campos según sea necesario
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Reporte(catacionId: widget.catacionId),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
