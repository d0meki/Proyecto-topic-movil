import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:topicos_proy/src/util/map_style.dart';

class MapController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  final Map<CircleId, Circle> _circles = {};
  late GoogleMapController _mapController;

  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers.values.toSet();
  Set<Circle> get circles => (_circles.values.toSet());
  MapController() {
    permisoDeUbicacion();
  }

  void permisoDeUbicacion() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
  }

  void onMapCretted(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
    _mapController = controller;
  }

  void onTap(LatLng position) {
    final markerId = MarkerId('1');
    final circleId = CircleId('1');
    print(_circles.length);
    // final markerId = MarkerId(_markers.length.toString());
    // final circleId = CircleId(_markers.length.toString());
    final marker = Marker(markerId: markerId, position: position);
    final circle = Circle(
        circleId: circleId,
        center: position,
        radius: 400,
        strokeWidth: 2,
        strokeColor: Colors.green,
        fillColor: Colors.green.withAlpha(70));
    _circles[circleId] = circle;
    _markers[markerId] = marker;
    notifyListeners();
  }

  final initialCamarePosition = const CameraPosition(
    target: LatLng(-17.78629, -63.18117),
    zoom: 12.4746,
  );
}
