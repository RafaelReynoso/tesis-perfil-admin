import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.circle_notifications,
                    color: Colors.grey[800],
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Notificaciones',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => const AdminPanelDialog(),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: const <Widget>[
          SectionTitle(title: 'Notificaciones para Usuarios'),
          NotificationCard(
            message: 'Pasajeros a 300 metros',
            iconColor: Colors.green,
          ),
          NotificationCard(
            message: 'Pasajeros a 600 metros',
            iconColor: Colors.yellow,
          ),
          SectionTitle(title: 'Notificaciones para Conductores'),
          NotificationCard(
            message: 'Mantenimiento programado',
            iconColor: Colors.green,
          ),
          NotificationCard(
            message: 'Vehículo averiado',
            iconColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String message;
  final Color iconColor;

  const NotificationCard({
    required this.message,
    required this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.notifications_sharp,
          color: iconColor,
        ),
        title: Text(message),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AdminPanelDialog extends StatefulWidget {
  const AdminPanelDialog({super.key});

  @override
  _AdminPanelDialogState createState() => _AdminPanelDialogState();
}

class _AdminPanelDialogState extends State<AdminPanelDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  String _notificationType = 'Usuario';
  String _notificationStatus = 'Verde';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Mensaje'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un mensaje';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _notificationType,
                decoration: const InputDecoration(labelText: 'Notificacion para:'),
                items: <String>['Usuario', 'Conductor']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _notificationType = newValue!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _notificationStatus,
                decoration: const InputDecoration(labelText: 'Estado de Notificación:'),
                items: <String>['Verde', 'Amarillo', 'Rojo']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _notificationStatus = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí se podría agregar la lógica para enviar la notificación
                    // por ejemplo, agregar la notificación a una lista o enviarla a un servidor
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notificación enviada'),
                    ));
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Enviar Notificación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
