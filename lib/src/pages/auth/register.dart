// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:topicos_proy/src/Controllers/usuario_controller.dart';
import 'package:topicos_proy/src/models/datarecognition.dart';
import 'package:topicos_proy/src/util/validaciones.dart';
import 'package:topicos_proy/src/widget/textform.dart';
import 'package:topicos_proy/src/widget/widgets.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var firebaseUsuario = FirebaseUsuario();
  final _formKey = GlobalKey<FormState>();
  late List<DataRecognition> respuesta;
  late String uuid = '';
  late String imagePath = '';
  late String fileName = '';
  final picker = ImagePicker();
  TextEditingController? _nameController;
  TextEditingController? _ciController;
  TextEditingController? _phoneController;
  TextEditingController? _mailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ciController = TextEditingController();
    _phoneController = TextEditingController();
    _mailController = TextEditingController();
    _pedirCi();
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
                          children: const [
                            SizedBox(
                                width: 150,
                                height: 150,
                                child: Icon(Icons.add_a_photo)),
                            Text('Foto de perfil no seleccionado')
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
              child: FormularioRegister(
                formKey: _formKey,
                nameController: _nameController,
                ciController: _ciController,
                phoneController: _phoneController,
                mailController: _mailController,
                filename: fileName,
                imagePath: imagePath,
              ),
            )
          ],
        ),
      ),
    );
  }

  choceImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        fileName = pickedFile.path.split('/').last;
      });
      List<int> bytes = File(pickedFile.path).readAsBytesSync();
      String imagen64 = base64.encode(bytes);
      _cargar();
      final validateFoto = await firebaseUsuario.verificarFoto(imagen64, uuid);
      Navigator.pop(context);
      if (!validateFoto) {
        setState(() {
          fileName = '';
        });
        showDialog(
            context: context, builder: ((context) => const UnregisterUser()));
      } else {
        setState(() {
          imagePath = pickedFile.path;
        });
      }
    }
  }

  Future<dynamic> _cargar() {
    return showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
  }

  choceImageCamare() async {
    //TODO: Realizar configuraciones necesarias
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      List<int> bytes = File(pickedFile.path).readAsBytesSync();
      String imagen64 = base64.encode(bytes);
      _cargar();
      await firebaseUsuario.verificarFoto(imagen64, uuid);
      // respuesta = await luxandService.reconocerCara(_imagen64);
      Navigator.pop(context);
      if (respuesta.isEmpty) {
        showDialog(
            context: context, builder: ((context) => const UnregisterUser()));
      }
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  _pedirCi() async {
    await Future.delayed(const Duration(milliseconds: 50));
     showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('CI'),
            content: CustomTextFormField(
                _ciController!,
                const Icon(Icons.account_box),
                "Carnet de Identidad",
                TextInputType.phone, validateTextFormField: (String value) {
              if (value.isEmpty) return "Escriba su CI por favor";
              if (!Validation.soloNumeros(_ciController!.text)) {
                return "Solo se permite números";
              }
              return null;
            }),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, 'login'),
                child: const Text('Cacnelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  _cargar();
                  Map<String, dynamic> respuesta =
                      await firebaseUsuario.verificarCi(_ciController!.text);
                  Navigator.pop(context);
                  if (respuesta['match']) {
                    Navigator.pop(context);
                    Widgets.alertSnackbar(context, respuesta['msg']);
                    _nameController!.text = respuesta['name'];
                    setState(() {
                      uuid = respuesta['uuid'];
                    });
                  } else {
                    Widgets.alertSnackbar(context, respuesta['msg']);
                    Navigator.pushNamed(context, 'login');
                  }
                },
                child: const Text('Verificar'),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _ciController?.dispose();
    _phoneController?.dispose();
    _mailController?.dispose();
    super.dispose();
  }
}

class UnregisterUser extends StatelessWidget {
  const UnregisterUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warnning'),
      content: const Text('Foto no corresponde al Usuario'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Yes'))
      ],
    );
  }
}

class FormularioRegister extends StatelessWidget {
  const FormularioRegister({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController? nameController,
    required TextEditingController? ciController,
    required TextEditingController? phoneController,
    required TextEditingController? mailController,
    required this.imagePath,
    required this.filename,
  })  : _formKey = formKey,
        _nameController = nameController,
        _ciController = ciController,
        _phoneController = phoneController,
        _mailController = mailController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController? _nameController;
  final TextEditingController? _ciController;
  final TextEditingController? _phoneController;
  final TextEditingController? _mailController;
  final String imagePath;
  final String filename;

  @override
  Widget build(BuildContext context) {
    var firebaseUsuario = FirebaseUsuario();
    return Form(
      key: _formKey,
      child: Padding(
        padding:
            const EdgeInsets.only(right: 50, left: 50, bottom: 10, top: 20),
        child: Column(
          children: [
            CustomTextFormField(
                _nameController!,
                const Icon(Icons.assignment_outlined),
                "Nombre y apellido",
                TextInputType.text,
                readOnly: true, validateTextFormField: (String value) {
              if (value.isEmpty) return "Escriba su nombre por favor";
              return null;
            }),
            CustomTextFormField(_ciController!, const Icon(Icons.account_box),
                "Carnet de Identidad", TextInputType.phone, readOnly: true,
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
                TextInputType.phone, validateTextFormField: (String value) {
              if (value.isEmpty) return "Escriba su télefono por favor";
              if (!Validation.soloNumeros(_phoneController!.text)) {
                return "Solo se permite números";
              }
              return null;
            }),
            CustomTextFormField(_mailController!, const Icon(Icons.mail),
                "Correo", TextInputType.emailAddress,
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
                };
                if (_formKey.currentState!.validate() && imagePath != '') {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      });
                  Map<String, dynamic> res = await firebaseUsuario
                      .registrarUsuario(data, imagePath, filename);
                  Navigator.pop(context);
                  if (res['status']) {
                    Widgets.alertSnackbar(
                        context, '${res['msg']} ${res['verifyEmail']}');
                    Navigator.pushNamed(context, 'login');
                  } else {
                    Widgets.alertSnackbar(context, res['msg']);
                  }
                } else {
                  Widgets.alertSnackbar(context, 'Formulario Incompleto');
                }
              },
              child: const Text(
                'Registrarse',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
