import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

class MapsProvider extends ChangeNotifier {
  final double _initLat;
  final double _initLon;

  MapsProvider({
    required double initLat,
    required double initLon,
  })  : _initLat = initLat,
        _initLon = initLon {
    _initializeMarker();
    _getStoryPosition(lat: _initLat, lon: _initLon);
  }

  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  LatLng? _currentLatLon;
  final TextEditingController _addressController = TextEditingController();

  Set<Marker> get markers => _markers;
  LatLng? get currentLatLon => _currentLatLon;
  TextEditingController get addressController => _addressController;

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
    _addressController.dispose();
  }

  set mapController(GoogleMapController value) {
    _mapController = value;
  }

  void _initializeMarker() {
    final marker = Marker(
      markerId: const MarkerId("current-position"),
      position: LatLng(_initLat, _initLon),
    );

    _markers.add(marker);
    notifyListeners();
  }

  void defineNewMarker({required double lat, required double lon}) async {
    _markers.clear();
    final marker = Marker(
      markerId: const MarkerId("current_position"),
      position: LatLng(lat, lon),
    );
    _currentLatLon = LatLng(lat, lon);

    _markers.add(marker);
    notifyListeners();

    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lon), 15),
    );

    await _getStoryPosition(lat: lat, lon: lon);
  }

  Future<void> _getStoryPosition(
      {required double lat, required double lon}) async {
    _addressController.text = '...';

    _currentLatLon = LatLng(lat, lon);

    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    final info = await geo.placemarkFromCoordinates(
      lat,
      lon,
    );

    if (info.isNotEmpty) {
      final place = info[0];
      _addressController.text =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    } else {
      _addressController.text = "Lokasi tidak ditemukan";
    }

    _currentLatLon = LatLng(lat, lon);
    notifyListeners();
  }

  void getMyLocation() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    defineNewMarker(lat: latLng.latitude, lon: latLng.longitude);
    notifyListeners();
  }
}
