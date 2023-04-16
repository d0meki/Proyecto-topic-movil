// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:topicos_proy/src/Controllers/reclamo_fire_controller.dart';

class Reclamo extends StatefulWidget {
  const Reclamo({super.key});

  @override
  State<Reclamo> createState() => _ReclamoState();
}

class _ReclamoState extends State<Reclamo> {
   var fechaActual = DateTime.now();
  List<String> listaCategorias = ["Caminos", "Seguridad", "Basuras", "Otros"];
  String? _selectCategoria;
  final List _images = [];
  final List _imagesPath = [];
  late File imageFile;
  late List<String> urlFotos = [];
  TextEditingController? _descripcionController;
  final picker = ImagePicker();
  var reclamoService = FirebaseReclamo();
  choceImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final String fileName = pickedFile.path.split('/').last;
      final urlImage = await reclamoService.uploadDenunciaStorage(
          File(pickedFile.path), fileName);
      urlFotos.add(urlImage);
      setState(() {
        _imagesPath.add(pickedFile.path);
        _images.add(File(pickedFile.path));
      });
    }
  }

  choceImageCamare() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final String fileName = pickedFile.path.split('/').last;
      final urlImage = await reclamoService.uploadDenunciaStorage(
          File(pickedFile.path), fileName);
      urlFotos.add(urlImage);
      setState(() {
        _imagesPath.add(pickedFile.path);
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    Position position = await determinePosition();
    // final reclamosService = ReclamosService();
    final List<String> posicion = [
      position.latitude.toString(),
      position.longitude.toString()
    ];

    Map<String, dynamic> data = {
      "categoria": _selectCategoria,
      "descripcion": _descripcionController?.text,
      "uuid": '1',
      "posicion": posicion,
      "fotos": urlFotos,
      "fecha": '${fechaActual.day}-${fechaActual.month}-${fechaActual.year}'
    };
    final respuesta = await reclamoService.addReclamo(data);
    // print(data);
   // final respuesta = await reclamosService.registrarReclamo(data);
    if (respuesta) {
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: const Text('Success'),
                content: const Text("reclamo registrado con exito"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "lista_reclamos");
                      },
                      child: const Text('Yes'))
                ],
              )));
    } else {
      Navigator.pop(context);
      // print(respuesta['message']);
    }
  }


  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController();
    _selectCategoria = listaCategorias[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 90.0),
            child: Text('Reclamo'),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: "Cancelar",
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.close),
          //     tooltip: 'Cancelar',
          //     onPressed: () {},
          //   ),
          // ],
          ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CarouselSlider.builder(
              itemCount: _images.length,
              options: CarouselOptions(
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                autoPlay: true,
              ),
              itemBuilder: (ctx, index, realIdx) {
                return _images.isNotEmpty
                    ? Container(
                        color: Colors.blueGrey,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey,
                                image: DecorationImage(
                                    image: FileImage(_images[index])))))
                    : Container(
                        color: Colors.blueGrey,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey,
                                image: const DecorationImage(
                                    image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKv97i2txLSKTCqwYH-3znwwNtuVQqAS1Xtq377G7r7APyz6IWhUobssxIxG7BKQ8eNhI&usqp=CAU")))),
                      );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 100.0, left: 100.0),
              child: RawMaterialButton(
                fillColor: const Color.fromARGB(155, 4, 44, 247),
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () async {
                  // choceImage();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0)), //this right here
                          child: SizedBox(
                            height: 150,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  const Text(
                                    'Select Image From !',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          choceImageGallery();
                                        },
                                        child: Card(
                                            elevation: 5,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/img/gallery.png',
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          choceImageCamare();
                                        },
                                        child: Card(
                                            elevation: 5,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/img/camera.png',
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                  const Text('Camera'),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: const Center(
                    child: Text(
                  "Subir Una Imagen",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 100, top: 10),
                    child: Text("Categoria: ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Center(
                        child: _selectComboBoxCategoria(),
                      )),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextFormField(
                controller: _descripcionController,
                minLines: 6,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  labelText: 'Descripcion',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
           getCurrentLocation();
        },
        tooltip: 'Enviar',
        child: const Icon(Icons.check),
      ),
    );
  }

  _selectComboBoxCategoria() {
    return DropdownButton<String>(
      value: _selectCategoria,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      borderRadius: BorderRadius.circular(2),
      focusColor: Colors.blue,
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectCategoria = newValue!;
        });
      },
      items: listaCategorias.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}


 // void subirImagemes() async {
    // final reclamosService = ReclamosService();
    // final respuesta =
    //     await reclamosService.uploadAvatar(_imagesPath.elementAt(0));
    // await reclamosService.uploadAvatar(_imagesPath.elementAt(0));
    // await reclamosService.subirFotos(_imagesPath);
    // print(respuesta['status']);
    // final List<String> images64 = [];
    // for (var i = 0; i < _imagesPath.length; i++) {
    //   List<int> bytes = File(_imagesPath.elementAt(i)).readAsBytesSync();
    //   images64.add(base64.encode(bytes));
    // }
    // Map<String, dynamic> datitos = {
    //   "reclamo_id": '1',
    //   "image": images64,
    // };
    // print(datitos);
    // final respuesta = await reclamosService.uploadPhotos(datitos);
    // print(respuesta['status']);
 // }