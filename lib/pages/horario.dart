import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Horario extends StatefulWidget {
  const Horario({Key? key}) : super(key: key);

  @override
  State<Horario> createState() => _HorarioState();
}

class _HorarioState extends State<Horario> {
  String? _fileName;
  String? _filePath;
  bool _isFileLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Colors.grey[800],
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Horario',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );

                if (result != null) {
                  setState(() {
                    _fileName = result.files.first.name;
                    _filePath = result.files.first.path!;
                    _isFileLoaded = true;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, selecciona un archivo.'),
                    ),
                  );
                }
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.upload_file, size: 18, color: Colors.green),
                  SizedBox(width: 8), // Espacio entre el ícono y el texto
                  Text(
                    'Seleccionar Horario (PDF)',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_isFileLoaded)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.teal,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _fileName!,
                      style: TextStyle(
                        color: Colors.teal[800],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_isFileLoaded) {
                  final pdf = pw.Document();

                  pdf.addPage(
                    pw.Page(
                      build: (context) {
                        return pw.Center(
                          child: pw.Text(
                            'Contenido del horario aquí', // Aquí deberías incluir el contenido de tu horario
                            style: pw.TextStyle(fontSize: 20),
                          ),
                        );
                      },
                    ),
                  );

                  final pdfBytes = await pdf.save();
                  final pdfFileName = 'horario.pdf'; // Nombre del archivo PDF

                  Reference storageRef = FirebaseStorage.instance
                      .ref()
                      .child('horarios')
                      .child(pdfFileName);
                  await storageRef.putData(pdfBytes);

                  String fileUrl = await FirebaseStorage.instance
                      .ref('horarios/$pdfFileName')
                      .getDownloadURL();
                  await FirebaseFirestore.instance
                      .collection('horarios')
                      .doc('choferes')
                      .set({'fileUrl': fileUrl});

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Éxito',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        content: const Text('Horario publicado con éxito.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Aceptar',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por favor, selecciona un archivo antes de publicar.'),
                    ),
                  );
                }
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.send, size: 18, color: Colors.green),
                  SizedBox(width: 8), // Espacio entre el ícono y el texto
                  Text(
                    'Publicar Horario (PDF)',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
