import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class ConductorMapScreen extends StatefulWidget {
  const ConductorMapScreen({super.key});

  @override
  _ConductorMapScreenState createState() => _ConductorMapScreenState();
}

class _ConductorMapScreenState extends State<ConductorMapScreen> with WidgetsBindingObserver {
  GoogleMapController? mapController;
  Location location = Location();
  late LatLng _initialcameraposition;
  late StreamSubscription<LocationData> locationSubscription;
  late String _conductorId;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('user_locations');
  Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);  // Agregar observador
    _initialcameraposition = LatLng(0.0, 0.0);
    _conductorId = Uuid().v4();
    locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
      _updateLocation(currentLocation);
    });
    _listenToUsuarioChanges();
    _loadInitialUsuarioLocations();
  }

  Future<void> _updateLocation(LocationData locationData) async {
    await databaseReference.child('conductores').child(_conductorId).set({
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
    });
    setState(() {
      _initialcameraposition = LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  void _listenToUsuarioChanges() {
    databaseReference.child('usuarios').onChildChanged.listen((event) {
      String usuarioId = event.snapshot.key!;
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      double latitude = data['latitude'];
      double longitude = data['longitude'];
      _updateMarker(usuarioId, latitude, longitude);
    });
  }

  void _loadInitialUsuarioLocations() async {
    DataSnapshot snapshot = await databaseReference.child('usuarios').get();
    if (snapshot.value != null) {
      Map<dynamic, dynamic>? usuarios = snapshot.value as Map<dynamic, dynamic>?;
      if (usuarios != null) {
        usuarios.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            double latitude = value['latitude'];
            double longitude = value['longitude'];
            _updateMarker(key, latitude, longitude);
          }
        });
      }
    }
  }

  Future<BitmapDescriptor> _getUserMarkerIconFromAsset() async {
    return await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/user_map.png',
    );
  }

  void _updateMarker(String id, double latitude, double longitude) async {
    final icon = await _getUserMarkerIconFromAsset();

    setState(() {
      _markers.remove(id);  // Eliminar el marcador anterior
      _markers[id] = Marker(
        markerId: MarkerId(id),
        position: LatLng(latitude, longitude),
        icon: icon,
        infoWindow: InfoWindow(title: 'Usuario $id'),
      );
    });
  }

  @override
  void dispose() {
    _removeConductorLocation();  // Eliminar la ubicación del conductor al cerrar la app
    locationSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);  // Eliminar observador
    super.dispose();
  }

  void _removeConductorLocation() {
    databaseReference.child('conductores').child(_conductorId).remove();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _removeConductorLocation();  // Eliminar la ubicación del conductor si la app se cierra o se pone en segundo plano
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialcameraposition,
          zoom: 15.5,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: Set<Marker>.of(_markers.values),
      ),
    );
  }
}