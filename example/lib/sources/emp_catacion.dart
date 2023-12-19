import 'package:example/services/firebase_service.dart';
import 'package:example/sources/infor_muestra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class EmpCatacion extends StatefulWidget {
  const EmpCatacion({Key? key}) : super(key: key);

  @override
  State<EmpCatacion> createState() {
    return _CompleteFormState();
  }
}

class _CompleteFormState extends State<EmpCatacion> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _ageHasError = false;
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController desController = TextEditingController(text: "");
  TextEditingController loController = TextEditingController(text: "");
  TextEditingController numController = TextEditingController(text: "");
  TextEditingController typeController = TextEditingController(text: "");
  bool addTaster = true; // Variable para controlar el estado del switch

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.save();
                debugPrint(_formKey.currentState!.value.toString());
              },
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
                    controller: nameController,
                    name: 'full_name',
                    decoration: InputDecoration(
                      labelText: 'Nombre de la sesión',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 15),
                  FormBuilderTextField(
                    controller: desController,
                    name: 'descripcion',
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Descripción de la sesión',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 15),
                  FormBuilderTextField(
                    controller: loController,
                    name: 'ciudad',
                    decoration: InputDecoration(
                      labelText: 'Localización',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 15),
                  FormBuilderDateRangePicker(
                    name: 'date_range',
                    firstDate: DateTime(1970),
                    lastDate: DateTime(2030),
                    format: DateFormat('yyyy-MM-dd'),
                    onChanged: _onChanged,
                    decoration: InputDecoration(
                      labelText: 'Rango de fecha',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  FormBuilderTextField(
                    controller: numController,
                    autovalidateMode: AutovalidateMode.always,
                    name: 'num_muestra',
                    decoration: InputDecoration(
                      labelText: 'Número de muestras',
                      border: OutlineInputBorder(),
                      suffixIcon: _ageHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _ageHasError = !(_formKey
                                .currentState?.fields['num_muestra']
                                ?.validate() ??
                            false);
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.max(70),
                    ]),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Text(
                        'Agregar catadores',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      Switch(
                        value: addTaster,
                        onChanged: (value) {
                          setState(() {
                            addTaster = value;
                          });
                        },
                        activeTrackColor: Colors.green,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  FormBuilderRadioGroup<String>(
                    decoration: InputDecoration(
                      labelText: 'Tipo de muestra',
                      border: OutlineInputBorder(),
                    ),
                    name: 'sampleType',
                    orientation: OptionsOrientation.horizontal,
                    activeColor: Colors.green,
                    options: [
                      'Arabica',
                      'Café filtrado',
                      'Expreso',
                    ]
                        .map((type) => FormBuilderFieldOption(value: type))
                        .toList(),
                    onChanged: (String? selected) {
                      if (selected != null) {
                        debugPrint("Selected: $selected");
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        debugPrint(_formKey.currentState?.value.toString());

                        String catacionId = await addCatacion(
                          nameController.text,
                          desController.text,
                          loController.text,
                          numController.text,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InforMuestra(catacionId: catacionId),
                          ),
                        );
                      } else {
                        debugPrint(_formKey.currentState?.value.toString());
                        debugPrint('No se pudo realizar la validación');
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
                    child: Text(
                      'Reiniciar',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
