import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUsuario {
  FirebaseUsuario();

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final storage = FirebaseStorage.instance;

  CollectionReference get users => _users;

  // List _allDatasChofer = [];
  // List get allDtasChofer => _allDatasChofer;

  // Recorridos
  // Future<void> addRecorrido(Map<String, dynamic> data) async {
  //   await _recorridos.add(data);
  // }
  // Cordenadas

  // Future<void> addUbicacion(Map<String, dynamic> data, id) async {
  //   await _ubicaciones.doc(id).set(data);
  // }

  // Future<dynamic> getUbicacion(id) async {
  //   DocumentSnapshot documentSnapshot = await _ubicaciones.doc(id).get();
  //   return documentSnapshot.data();
  // }
  //chofer
  // Future<dynamic> getChofer() async {
  //   String uid = await SharedPreferencesService.getSharedString("acces_token");
  //   DocumentSnapshot documentSnapshot = await chofer.doc(uid).get();
  //   return documentSnapshot.data();
  // }
  Future<dynamic> getUser() async {
    const String uid = "zhFiV0xrj5OAx3jbNy3e";
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();
    return documentSnapshot.data();
  }

  Future<dynamic> login(pin) async {
    String email = 'marioabc@gmail.com';
    Map<String, dynamic> respuesta;
    QuerySnapshot<dynamic> documentSnapshotValidarEmail =
        await _users.where('email', isEqualTo: email).get();
    Map<String, dynamic> userEmail =
        documentSnapshotValidarEmail.docs[0].data();
    if (documentSnapshotValidarEmail.size == 0) {
      print('Correo no existe');
    } else {
      if (userEmail['bloqueado']) {
        print(userEmail['timer'].toDate());
        if (userEmail['timer'].seconds <= Timestamp.now().seconds) {
          // print(userEmail['timer'].toDate());
          // print('desbloquear');
          Map<String, dynamic> desbloquear = {
            'bloqueado': false,
            'intentos': 0
          };
          await users
              .doc(documentSnapshotValidarEmail.docs[0].id)
              .update(desbloquear);
              DocumentSnapshot documentSnapshot = await users.doc(documentSnapshotValidarEmail.docs[0].id).get();
             userEmail = documentSnapshot.data() as Map<String, dynamic>;
        }
      }

      if (!userEmail['bloqueado']) {
        QuerySnapshot<dynamic> documentSnapshotPin =
            await _users.where('pin', isEqualTo: pin).get();
        if (documentSnapshotPin.size == 0) {
          if (userEmail['intentos'] != 2) {
            int increment = userEmail['intentos'] + 1;
            Map<String, dynamic> data = {'intentos': increment};
            await users
                .doc(documentSnapshotValidarEmail.docs[0].id)
                .update(data);
            respuesta = {'status': false, 'intentos': increment};
            return respuesta;
          } else {
            DateTime date = DateTime.now();
            date = date.add(const Duration(minutes: 1));
            Map<String, dynamic> timer = {
              'bloqueado': true,
              'timer': Timestamp.fromDate(date)
            };
            await users
                .doc(documentSnapshotValidarEmail.docs[0].id)
                .update(timer);
            respuesta = {
              'status': false,
              'intentos': userEmail['intentos'] + 1,
              'bloqueado': true,
              'seconds': 60
            };
            return respuesta;
          }
        } else {
          print('logeado con exito');
          respuesta = {"status": true};
          return respuesta;
        }
      } else {
        print('Este usuario ya esta bloqueado por tiempo limitado');
        int diferencia = userEmail['timer'].seconds - Timestamp.now().seconds;
        respuesta = {
          'status': false,
          'intentos': userEmail['intentos'] + 1,
          'bloqueado': true,
          'seconds': diferencia
        };
        return respuesta;
      }
      // print(documentSnapshotPin.docs[0].data());
    }
  }

  Future<dynamic> getUserWhitPin(pin) async {
    QuerySnapshot<dynamic> documentSnapshot =
        await _users.where('pin', isEqualTo: pin).get();

    Map<String, dynamic> usuariofind = documentSnapshot.docs[0].data();
    //  DateTime date = DateTime.now(); // 11 de mayo de 2023 a las 3:30 PM

    Timestamp timestampFin = usuariofind['timer']['timestamp'];
    DateTime dateFin = timestampFin.toDate();
    print('Antes $dateFin');
    dateFin = dateFin.add(Duration(seconds: usuariofind['timer']['seconds']));
    timestampFin = Timestamp.fromDate(dateFin);
    print("despues de añadir los segunods $dateFin");

    print('BD: ${timestampFin.seconds} now: ${Timestamp.now().seconds}');
    print('BD: ${timestampFin.toDate()} now: ${Timestamp.now().toDate()}');

    if (timestampFin.seconds < Timestamp.now().seconds) {
      print('desbloqueado');
    } else {
      print('Sigue bloqueado');
    }
    print(usuariofind['ci']);
    // UsuarioFind usuarioFind = documentSnapshot.docs[0].data();
    // print(usuarioFind.ci);
    print(documentSnapshot.docs[0].data());

    // return documentSnapshot.docs[0];
  }

  Future<dynamic> getUserWhitUuid(uuid) async {
    QuerySnapshot<Object?> documentSnapshot =
        await users.where('uuid', isEqualTo: uuid).get();
    return documentSnapshot.docs[0];
  }

  // Future<void> addChofer(Map<String, dynamic> data, String uid) async {
  //   print("DATA FIRESTORE ${data}");
  //   await _users.doc(uid).set(data);
  // }

  Future<bool> addUser(Map<String, dynamic> data) async {
    return await _users
        .add(data)
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<String> uploadAvatartorage(File avatar, String fileName) async {
    try {
      final Reference ref = storage.ref('avatares').child(fileName);
      final UploadTask uploadTask = ref.putFile(avatar);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
      final String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return "";
    }
    // print(element);
    // Files.upLoadImage(
    //     element["path_img"], element["name_img"], element["file"]);
  }

  // Future<void> getDataChofer({DocumentSnapshot? documentSnapshot}) async {
  //   // print(await _chofer.doc(documentSnapshot!.id).get());
  //   _chofer.get().then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       print("DATA: ${doc.data()}");
  //       // _allDatasChofer.add(doc.data());
  //     });
  //   });
  // }

  // uploadDataFirestore(Map<String, dynamic> dataFirestore, String uid) {
  //   addChofer(dataFirestore, uid);
  // }

  // uploadDataStorage(List<Map<String, dynamic>> dataStorage) {
  //   dataStorage.forEach((element) {
  //     // print(element);
  //     Files.upLoadImage(
  //         element["path_img"], element["name_img"], element["file"]);
  //   });
  // }
}
