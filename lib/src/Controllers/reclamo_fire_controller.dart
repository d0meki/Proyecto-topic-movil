import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseReclamo {
  FirebaseReclamo();
  final CollectionReference _reclamos =
      FirebaseFirestore.instance.collection('reclamos');
  final storage = FirebaseStorage.instance;
  List<String> listaUrl = [];
  CollectionReference get reclamos => _reclamos;

  Future<List<dynamic>> getReclamos() async {
    QuerySnapshot<Object?> documentSnapshot = await _reclamos.get();
    // documentSnapshot.docs;
    return documentSnapshot.docs;
  }

  Future<List<dynamic>> getReclamoCategoria(String categoria) async {
    // List reclamoFiltrado = [];
    QuerySnapshot<dynamic> documentSnapshot =
        await _reclamos.where('categoria', isEqualTo: categoria).get();
    // for (var element in documentSnapshot.docs) {
    //   reclamoFiltrado.add(element.data());
    // }
    // print(documentSnapshot.docs[0].data());
    return documentSnapshot.docs;
  }

  Future<List<dynamic>> getReclamoEstado(String estado) async {
    QuerySnapshot<dynamic> documentSnapshot =
        await _reclamos.where('estado', isEqualTo: estado).get();
    return documentSnapshot.docs;
  }

  Future<bool> addReclamo(Map<String, dynamic> data) async {
    return await _reclamos
        .add(data)
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<List<dynamic>> getReclamoFecha(
      Timestamp timestampStart, Timestamp timestampEnd) async {
    QuerySnapshot<dynamic> documentSnapshot = await _reclamos
        .where('fecha', isGreaterThanOrEqualTo: timestampStart)
        .where('fecha', isLessThanOrEqualTo: timestampEnd)
        .get();
    return documentSnapshot.docs;
  }

  Future<dynamic> getReclamo(documentId) async {
    DocumentSnapshot documentSnapshot = await _reclamos.doc(documentId).get();
    return documentSnapshot.data();
  }

  Future<List<String>> uploadReclamoStorage(
      List<Map<String, dynamic>> dataStorage) async {
    // ignore: avoid_function_literals_in_foreach_calls
    dataStorage.forEach((element) async {
      final Reference ref = storage.ref('reclamos').child(element['name']);
      final UploadTask uploadTask = ref.putFile(element['foto']);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
      final String url = await snapshot.ref.getDownloadURL();
      listaUrl.add(url);
    });
    return listaUrl;
  }

  Future<String> uploadDenunciaStorage(File reclamo, String fileName) async {
    try {
      final Reference ref = storage.ref('reclamos').child(fileName);
      final UploadTask uploadTask = ref.putFile(reclamo);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
      final String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return "";
    }
  }
}
