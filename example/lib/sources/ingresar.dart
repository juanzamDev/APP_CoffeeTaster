import 'dart:ui';

import 'package:example/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Ingresar extends StatefulWidget {
  const Ingresar({Key? key}) : super(key: key);

  @override
  State<Ingresar> createState() => _SignupFormState();
}

class _SignupFormState extends State<Ingresar> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showForgotPasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 2.0,
              sigmaY: 2.0), // Ajusta este valor según tus necesidades
          child: FractionallySizedBox(
            heightFactor: 0.65, // Ajusta este valor según tus necesidades
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ForgotPasswordModal(),
            ),
          ),
        );
      },
    );
  }

  void _showRegisterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 2.0,
              sigmaY: 2.0), // Ajusta este valor según tus necesidades
          child: FractionallySizedBox(
            heightFactor: 0.8, // Ajusta este valor según tus necesidades
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: RegisterModal(),
            ),
          ),
        );
      },
    );
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
                  controller: _emailController,
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
                  controller: _passwordController,
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
                      onPressed: () => _showForgotPasswordModal(context),
                      child: const Text('¿Olvidaste tu contraseña?'),
                    ),
                    const Spacer(),
                    MaterialButton(
                      color: Colors.green,
                      onPressed: () {
                        _sigIn();
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );*/
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
                  onPressed: () => _showRegisterModal(context),
                  child: const Text('¿No tienes una cuenta? ¡Regístrate aquí!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sigIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      print("El usuario ha ingresado correctamente");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } else {
      print("Ha ocurrido un error");
    }
  }
}

class ForgotPasswordModal extends StatefulWidget {
  @override
  _ForgotPasswordModalState createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Recuperar Contraseña',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu correo electrónico';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Aquí puedes implementar la lógica para enviar el correo de recuperación
                final email = _emailController.text;
                // ...

                // Cierra el modal
                Navigator.pop(context);
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}

class RegisterModal extends StatefulWidget {
  @override
  _RegisterModalState createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Registro',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                  ),
                  obscureText: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ]),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Contraseña',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _signUp();

                // Cierra el modal
                Navigator.pop(context);
              }
            },
            child: const Text('Registrarse'),
          ),
        ],
      ),
    );
  }

  void _signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      print("El usuario ha sido registrado");
      Navigator.pushNamed(context, "/home");
    } else {
      print("Ha ocurrido un error");
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: Ingresar(),
  ));
}
