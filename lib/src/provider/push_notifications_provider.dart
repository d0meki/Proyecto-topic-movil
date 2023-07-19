
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final List<String> items = [];
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensaje => _mensajesStreamController.stream;
  initNotification()async{
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _firebaseMessaging.getToken().then((token) => {
          //dt4Bvc-QQGSODXWYp2hUaV:APA91bH4pW9NJhwTgEHYvVZwmg8jc3iKYk8mXVLVcvMNmBPCklavnNe2lf-hUAz7c4asUSs_hAAmKZQIYF2ZbfICkBl3mSIeCAMTUvJpLF4s8fdFMx6nrCCJ5DoO26REhdDZXUuN6-qc
         // print(token),
          items.add(token!),
          print('token telefono desde el PROVIDER'),
          print(items[0]),
           sharedPreferences.setStringList("acces_token", items)
        });

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      print('¡Recibí un mensaje mientras estaba en primer plano!');
      //  print('category: ${message.category}');
      //  print('collapseKey: ${message.collapseKey}');
      //  print('contentAvailable: ${message.contentAvailable}');
      //  print('from: ${message.from}');
      //  print('messageId: ${message.messageId}');
      //  print('messageType: ${message.messageType}');
      //  print('mutableContent: ${message.mutableContent}');
      //  print('senderId: ${message.senderId}');
      //  print('sentTime: ${message.sentTime}');
      //  print('threadId: ${message.threadId}');
      //  print('ttl: ${message.ttl}');

      String? argumento = 'no-data';

      if (message.notification != null) {
        argumento = message.notification!.body;
        _mensajesStreamController.sink.add(argumento!);
        print('El mensaje también contenía una notificación: ${message.notification!.title}');
        print('El mensaje también contenía una notificación: ${message.notification!.body}');
      }
      print('Data del mensaje: ${message.data}');
    });
  }
  dispose(){
    _mensajesStreamController.close();
  }

}
