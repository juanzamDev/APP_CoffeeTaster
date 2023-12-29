import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'code_page.dart';
import 'sources/ingresar.dart';
import 'sources/home.dart';

// Import Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

class _IngresarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CodePage(
      title: 'Ingresar',
      child: Ingresar(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Taster',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: FormBuilderLocalizations.supportedLocales,
      home: _IngresarPage(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Verifica si ya hay un usuario autenticado
  User? user = FirebaseAuth.instance.currentUser;

  runApp(
    MaterialApp(
      title: 'Coffee Taster',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: FormBuilderLocalizations.supportedLocales,
      home: user != null ? Home() : _IngresarPage(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
        ),
      ),
    ),
  );
}
