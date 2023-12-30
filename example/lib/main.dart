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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
        ),
      ),
      home: SplashScreen(), // Mostrar SplashScreen como la pantalla inicial
    ),
  );
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Lógica de autenticación asincrónica
      future: checkAuthentication(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // La autenticación ha terminado, ahora decide a dónde navegar
          if (snapshot.hasError) {
            // Manejar errores, si es necesario
            return Scaffold(
              body: Center(
                child: Text('Error de autenticación'),
              ),
            );
          } else {
            // Navegar a la pantalla correspondiente
            return decideInitialScreen(snapshot.data);
          }
        } else {
          // Mostrar SplashScreen mientras se realiza la autenticación
          return Scaffold(
            body: Center(
              child: Image.asset('assets/coffee_taster_logo.png',
                  height: 100, width: 100),
            ),
          );
        }
      },
    );
  }

  // Lógica de autenticación
  Future<User?> checkAuthentication() async {
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      // Manejar errores, si es necesario
      print('Error de autenticación: $e');
      return null;
    }
  }

  // Método para decidir a dónde navegar basándote en el resultado de la autenticación
  Widget decideInitialScreen(User? user) {
    if (user != null) {
      return Home();
    } else {
      return _IngresarPage();
    }
  }
}

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
      home: SplashScreen(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}
