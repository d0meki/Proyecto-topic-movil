
import 'package:flutter/material.dart';
import 'package:topicos_proy/src/Controllers/usuario_controller.dart';
import 'package:topicos_proy/src/widget/widgets.dart';
class ChangePassword extends StatelessWidget {
    final TextEditingController _mailController = TextEditingController();
  final TextEditingController _lastPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
   ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0XFF3C3E52),
      body: Padding(padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),child: Column(children: [
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
                                controller: _lastPasswordController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    iconColor: Colors.white,
                                    labelStyle: TextStyle(color: Colors.white),
                                    icon: Icon(Icons.password),
                                    labelText: "Last Password"),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                readOnly: false,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Escriba su password actual por favor";
                                  }
                                  return null;
                                }),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: TextFormField(
                                controller: _newPasswordController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    iconColor: Colors.white,
                                    labelStyle: TextStyle(color: Colors.white),
                                    icon: Icon(Icons.password),
                                    labelText: "New Password"),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                readOnly: false,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Escriba su nuevo password por favor";
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
                                  "Change Password",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )
      ],),),
    );
  }
}