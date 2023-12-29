import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'catacion.dart';

class InforMuestra extends StatefulWidget {
  final String catacionId;

  const InforMuestra({Key? key, required this.catacionId}) : super(key: key);

  @override
  State<InforMuestra> createState() {
    return _CompleteFormState();
  }
}

class _CompleteFormState extends State<InforMuestra> {
  final _formKey = GlobalKey<FormBuilderState>();
  int? option;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Text("Muestra", style: TextStyle(color: Colors.white)),
            const Spacer(),
            Image.asset(
              'assets/sennova.png',
              height: 30,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              skipDisabled: true,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    name: 'nameSample',
                    decoration:
                        InputDecoration(labelText: 'Nombre de la muestra'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderDateTimePicker(
                    name: 'date',
                    initialEntryMode: DatePickerEntryMode.calendar,
                    initialValue: DateTime.now(),
                    inputType: InputType.both,
                    decoration: InputDecoration(
                      labelText: 'Fecha',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _formKey.currentState!.fields['date']
                              ?.didChange(null);
                        },
                      ),
                    ),
                    initialTime: const TimeOfDay(hour: 8, minute: 0),
                  ),
                  FormBuilderTextField(
                    name: 'pais',
                    decoration: InputDecoration(labelText: 'Pais'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'producer',
                    decoration:
                        InputDecoration(labelText: 'Nombre del productor'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'bweight',
                    decoration:
                        InputDecoration(labelText: 'Peso de la bolsa (kg)'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderTextField(
                    name: 'variety',
                    decoration: InputDecoration(labelText: 'Varietales'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'reference',
                    decoration:
                        InputDecoration(labelText: 'Numero de referencia'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderDropdown<int>(
                    name: 'options',
                    validator: FormBuilderValidators.required(),
                    decoration: InputDecoration(
                      labelText: 'Tipo de café',
                    ),
                    onChanged: (value) {
                      setState(() {
                        option = value;
                      });
                    },
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('Especial')),
                      DropdownMenuItem(value: 1, child: Text('Premium')),
                    ],
                  ),
                  FormBuilderTextField(
                    name: 'provider',
                    decoration: InputDecoration(labelText: 'Proveedor'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: 'moisture',
                    decoration: InputDecoration(
                      labelText: 'Humedad (%)',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.max(70),
                    ]),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: 'mass',
                    decoration: InputDecoration(
                      labelText: 'Masa (gr)',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(),
                    ]),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: 'volume',
                    decoration: InputDecoration(
                      labelText: 'Volumen (mL)',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(),
                    ]),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        debugPrint(_formKey.currentState?.value.toString());

                        _formKey.currentState!.save();
                        Map<String, dynamic> formData =
                            _formKey.currentState!.value;

                        // Save data to Firestore
                        await FirebaseFirestore.instance
                            .collection('cataciones')
                            .doc(widget.catacionId)
                            .update({
                          'nameSample': formData['nameSample'],
                          'date': formData['date'],
                          'pais': formData['pais'],
                          'producer': formData['producer'],
                          'bweight': formData['bweight'],
                          'variety': formData['variety'],
                          'reference': formData['reference'],
                          'options': formData['options'],
                          'provider': formData['provider'],
                          'moisture': formData['moisture'],
                          'mass': formData['mass'],
                          'volume': formData['volume'],
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Catacion(catacionId: widget.catacionId),
                          ),
                        );
                      } else {
                        debugPrint(_formKey.currentState?.value.toString());
                        debugPrint('validation failed');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors
                            .green, // Usa el color principal o el color que desees
                      ),
                    ),
                    child: const Text(
                      'Descartar',
                      style: TextStyle(
                          color: Colors
                              .green), // Usa el color principal o el color que desees
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Formulario de Muestra de Café'),
        ),
        body: const InforMuestra(catacionId: "catacionId"),
      ),
    ),
  );
}
