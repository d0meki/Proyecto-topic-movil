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

  Future<dynamic> getUserWhitPin(pin) async {
    QuerySnapshot<Object?> documentSnapshot =
        await users.where('pin', isEqualTo: pin).get();
    return documentSnapshot.docs[0];
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
