// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:topicos_proy/src/Controllers/luxand_controller.dart';
import 'package:topicos_proy/src/Controllers/reclamos_controller.dart';
import 'package:topicos_proy/src/Controllers/usuario_controller.dart';
import 'package:topicos_proy/src/models/datarecognition.dart';
import 'package:topicos_proy/src/util/validaciones.dart';
import 'package:topicos_proy/src/widget/textform.dart';
import 'package:topicos_proy/src/models/profile.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var luxandService = LuxandService();
  // var reclamosService = ReclamosService();
  var firebaseUsuario = FirebaseUsuario();
  late List<DataRecognition> respuesta;
  late bool guardarUsuario;
  late String url;
  Text msgTextImage = const Text('Foto de perfil no seleccionado');
  // String uuid = '65ef1a9b-d0aa-11ed-86a0-0242ac160002';
  late Profile profile;
  late String imagePath = '';
  late String _imagen64;
  TextEditingController? _nameController;
  TextEditingController? _ciController;
  TextEditingController? _phoneController;
  TextEditingController? _mailController;
  TextEditingController? _uuidController;
  TextEditingController? _avatarController;

  final picker = ImagePicker();
  choceImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final String fileName = pickedFile!.path.split('/').last;
    if (pickedFile != null) {
      List<int> bytes = File(pickedFile.path).readAsBytesSync();
      _imagen64 = base64.encode(bytes);
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      respuesta = await luxandService.reconocerCara(_imagen64);

      Navigator.pop(context);
      if (respuesta.isEmpty) {
        showDialog(
            context: context,
            builder: ((context) => AlertDialog(
                  title: const Text('Warnning'),
                  content: const Text('Unregistered user'),
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
      url = await firebaseUsuario.uploadAvatartorage(
          File(pickedFile.path), fileName);
      setState(() {
        imagePath = pickedFile.path;
        _nameController!.text = respuesta[0].name;
        _uuidController!.text = respuesta[0].uuid;
        // _avatarController!.text = url;
      });
    }
  }

  choceImageCamare() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      List<int> bytes = File(pickedFile.path).readAsBytesSync();
      _imagen64 = base64.encode(bytes);
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      respuesta = await luxandService.reconocerCara(_imagen64);
      Navigator.pop(context);
      if (respuesta.isEmpty) {
        showDialog(
            context: context,
            builder: ((context) => AlertDialog(
                  title: const Text('Warnning'),
                  content: const Text('Unregistered user'),
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
      setState(() {
        imagePath = pickedFile.path;
        _nameController!.text = respuesta[0].name;
        _uuidController!.text = respuesta[0].uuid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _uuidController = TextEditingController();
    _ciController = TextEditingController();
    _phoneController = TextEditingController();
    _mailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 90.0),
            child: Text('Register'),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: "Cancelar",
            onPressed: () {
              Navigator.pop(context, true);
            },
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                child: Center(
                  child: imagePath == ''
                      ? Column(
                          children: [
                            const SizedBox(
                                width: 150,
                                height: 150,
                                child: Icon(Icons.add_a_photo)),
                            msgTextImage
                          ],
                        )
                      : SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.file(File(imagePath))),
                ),
                onTap: () {
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
                                        onTap: () async {
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
                                        onTap: () async {
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
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                child: Column(
                  children: [
                    CustomTextFormField(
                        _nameController!,
                        const Icon(Icons.assignment_outlined),
                        "Nombre y apellido",
                        TextInputType.text,
                        validateTextFormField: (String value) {
                      if (value.isEmpty) return "Escriba su nombre por favor";
                      return null;
                    }),
                    CustomTextFormField(
                        _ciController!,
                        const Icon(Icons.account_box),
                        "Carnet de Identidad",
                        TextInputType.phone,
                        validateTextFormField: (String value) {
                      if (value.isEmpty) return "Escriba su CI por favor";
                      if (!Validation.soloNumeros(_ciController!.text)) {
                        return "Solo se permite números";
                      }
                      return null;
                    }),
                    CustomTextFormField(
                        _phoneController!,
                        const Icon(Icons.phone),
                        "Teléfono",
                        TextInputType.phone,
                        validateTextFormField: (String value) {
                      if (value.isEmpty) return "Escriba su télefono por favor";
                      if (!Validation.soloNumeros(_phoneController!.text)) {
                        return "Solo se permite números";
                      }
                      return null;
                    }),
                    CustomTextFormField(
                        _mailController!,
                        const Icon(Icons.mail),
                        "Correo",
                        TextInputType.emailAddress,
                        validateTextFormField: (String value) {
                      if (value.isEmpty) return "Escriba su correo por favor";
                      return null;
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> data = {
                          "ci": _ciController!.text,
                          "name": _nameController!.text,
                          "telefono": _phoneController!.text,
                          "email": _mailController!.text,
                          "uuid": _uuidController!.text,
                          "avatar": url,
                        };
                        guardarUsuario = await firebaseUsuario.addUser(data);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            });
                        if (guardarUsuario) {
                          showDialog(
                              context: context,
                              builder: ((context) => AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text(
                                        "Usuario Registrado Con Exito"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    'login',
                                                    (Route<dynamic> route) =>
                                                        false);
                                          },
                                          child: const Text('Yes'))
                                    ],
                                  )));
                        } else {
                          showDialog(
                              context: context,
                              builder: ((context) => AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Sucedio un error en el registro'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    'login',
                                                    (Route<dynamic> route) =>
                                                        false);
                                          },
                                          child: const Text('Yes'))
                                    ],
                                  )));
                        }
                      },
                      child: const Text(
                        'Registrarse',
                      ),
                    ),
                    Container(
                      height: 100,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
