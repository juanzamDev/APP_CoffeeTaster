import 'dart:io';
import 'package:flutter/material.dart';

//import 'package:open_file/open_file.dart';

class ReportePdf extends StatelessWidget {
  const ReportePdf({Key? key}) : super(key: key);

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Function() onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.green),
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.download),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF'S"),
      ),
      body: ListView(
        children: <Widget>[
          const Divider(),
          _buildOptionTile(
            title: ' #7 Coccentral',
            subtitle: 'Pulse para descargar',
            icon: Icons.picture_as_pdf,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ReportePdf(),
  ));
}
