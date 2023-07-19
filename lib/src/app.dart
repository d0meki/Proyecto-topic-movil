import 'package:flutter/material.dart';
import 'package:topicos_proy/src/provider/push_notifications_provider.dart';
import 'package:topicos_proy/src/routes/routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    final pushProvideder = PushNotificationProvider();
    pushProvideder.initNotification();
    pushProvideder.mensaje.listen((data) {
      /* print('Argumentos del push');
      print(data); */
      navigatorKey.currentState?.pushNamed('mensaje', arguments: data);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), //TODO: que se maneje en base a temas
      initialRoute: Routes.initialRoute,
      routes: Routes.routes,
    );
  }
}
