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

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la sesión',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderTextField(
                    controller: desController,
                    name: 'descripcion',
                    decoration: const InputDecoration(
                      labelText: 'Descripción de la sesión',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderTextField(
                    controller: loController,
                    name: 'ciudad',
                    decoration: const InputDecoration(
                      labelText: 'Localización',
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
                      helperText: '',
                      hintText: 'Hint text',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _formKey.currentState!.fields['date_range']
                              ?.didChange(null);
                        },
                      ),
                    ),
                  ),
                  FormBuilderTextField(
                    controller: numController,
                    autovalidateMode: AutovalidateMode.always,
                    name: 'num_muestra',
                    decoration: InputDecoration(
                      labelText: 'Numero de muestras',
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
                      //FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.max(70),
                    ]),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderSwitch(
                    title: const Text('Agregar catadores'),
                    name: 'addTaster',
                    initialValue: true,
                    onChanged: _onChanged,
                  ),
                  FormBuilderRadioGroup<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de muestra',
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
                        // Process the selected option
                        debugPrint("Selected: $selected");
                        // Puedes incluir lógica aquí para manejar la opción seleccionada
                      }
                    },
                  ),
                  const SizedBox(height: 15),
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

                        // Llama a addCatacion y obtén el catacionId
                        String catacionId = await addCatacion(
                          nameController.text,
                          desController.text,
                          loController.text,
                          numController.text,
                        );

                        // Ahora puedes pasar el catacionId a InforMuestra
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
