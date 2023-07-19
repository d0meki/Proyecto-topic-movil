// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //para el uso de Timestamp formato de fechas aceptadas en firebase
import 'package:flutter/services.dart'; // PARA EL USO DE Uint8List (convierte la imagen en bytes)
import 'package:geolocator/geolocator.dart'; // UBICACION
import 'package:image_cropper/image_cropper.dart'; //PARA REDIMENCIONAR IMAGENES
import 'package:image_picker/image_picker.dart'; // PARA CAPUTRAR LA IMAGEN DE GALERIA O CAMARA
import 'package:carousel_slider/carousel_slider.dart'; //PARA EL CARRUSEL DE IMAGENES
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topicos_proy/src/Controllers/reclamoService.dart'; // CONTROLADOR DONNDE CONSUMIMOS LAS APIS
import 'package:topicos_proy/src/widget/textform.dart'; // widget
import 'package:topicos_proy/src/widget/widgets.dart'; // widget
import 'dart:io'; //MANEJO DE ARCHIVOS
import 'dart:ui' as ui; //PARA OBTENER LAS DIMENCIONES EXACTAS DE LA IMAGEN

class Reclamo extends StatefulWidget {
  const Reclamo({super.key});
  @override
  State<Reclamo> createState() => _ReclamoState();
}

class _ReclamoState extends State<Reclamo> {
  //VARIABLES DEFINIDAS
  final List _images = [];
  String _selectCategoria = "0";
  TextEditingController? _descripcionController;
  TextEditingController? _tituloController;
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  ServiceReclamo reclamoService = ServiceReclamo();

  //ESTADO DE INICIO
  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController();
    _tituloController = TextEditingController();
    // categoriaLista =  reclamoService.getCategorias();
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
                          color: Colors.white,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: FileImage(_images[index])))))
                      : Container(
                          color: Colors.white,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
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
                  fillColor: Colors.lightBlueAccent,
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

                    // MiWidget()
                    Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Center(child: _obtenerCategorias())),
                  ]),
                ),
              ),
              // Padding(padding: const EdgeInsets.all(8.0),child: Text('$cantidadDeCaracteres'),),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextFormField(
                  controller: _descripcionController,
                  minLines: 6,
                  maxLines: null,
                  maxLength: 512,
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (_images.isNotEmpty) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        });
                    print("Guardar");
                    getCurrentLocation();
                    /* final verificarTexto =
                        await reclamoService.verificarTextoOfensivoDos(
                            _descripcionController!.text);
                    Navigator.pop(context);
                    if (verificarTexto.toUpperCase() == 'FALSO.' ||
                        verificarTexto.toUpperCase() == 'FALSO') {
                      print("Guardar");
                      getCurrentLocation();
                    } else {
                      if (verificarTexto.toUpperCase() == 'VERDADERO.' ||
                          verificarTexto.toUpperCase() == 'VERDADERO') {
                        Widgets.alertSnackbar(context,
                            "Descripcion no debe contener lenguaje ofensivo");
                      } else {
                        Widgets.alertSnackbar(
                            context, "Ha sucedido algun error");
                      }
                    } */
                  } else {
                    Widgets.alertSnackbar(
                        context, "Debe elegir almenos una imagen");
                  }
                }
              },
              label: const Text('Guardar y Enviar'),
              icon: const Icon(Icons.save),
              backgroundColor: Colors.lightBlueAccent,
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
        Widgets.alertSnackbar(context, "La imagen debe ser de 1024x800");
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
    final List fotosReclamos = [];
    Timestamp fechaActual = Timestamp.fromDate(DateTime.now());
    //VERIFICANDO QUE NO SE HAGAN MAS DE 2 DENUNCIAS DEL MISMO TIPO EN EL MISMO DIA
    final existeDosReclamos =
        await reclamoService.reclamoNoRepetidoElMismoDia(_selectCategoria);
    Navigator.pop(context);
    if (existeDosReclamos) {
      Widgets.alertSnackbar(
          context, "ya existen dos reclamos de la misma categoria");
      return;
    }
    //OBTENER POSICION
    Position position = await determinePosition();
    final List<String> posicion = [
      position.latitude.toString(),
      position.longitude.toString()
    ];
    //OBTENER LOS ARCHIVOS SELECCIONADOS EN EL TEMPORAL Y MANDAR A VERIFICAR CON EL SERVICIO
    for (var element in _images) {
      final String fileName = element.path.split('/').last;
      final urlImage = await reclamoService.uploadDenunciaStorage(
          File(element.path), fileName);
      fotosReclamos.add(urlImage);
    }
    /* final respuestaVerificarFotos =
        await reclamoService.verificarFotoQueCoinsida(
            _descripcionController!.text, fotosReclamos[0]);
    if (respuestaVerificarFotos.toUpperCase() == 'FALSO' ||
        respuestaVerificarFotos.toUpperCase() == 'FALSO.') {
      Widgets.alertSnackbar(
          context, "La foto no coinside con la descripcion del reclamo");
      Navigator.pushNamed(context, "lista_reclamos");
      return;
    } */
    //CONSTRUIMOS LA DATA CON LOS DATOS DEL FORMULARIO Y ENVIAR AL SERVICIO PARA AÑADIRLOS A LA BD
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final List<String> items = sharedPreferences.getStringList('acces_token')!;
    final uid = items[1];
    Map<String, dynamic> data = {
      "categoria": _selectCategoria,
      "descripcion": _descripcionController?.text,
      "titulo": _tituloController?.text,
      "estado": 'pendiente',
      "uuid": uid,
      "posicion": posicion,
      "fotos": fotosReclamos,
      "fecha": fechaActual
    };
    final respuesta = await reclamoService.addReclamo(data);
    if (respuesta) {
      Navigator.pushNamed(context, "lista_reclamos");
      Widgets.alertSnackbar(context, "Su reclamo se registró con exito!");
    } else {
      Navigator.pop(context);
      Widgets.alertSnackbar(context, "Algo salio mal!");
    }
  }

  _obtenerCategorias() {
    return StreamBuilder(
        builder: (context, snapshot) {
          List<DropdownMenuItem> categoriaItem = [];
          categoriaItem.add(const DropdownMenuItem(
              value: "0", child: Text("Seleccion categoria")));
          if (!snapshot.hasData) {
           const CircularProgressIndicator();
          } else {
            final cates = snapshot.data?.docs.reversed.toList();
            for (var cat in cates!) {
              categoriaItem.add(DropdownMenuItem(
                  value: cat['nombre'], child: Text(cat['nombre'])));
            }
          }
          return DropdownButton(
              items: categoriaItem,
              value: _selectCategoria,
              onChanged: (catValue) {
                setState(() {
                  _selectCategoria = catValue;
                });
                // print(_selectCategoria);
              });
        },
        stream: reclamoService.categorias.snapshots());
  }
}
