// ignore_for_file: use_build_context_synchronously, avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';
import 'package:topicos_proy/src/Controllers/luxand_controller.dart';
import '../../models/datarecognition.dart';

class CamaraApp extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CamaraApp({this.cameras, Key? key}) : super(key: key);
  @override
  State<CamaraApp> createState() => _CamaraAppState();
}

class _CamaraAppState extends State<CamaraApp> {
  late CameraController _cameraController;
  late Future<void> _initializeCameraCtrlFuture;
  late String _imagen64;
  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(widget.cameras![1],
        ResolutionPreset.medium); // la 0 es camara trasera y la 1 la frontal
    _initializeCameraCtrlFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var luxandService = LuxandService();
    late List<DataRecognition> respuesta;
    return Scaffold(
      appBar: AppBar(title: const Text('Tomar una foto')),
      body: FutureBuilder<void>(
          future: _initializeCameraCtrlFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_cameraController);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeCameraCtrlFuture;
              final image = await _cameraController.takePicture();
              List<int> bytes = File(image.path).readAsBytesSync();
              _imagen64 = base64.encode(bytes);
              showDialog(
                  context: context,
                  builder: (context) {
                    return const Center(child: CircularProgressIndicator());
                  });
              respuesta = await luxandService.reconocerCara(_imagen64);
              if (respuesta.isNotEmpty) {
                Navigator.pushNamed(context, 'home',
                    arguments: respuesta[0].uuid);
              } else {
                showDialog(
                    context: context,
                    builder: ((context) => AlertDialog(
                          title: const Text('Warnning'),
                          content: const Text('Usuario No Registrado'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      'login', (Route<dynamic> route) => false);
                                },
                                child: const Text('Yes'))
                          ],
                        )));
              }
            } catch (e) {
              print(e);
            }
          },
          child: const Icon(Icons.camera_alt)),
    );
  }
}
// class ViewImageScreen extends StatelessWidget {
//   final String imagePath;
//   const ViewImageScreen({super.key, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     print(imagePath);
//     return Scaffold(
//       appBar: AppBar(title: Text('Ver imagen')),
//       body: Image.file(File(imagePath)),
//     );
//   }
// }
