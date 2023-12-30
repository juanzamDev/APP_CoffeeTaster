import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AcercaDe extends StatelessWidget {
  const AcercaDe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Text("Acerca de", style: TextStyle(color: Colors.white)),
            const Spacer(),
            Image.asset(
              'assets/sennova.png',
              height: 30,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 120,
              backgroundImage: AssetImage('assets/juanzam.jpg'),
              backgroundColor:
                  Colors.transparent, // Establece el fondo transparente
              child: Align(
                alignment: Alignment.center,
                child: ClipOval(
                  child: Container(
                    width:
                        240, // Ajusta el tamaño del contenedor según tus necesidades
                    height:
                        240, // Ajusta el tamaño del contenedor según tus necesidades
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/juanzam.jpg'),
                        fit: BoxFit
                            .cover, // Puedes ajustar el modo de ajuste según tus necesidades
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Juan Zambrano',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Desarrollador',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            Divider(
              color: Colors.green,
            ),
            Text(
              '"¡Hola! Soy Juan Diego Zambrano, un apasionado desarrollador dedicado a la creación de soluciones innovadoras. Mi especialización se centra en el desarrollo de aplicaciones móviles utilizando Flutter y Dart, tanto para la plataforma iOS como para Android.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('311 583 9595'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('juanzambrano021@gmail.com'),
            ),
            ListTile(
              leading: ImageIcon(
                AssetImage(
                    'assets/linkedin.png'), // Reemplaza con la ruta de tu ícono de LinkedIn
                size: 24, // Tamaño del ícono
                color: Colors.blue, // Color del ícono
              ),
              title: Text('LinkedIn'),
              onTap: () {
                launchUrlString("https://www.linkedin.com/in/juanzam/");
              },
            ),
            ListTile(
              leading: ImageIcon(
                AssetImage(
                    'assets/github.png'), // Reemplaza con la ruta de tu ícono de LinkedIn
                size: 24, // Tamaño del ícono
                color: Colors.black, // Color del ícono
              ),
              title: Text('Github'),
              onTap: () {
                launchUrlString("https://github.com/JuanZam21");
              },
            ),
            SizedBox(height: 16),
            Text(
              'Todos los derechos reservados - SENNA - SENNOVA',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
