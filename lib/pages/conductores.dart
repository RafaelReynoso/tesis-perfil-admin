import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Conductores extends StatefulWidget {
  const Conductores({super.key});

  @override
  State<Conductores> createState() => _ConductoresState();
}

class _ConductoresState extends State<Conductores> {
  final DatabaseReference _conductoresRef =
      FirebaseDatabase.instance.ref().child('user_locations/conductores');

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conductores', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold,),),
      ),
      body: FutureBuilder<DataSnapshot>(
        future: _conductoresRef.once().then((event) => event.snapshot),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No hay datos disponibles'));
          }

          // Procesa los datos de los conductores
          final conductoresData = snapshot.data!.value as Map<dynamic, dynamic>;

          return ListView.builder(
            
            itemCount: conductoresData.length,
            itemBuilder: (context, index) {
              final conductorKey = conductoresData.keys.elementAt(index);
              final conductorInfo =
                  conductoresData[conductorKey]['informacion'];

              return Card(
                child: ListTile(
                  title: Text(conductorKey),
                  subtitle: Text('Placa: ${conductorInfo['placa']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _mostrarEditarConductorDialog(
                              conductorKey, conductorInfo);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _eliminarConductor(conductorKey);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        onPressed: () {
          // Mostrar un diálogo para agregar un nuevo conductor
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _buildAgregarConductorDialog(context);
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.green,), // Icono de agregar
      ),
    );
  }

  Widget _buildAgregarConductorDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Conductor'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _placaController,
              decoration: const InputDecoration(labelText: 'Placa'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            _crearConductor();
            Navigator.of(context).pop(); // Cierra el diálogo
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }

  void _crearConductor() {
    String nombre = _nombreController.text.trim();
    String password = _passwordController.text.trim();
    String placa = _placaController.text.trim();

    if (nombre.isNotEmpty && password.isNotEmpty && placa.isNotEmpty) {
      _conductoresRef.child(nombre).set({
        'informacion': {
          'password': password,
          'placa': placa,
        }
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conductor agregado exitosamente')),
        );
        _nombreController.clear();
        _passwordController.clear();
        _placaController.clear();
        // Actualizar la lista después de agregar un nuevo conductor
        setState(() {});
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar conductor: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
    }
  }

  void _mostrarEditarConductorDialog(String nombre, Map conductorInfo) {
    _nombreController.text = nombre;
    _passwordController.text = conductorInfo['password'];
    _placaController.text = conductorInfo['placa'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Conductor'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  enabled: false, // Deshabilita la edición del nombre
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                ),
                TextField(
                  controller: _placaController,
                  decoration: const InputDecoration(labelText: 'Placa'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _actualizarConductor(
                  _nombreController.text.trim(),
                  _passwordController.text.trim(),
                  _placaController.text.trim(),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _actualizarConductor(String nombre, String newPassword, String newPlaca) {
  _conductoresRef.child(nombre).update({
    'informacion/password': newPassword,
    'informacion/placa': newPlaca,
  }).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conductor actualizado exitosamente')),
    );
    // Actualizar la lista después de actualizar un conductor
    if (mounted) { // Agregar esta línea para verificar si el widget está montado
      setState(() {});
    }
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al actualizar conductor: $error')),
    );
  });
}


  void _eliminarConductor(String nombre) {
    _conductoresRef.child(nombre).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conductor eliminado exitosamente')),
      );
      // Actualizar la lista después de eliminar un conductor
      setState(() {});
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar conductor: $error')),
      );
    });
  }
}
