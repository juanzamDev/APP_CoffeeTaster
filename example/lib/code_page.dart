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
        title: Row(
          children: [
            Text(title),
            const Spacer(), // Esto añade un espacio flexible entre el título y la imagen
            Image.asset(
              'assets/sennova.png',
              height: 30, // Ajusta la altura según tu necesidad
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
