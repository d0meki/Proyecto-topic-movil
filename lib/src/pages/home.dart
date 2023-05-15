// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:topicos_proy/src/Controllers/usuario_controller.dart';

class HomePage extends StatelessWidget {
  AuthService authService = AuthService();
  HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Home'),
          leading: IconButton(
            icon: const Icon(Icons.logout_sharp),
            tooltip: "LogOut",
            onPressed: ()async {
              final res = await authService.signOut();
              if (res) {
                 Navigator.of(context).pushNamedAndRemoveUntil(
                  'login', (Route<dynamic> route) => false);
              }
            },
          )),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Text("Welcome to home")],
        ),
      ),
    );
  }
}
