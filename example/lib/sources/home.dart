import 'package:flutter/material.dart';
import '../code_page.dart';
import 'emp_catacion.dart';
import 'consulta_reporte.dart';
import '../main.dart';

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
        title: Row(
          children: [
            const Text('Coffee Taster'),
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'SENNOVA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // Opciones del Drawer
            ListTile(
              title: const Text('Opción 1'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
            ListTile(
              title: const Text('Opción 2'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
            // ... Agrega más opciones según sea necesario
            ListTile(
              title: const Text('Salir'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          const Divider(),
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
          const Divider(),
          _buildOptionTile(
            title: 'Consultar Reportes',
            subtitle: 'Ver informes y estadísticas',
            icon: Icons.report,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const CodePage(
                    title: 'Empezar',
                    child: ConsultaReporte(),
                  );
                },
              ));
            },
            logoPath:
                'assets/consulta_reporte.png', // Cambia la ruta del logotipo según sea necesario
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
