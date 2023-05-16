// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:topicos_proy/src/Controllers/usuario_controller.dart';
import 'package:topicos_proy/src/widget/textform.dart';
import 'package:topicos_proy/src/widget/widgets.dart';
class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool logeado = false;
  final TextEditingController _mailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    if (_verificarLogeado()) {
      setState(() {
        logeado = true;
      });
    }
  }
  bool _verificarLogeado() {
    return authService.logeado();
  }
  @override
  Widget build(BuildContext context) {
    newPassword() async {
      final formUnicKey = GlobalKey<FormState>();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('New Password'),
              content: Form(
                key: formUnicKey,
                child: CustomTextFormField(
                    _newPasswordController,
                    const Icon(Icons.lock),
                    "New Password",
                    TextInputType.visiblePassword,
                    hideText: true, validateTextFormField: (String value) {
                  if (value.isEmpty) {
                    return "Escriba su nueva password por favor";
                  }
                  return null;
                }),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formUnicKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                                child: CircularProgressIndicator());
                          });
                      Map<String, dynamic> changed = await authService
                          .changePassword(_newPasswordController.text);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Widgets.alertSnackbar(context, changed['msg']);
                    }
                  },
                  child: const Text('Cambiar'),
                ),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed:
                  logeado ? () => Navigator.pushNamed(context, 'home') : null,
              icon: const Icon(Icons.home))
        ],
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0XFF3C3E52),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/img/facial.png',
                      width: 120.0,
                    ),
                    const Text(
                      "Face Recognition ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      child: const Text(
                        "Authenticate using your email and password",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, height: 1.5),
                      ),
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: TextFormField(
                                  controller: _mailController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      iconColor: Colors.white,
                                      labelStyle: TextStyle(color: Colors.white),
                                      icon: Icon(Icons.mail),
                                      labelText: "Correo"),
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: false,
                                  readOnly: false,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Escriba su correo por favor";
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: TextFormField(
                                  controller: _passwordController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      iconColor: Colors.white,
                                      labelStyle: TextStyle(color: Colors.white),
                                      icon: Icon(Icons.password),
                                      labelText: "Password"),
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  readOnly: false,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Escriba su password por favor";
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 15.0),
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const Center(
                                              child: CircularProgressIndicator());
                                        });
                                    final respuesta = await authService.login(
                                        _mailController.text,
                                        _passwordController.text);
                                    Navigator.pop(context);
                                    if (respuesta['status']) {
                                      Widgets.alertSnackbar(
                                          context, "Logeado ${respuesta['msg']}");
                                      Navigator.pushNamed(context, 'home');
                                    } else {
                                      Widgets.alertSnackbar(
                                          context, respuesta['msg']);
                                      if (respuesta['reason'] ==
                                          'changePassword') {
                                        newPassword();
                                      }
                                    }
                                  } else {
                                    Widgets.alertSnackbar(
                                        context, 'Formulario incompleto');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF04A5ED),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 24.0),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pushNamed(context, "register");
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF04A5ED),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 24.0),
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
