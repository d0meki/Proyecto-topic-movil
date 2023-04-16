import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:topicos_proy/src/Controllers/map_controller.dart';

class MapaGoogle extends StatelessWidget {
  const MapaGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapController>(
        create: (_) => MapController(),
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('Google Map')),
          ),
          body: Consumer<MapController>(
            builder: (_, controller, __) => GoogleMap(
              onMapCreated: controller.onMapCretted,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: controller.initialCamarePosition,
              onTap: controller.onTap,
              markers: controller.markers,
              circles: controller.circles,
            ),
          ),
        ));
  }
}

// class MapaGoogle extends StatefulWidget {
//   const MapaGoogle({super.key});

//   @override
//   State<MapaGoogle> createState() => _MapaGoogleState();
// }

// class _MapaGoogleState extends State<MapaGoogle> {
//   MapController googleMapController = MapController();
//   List<Marker> myMarkers = [];
//   double tamCircle = 400;
//   LatLng? lugarCirculo;

//   @override
//   void initState() {
//     super.initState();

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(child: Text('Google Map')),
//       ),
//       body: GoogleMap(
//           onMapCreated: googleMapController.onMapCretted,
//           myLocationButtonEnabled: true,
//           myLocationEnabled: true,
//           mapType: MapType.normal,
//           initialCameraPosition: googleMapController.initialCamarePosition,
//           onTap: googleMapController.onTap,
//           markers: googleMapController.markers,
//           ),
//     );
//   }

//   _handleTap(LatLng tappedPoint) {
   
//     setState(() {
//       myMarkers = [];
//       myMarkers.add(
//         Marker(
//             markerId: MarkerId(tappedPoint.toString()), position: tappedPoint),
//       );
//       lugarCirculo = tappedPoint;
//       cargarCircle(tappedPoint);
//     });
//   }

//   void cargarCircle(posicion) {
//     CircleId c = CircleId('1');
//     Circle circulo = Circle(
//         circleId: c,
//         center: posicion,
//         radius: tamCircle,
//         strokeWidth: 2,
//         strokeColor: Colors.green,
//         fillColor: Colors.green.withAlpha(70));
//     // myCircle[c] = circulo;
//   }
// }
