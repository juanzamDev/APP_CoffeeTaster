import 'package:example/sources/acerca_de.dart';
import 'package:flutter/material.dart';
import '../code_page.dart';
import 'emp_catacion.dart';
import 'reportes.dart';
import '../main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Function() onTap,
    required String logoPath,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                logoPath,
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Text("Coffee Taster", style: TextStyle(color: Colors.white)),
            const Spacer(),
            Image.asset(
              'assets/sennova.png',
              height: 30,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logosenab.png',
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'SENNOVA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Options
            ListTile(
              title: Row(
                children: [
                  Text(
                    'Proximamente:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.apple,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'App para IOS',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Editar perfil catador',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.table_bar,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Añadir catadores a la mesa',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Descarga de reportes por ID',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.coffee,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Varias cataciones al tiempo',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.table_chart,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Más formatos de catacación',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),

            SizedBox(height: 200),
            Divider(), // Agrega una línea divisoria antes del botón de salir
            ListTile(
              title: Row(
                children: [
                  SizedBox(width: 40),
                  GestureDetector(
                    onTap: () {
                      // Navega a la pantalla "Acerca de"
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AcercaDe()),
                      );
                    },
                    child: Text(
                      'Acerca de',
                      style: TextStyle(
                          color: Colors
                              .blue), // Cambia el color según tus preferencias
                    ),
                  ),
                  SizedBox(width: 48),
                  Text(
                    'Salir',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ),
                ],
              ),
              onTap: () async {
                // Cierra la sesión del usuario
                await FirebaseAuth.instance.signOut();

                // Navega a la pantalla de inicio de sesión
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 50),
          _buildOptionTile(
            title: 'Empezar catación',
            subtitle: 'Inicia una nueva catación',
            icon: Icons.coffee,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const CodePage(
                      title: 'Empezar',
                      child: EmpCatacion(),
                    );
                  },
                ),
              );
            },
            logoPath: 'assets/coffee.png',
          ),
          SizedBox(height: 8),
          _buildOptionTile(
            title: 'Ver mis cataciones',
            subtitle: 'Resumen de las cataciónes',
            icon: Icons.report,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const CodePage(
                    title: 'Mis cataciones',
                    child: Reportes(),
                  );
                },
              ));
            },
            logoPath: 'assets/consulta_reporte.png',
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}
