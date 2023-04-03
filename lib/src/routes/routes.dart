import 'package:topicos_proy/src/pages/auth/camara.dart';
import 'package:topicos_proy/src/pages/auth/login.dart';
import 'package:topicos_proy/src/pages/home.dart';
import 'package:flutter/material.dart';

class Routes {
  static const initialRoute = 'login';
  static final Map<String, Widget Function(BuildContext)> routes = {
    'home': (BuildContext context) => const HomePage(),
    'login': (BuildContext context) => const Login(),
    'camara': (BuildContext context) => const CamaraApp(),
  };
  static final routesName = {
    'home': 'home',
    'login': 'login',
    'camara': 'camara',
  };
}
