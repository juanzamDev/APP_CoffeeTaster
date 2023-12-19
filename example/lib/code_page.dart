import 'package:flutter/material.dart';

class CodePage extends StatelessWidget {
  final String title;
  final Widget child;

  const CodePage({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white), // Cambia el color del botón de retroceso
        title: Row(
          children: [
            Text(title, style: TextStyle(color: Colors.white)),
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
        child: child,
      ),
    );
  }
}
