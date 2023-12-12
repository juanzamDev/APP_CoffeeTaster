import 'package:example/sources/catacion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:example/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InforMuestra extends StatefulWidget {
  final String catacionId; // Agrega este campo

  const InforMuestra({Key? key, required this.catacionId}) : super(key: key);

  @override
  State<InforMuestra> createState() {
    return _CompleteFormState();
  }
}

class _CompleteFormState extends State<InforMuestra> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _ageHasError = false;
  int? option;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('Muestra'),
              const Spacer(), // Esto añade un espacio flexible entre el título y la imagen
              Image.asset(
                'assets/sennova.png',
                height: 30, // Ajusta la altura según tu necesidad
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                initialValue: const {
                  'movie_rating': 5,
                  'best_language': 'Dart',
                  'age': '0',
                  'gender': 'Male',
                  'languages_filter': ['Dart']
                },
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      name: 'nameSample',
                      decoration: const InputDecoration(
                          labelText: 'Nombre de la muestra'),
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
                      decoration: const InputDecoration(labelText: 'Pais'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'producer',
                      decoration: const InputDecoration(
                          labelText: 'Nombre del productor'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'bweight',
                      decoration: const InputDecoration(
                          labelText: 'Peso de la bolsa (kg)'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      name: 'variety',
                      decoration:
                          const InputDecoration(labelText: 'Varietales'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'reference',
                      decoration: const InputDecoration(
                          labelText: 'Numero de referencia'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderDropdown<int>(
                      //controller coffeetypeController,
                      name: 'options',
                      validator: FormBuilderValidators.required(),
                      decoration: const InputDecoration(
                        label: Text('Tipo de café'),
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
                      decoration: const InputDecoration(labelText: 'Proveedor'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,

                      name: 'moisture', // Cambiado de 'age' a 'humidity'
                      decoration: InputDecoration(
                        labelText: 'Humedad (%)',
                        suffixIcon: _ageHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _ageHasError = !(_formKey
                                  .currentState?.fields['humidity']
                                  ?.validate() ??
                              false);
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        //FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(70),
                      ]),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'mass', // Cambiado de 'age' a 'mass'
                      decoration: InputDecoration(
                        labelText: 'Masa (gr)',
                        suffixIcon: _ageHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _ageHasError = !(_formKey.currentState?.fields['mass']
                                  ?.validate() ??
                              false);
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        //FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        //FormBuilderValidators.max(70),
                      ]),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'volume', // Cambiado de 'age' a 'volume'
                      decoration: InputDecoration(
                        labelText: 'Volumen (mL)',
                        suffixIcon: _ageHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          //  _ageHasError = !(_formKey
                          //        .currentState?.fields['volume']
                          //      ?.validate() ??
                          // false);
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        //  FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        // FormBuilderValidators.max(70),
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
                              .doc(widget
                                  .catacionId) // Accede al ID de la catación
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

                            // Agrega otros campos según sea necesario
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
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      child: Text(
                        'Descartar',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
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
