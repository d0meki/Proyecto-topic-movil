// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:topicos_proy/src/Controllers/reclamo_fire_controller.dart';
import 'package:topicos_proy/src/widget/textform.dart';
import 'package:topicos_proy/src/widget/widgets.dart';
import 'dart:ui' as ui;

class Reclamo extends StatefulWidget {
  const Reclamo({super.key});
  @override
  State<Reclamo> createState() => _ReclamoState();
}

class _ReclamoState extends State<Reclamo> {
  //VARIABLES DEFINIDAS
  List<String> listaCategorias = [
    "Caminos",
    "Seguridad",
    "Basuras",
    "Alumbrado",
    "Otros"
  ];
  final List _images = [];
  String? _selectCategoria;
  TextEditingController? _descripcionController;
  TextEditingController? _tituloController;
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  var reclamoService = FirebaseReclamo();
  //ESTADO DE INICIO
  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController();
    _tituloController = TextEditingController();
    _selectCategoria = listaCategorias[0];
  }
  //VIEW
  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
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
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.close),
        //     tooltip: 'Cancelar',
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CarouselSlider.builder(
                itemCount: _images.length,
                options: CarouselOptions(
                  aspectRatio: 2.5,
                  enlargeCenterPage: true,
                  autoPlay: false,
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
                  onPressed: _images.length < 2
                      ? () async {
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
                                                          const EdgeInsets.all(
                                                              8.0),
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
                                                          const EdgeInsets.all(
                                                              8.0),
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
                        }
                      : null,
                  child: const Center(
                      child: Text(
                    "Subir Una Imagen",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50.0, left: 50.0),
                child: CustomTextFormField(
                    _tituloController!,
                    const Icon(Icons.title),
                    "Titulo",
                    TextInputType.emailAddress,
                    validateTextFormField: (String value) {
                  if (value.isEmpty) return "El titulo es obligatorio";
                  return null;
                }),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else if (value.length < 64 || value.length > 512) {
                      return 'Texto debe ser entre 64 y 512 caracteres';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      //GUARDAR
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              heroTag: 1,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_images.isNotEmpty) {
                    // print("Guardar");
                    //  final verificarTexto = reclamoService.verificarTextoOfensivo(_descripcionController!.text);
                    //  print(verificarTexto);
                    getCurrentLocation();
                  } else {
                    Widgets.alertSnackbar(
                        context, "Debe elegir almenos una imagen");
                  }
                }
              },
              label: const Text('Guardar y Enviar'),
              icon: const Icon(Icons.save),
              backgroundColor: Colors.pink,
            )
          : null,
    );
  }
  //METODOS
  choceImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Recortar imagen',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
          ],
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.square,
          ],
          maxWidth: 1024,
          maxHeight: 800);
      // final String fileName = pickedFile.path.split('/').last;
      // final urlImage = await reclamoService.uploadDenunciaStorage(
      //     File(pickedFile.path), fileName);
      // urlFotos.add(urlImage);
      // final Uint8List bytes = data.buffer.asUint8List();
      final Uint8List bytes = await croppedFile!.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      if (frameInfo.image.width == 1024 && frameInfo.image.width == 800) {
        // print('La imagen debe ser de 1024x800');
         Widgets.alertSnackbar(
                        context, "La imagen debe ser de 1024x800");
      } else {
        setState(() {
          _images.add(File(croppedFile.path));
        });
      }
    }
  }

  choceImageCamare() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      // final String fileName = pickedFile.path.split('/').last;
      // final urlImage = await reclamoService.uploadDenunciaStorage(
      //     File(pickedFile.path), fileName);
      // urlFotos.add(urlImage);
      // setState(() {
      //   _imagesPath.add(pickedFile.path);
      //   _images.add(File(pickedFile.path));
      // });
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
    final List fotosReclamos = [];
    Timestamp fechaActual = Timestamp.fromDate(DateTime.now());
    for (var element in _images) {
      final String fileName = element.path.split('/').last;
      final urlImage = await reclamoService.uploadDenunciaStorage(
          File(element.path), fileName);
      fotosReclamos.add(urlImage);
    }
    final List<String> posicion = [
      position.latitude.toString(),
      position.longitude.toString()
    ];
    Map<String, dynamic> data = {
      "categoria": _selectCategoria,
      "descripcion": _descripcionController?.text,
      "titulo": _tituloController?.text,
      "estado": 'pendiente',
      "uuid": '1',
      "posicion": posicion,
      "fotos": fotosReclamos,
      "fecha": fechaActual
      // "fecha": '${fechaActual.day}-${fechaActual.month}-${fechaActual.year}'
    };
    final respuesta = await reclamoService.addReclamo(data);
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
    }
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
