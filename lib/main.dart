import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:topicos_proy/firebase_options.dart';
import 'package:topicos_proy/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(const MyApp());
}
