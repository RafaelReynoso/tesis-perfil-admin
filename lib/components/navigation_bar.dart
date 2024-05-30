import 'package:flutter/material.dart';
import 'package:tesis_perfil_admin/pages/horario.dart';
import 'package:tesis_perfil_admin/pages/map.dart';
import 'package:tesis_perfil_admin/pages/notifications.dart';
import 'package:tesis_perfil_admin/pages/profile.dart';


class Barra_Navegacion extends StatefulWidget {


  const Barra_Navegacion({super.key});

  @override
  State<Barra_Navegacion> createState() => _Barra_Navegacion();
}

class _Barra_Navegacion extends State<Barra_Navegacion> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'E.T. San Bartolome',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.green,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Usuario',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.map)),
            label: 'Mapa',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.circle_notifications),
            ),
            label: 'Notis',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_bus),
            label: 'Conductores',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Horario',
          ),
        ],
      ),
      body: <Widget>[
        /// Usuario
        const Card(
          shadowColor: Colors.transparent,
          margin: EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Profile(),
          ),
        ),

        /// Mapa
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: AdminMapScreen(),
          ),
        ),

        /// Notificaciones
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Notifications(),
          ),
        ),
        
        /// Conductores
        const Card(
          shadowColor: Colors.transparent,
          margin: EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Horario(),
          ),
        ),

        /// Horario
        const Card(
          shadowColor: Colors.transparent,
          margin: EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Horario(),
          ),
        ),

      ][currentPageIndex],
    );
  }
}