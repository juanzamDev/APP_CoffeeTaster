import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'home.dart';

class Ingresar extends StatefulWidget {
  const Ingresar({Key? key}) : super(key: key);

  @override
  State<Ingresar> createState() => _SignupFormState();
}

class _SignupFormState extends State<Ingresar> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();

  void _showForgotPasswordModal() {
    // ... tu código existente para mostrar el modal de recuperar contraseña
  }

  void _showRegisterModal() {
    // ... tu código existente para mostrar el modal de registro
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              FormBuilderTextField(
                key: _emailFieldKey,
                name: 'email',
                decoration: const InputDecoration(labelText: 'Email'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'password',
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(6),
                ]),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                    onPressed: () => _showForgotPasswordModal(),
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                  const Spacer(),
                  MaterialButton(
                    color: Colors.green,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                      );
                    },
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _showRegisterModal(),
                child: const Text('¿No tienes una cuenta? ¡Regístrate aquí!'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

void main() {
  runApp(const MaterialApp(
    home: Ingresar(),
  ));
}
