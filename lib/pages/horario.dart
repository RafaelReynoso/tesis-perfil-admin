import 'package:flutter/material.dart';
import '../components/chosica.dart';
import '../components/bartolome.dart';

class Horario extends StatefulWidget {
  const Horario({super.key});

  @override
  State<Horario> createState() => _Horario();
}

class _Horario extends State<Horario> {
  String? _selectedParadero;
  final List<String> _paraderos = [
    'Chosica',
    'San Bartolome',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container con sombreado gris para el Row
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Color de fondo gris claro
                borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                boxShadow: [
                  // Sombra para el Container
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Texto a la izquierda
                  const Text(
                    'Paradero:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                      width: 8), // Espacio entre el texto y el dropdown
                  // Dropdown a la derecha
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: _dropDown(),
                    ),
                  ),
                ],
              ),
            ),
            // Mostrar el componente según la selección
            if (_selectedParadero == 'Chosica') const Chosica(),
            if (_selectedParadero == 'San Bartolome') const Bartolome(),
          ],
        ),
      ),
    );
  }

  // Helper method para crear el dropdown widget
  Widget _dropDown() {
    return DropdownButton<String>(
      isExpanded: true, // Para que el dropdown ocupe todo el espacio disponible
      value: _selectedParadero,
      onChanged: (String? newValue) {
        setState(() {
          _selectedParadero = newValue;
        });
      },
      items: _paraderos.map((String paradero) {
        return DropdownMenuItem<String>(
          value: paradero,
          child: Text(paradero),
        );
      }).toList(),
      underline: Container(),
      hint: const Text(
        'Seleccione un paradero', // Placeholder
        style: TextStyle(
            color: Colors.grey), // Puedes personalizar el estilo del texto
      ), // Sin línea subrayada
    );
  }
}