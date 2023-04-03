import 'package:flutter/material.dart';
import 'package:topicos_proy/src/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      initialRoute: Routes.initialRoute,
      routes: Routes.routes,
    );
  }
}
