import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminMapScreen extends StatefulWidget {
  @override
  _AdminMapScreenState createState() => _AdminMapScreenState();
}

class _AdminMapScreenState extends State<AdminMapScreen> with WidgetsBindingObserver {
  GoogleMapController? mapController;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref('user_locations');
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _listenToLocationChanges();
    _loadInitialLocations();
  }

  void _listenToLocationChanges() {
    databaseReference.child('conductores').onChildChanged.listen((event) {
      String conductorId = event.snapshot.key!;
      Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && data.containsKey('ubicacion')) {
        Map<dynamic, dynamic>? ubicacion = data['ubicacion'] as Map<dynamic, dynamic>?;
        if (ubicacion != null) {
          double latitude = ubicacion['latitude'];
          double longitude = ubicacion['longitude'];
          _updateMarker(conductorId, latitude, longitude, 'Conductor');
        }
      }else{
        _removeMarker(conductorId);
      }
    });

    // Escuchar eliminación de conductores
    databaseReference.child('conductores').child('ubicacion').onChildRemoved.listen((event) {
      String conductorId = event.snapshot.key!;
      _removeMarker(conductorId);
    });

    // Escuchar cambios en la ubicación de los usuarios
    databaseReference.child('usuarios').onChildChanged.listen((event) {
      String usuarioId = event.snapshot.key!;
      Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && data.containsKey('latitude') && data.containsKey('longitude')) {
        double latitude = data['latitude'];
        double longitude = data['longitude'];
        _updateMarker(usuarioId, latitude, longitude, 'Usuario');
      }
    });

    // Escuchar eliminación de usuarios
    databaseReference.child('usuarios').onChildRemoved.listen((event) {
      String usuarioId = event.snapshot.key!;
      _removeMarker(usuarioId);
    });
  }

  void _removeMarker(String id) {
    setState(() {
      _markers.remove(id);
    });
  }

  void _loadInitialLocations() async {
    // Cargar ubicaciones iniciales de los conductores
    DataSnapshot snapshotConductores = await databaseReference.child('conductores').get();
    if (snapshotConductores.value != null) {
      Map<dynamic, dynamic>? conductores = snapshotConductores.value as Map<dynamic, dynamic>?;
      if (conductores != null) {
        conductores.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && value.containsKey('ubicacion')) {
            double latitude = value['ubicacion']['latitude'];
            double longitude = value['ubicacion']['longitude'];
            _updateMarker(key, latitude, longitude, 'Conductor');
          }
        });
      }
    }

    // Cargar ubicaciones iniciales de los usuarios
    DataSnapshot snapshotUsuarios = await databaseReference.child('usuarios').get();
    if (snapshotUsuarios.value != null) {
      Map<dynamic, dynamic>? usuarios = snapshotUsuarios.value as Map<dynamic, dynamic>?;
      if (usuarios != null) {
        usuarios.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            double latitude = value['latitude'];
            double longitude = value['longitude'];
            _updateMarker(key, latitude, longitude, 'Usuario');
          }
        });
      }
    }
  }

  Future<BitmapDescriptor> _getMarkerIconFromAsset(String assetName) async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      assetName,
    );
  }

  void _updateMarker(String id, double latitude, double longitude, String tipo) async {
    final icon = await _getMarkerIconFromAsset(
      tipo == 'Conductor' ? 'assets/bus.png' : 'assets/user_map.png',
    );
    if (mounted) {
      setState(() {
        _markers[id] = Marker(
          markerId: MarkerId(id),
          position: LatLng(latitude, longitude),
          icon: icon,
          infoWindow: InfoWindow(title: '$tipo $id'),
        );
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Implementar lógica si es necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-11.93291224406842, -76.69001321910912),
          zoom: 11.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          _addMarkers();
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: Set<Marker>.of(_markers.values),
      ),
    );
  }

  void _addMarkers() async {
    try {
      // Marcador para Chosica
      final chosicaIcon = await _getMarkerIconFromAsset('assets/chosica.png');
      _markers['Chosica'] = Marker(
        markerId: const MarkerId('Chosica'),
        position: const LatLng(-11.972826145886723, -76.76051366983118),
        icon: chosicaIcon,
        infoWindow: const InfoWindow(
          title: 'Chosica',
          snippet: 'Paradero Chosica',
        ),
      );

      // Marcador para Corcona
      final corconaIcon = await _getMarkerIconFromAsset('assets/corcona.png');
      _markers['Corcona'] = Marker(
        markerId: const MarkerId('Corcona'),
        position: const LatLng(-11.91023831303057, -76.5793607100342),
        icon: corconaIcon,
        infoWindow: const InfoWindow(
          title: 'Corcona',
          snippet: 'Paradero Corcona',
        ),
      );

      // Forzar el setState para asegurarnos de que se actualizan los marcadores en el mapa
      setState(() {});
    } catch (e) {
      print("Error cargando los iconos: $e");
    }
  }
}
