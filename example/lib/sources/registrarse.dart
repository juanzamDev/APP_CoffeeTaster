import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class Registrarse extends StatefulWidget {
  const Registrarse({Key? key}) : super(key: key);

  @override
  State<Registrarse> createState() => _SignupFormState();
}

class _SignupFormState extends State<Registrarse> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      // Centro el contenido en la pantalla
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'full_name',
                  decoration:
                      const InputDecoration(labelText: '  Nombre Completo'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  key: _emailFieldKey,
                  name: 'email',
                  decoration: const InputDecoration(labelText: '  Email'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'password',
                  decoration: const InputDecoration(labelText: '  Contraseña'),
                  obscureText: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'confirm_password',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: '  Confirmar Contraseña',
                    suffixIcon: (_formKey.currentState
                                ?.fields['confirm_password']?.hasError ??
                            false)
                        ? const Icon(Icons.error, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      _formKey.currentState?.fields['password']?.value != value
                          ? 'No coinciden'
                          : null,
                ),
                const SizedBox(height: 10),
                FormBuilderFieldDecoration<bool>(
                  name: 'test',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.equal(true),
                  ]),
                  decoration: const InputDecoration(labelText: 'Accept Terms?'),
                  builder: (FormFieldState<bool?> field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        errorText: field.errorText,
                      ),
                      child: SwitchListTile(
                        title: const Text(
                            'He leido y acepto los terminos y condiciones.'),
                        onChanged: field.didChange,
                        value: field.value ?? false,
                        activeColor: Colors.green,
                      ),
                    );
                  },
                ),
                const SizedBox(),
                SizedBox(
                  width: 1000,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        if (true) {
                          _formKey.currentState?.fields['email']
                              ?.invalidate('Email already taken.');
                        }
                      }
                      debugPrint(_formKey.currentState?.value.toString());
                    },
                    style: ElevatedButton.styleFrom(
                      // Cambio de color del botón
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
