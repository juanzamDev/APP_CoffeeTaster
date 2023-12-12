import 'package:cloud_firestore/cloud_firestore.dart';

// Conectar a Base de datos
FirebaseFirestore db = FirebaseFirestore.instance;

Future<String> addCatacion(
    String name, String description, String location, String nuMuestras) async {
  DocumentReference documentReference =
      await FirebaseFirestore.instance.collection("cataciones").add({
    "name": name,
    "description": description,
    "location": location,
    "nuMuestras": nuMuestras,
  });

  String catacionId = documentReference.id;
  print("Catación agregada con ID: $catacionId");

  return catacionId; // Devuelve el ID del documento creado
}
