import 'package:camera/camera.dart';

class CamareService {
  Future<CameraDescription> getCamare() async {
    final camaras = await availableCameras();
    return camaras.first;
  }
}
