import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceReclamo {
  final CollectionReference _reclamos =
      FirebaseFirestore.instance.collection('reclamos');
  final CollectionReference categorias =
      FirebaseFirestore.instance.collection('categorias');
  final CollectionReference estados =
      FirebaseFirestore.instance.collection('estados');

  final storage = FirebaseStorage.instance;
  var dio = Dio();
  CollectionReference get reclamos => _reclamos;

  ServiceReclamo();
  Future<List<dynamic>> getReclamos() async {
    QuerySnapshot<Object?> documentSnapshot =
        await _reclamos.orderBy('fecha', descending: true).get();
    return documentSnapshot.docs;
  }

  Future<List<dynamic>> getcats() async {
    QuerySnapshot<Object?> documentSnapshot = await categorias.get();
    return documentSnapshot.docs;
  }

  Future<List<dynamic>> getEstados() async {
    QuerySnapshot<Object?> documentSnapshot = await estados.get();
    return documentSnapshot.docs;
  }

  Future<List<dynamic>> getReclamoCategoria(String categoria) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final List<String> items = sharedPreferences.getStringList('acces_token')!;
    final uid = items[1];
    QuerySnapshot<dynamic> documentSnapshot = await _reclamos
        .where('categoria', isEqualTo: categoria)
        .where('uuid', isEqualTo: uid)
        .get();
    return documentSnapshot.docs;
  }

  Future<List<dynamic>> getReclamoEstado(String estado) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final List<String> items = sharedPreferences.getStringList('acces_token')!;
    final uid = items[1];
    QuerySnapshot<dynamic> documentSnapshot = await _reclamos
        .where('estado', isEqualTo: estado)
        .where('uuid', isEqualTo: uid)
        .get();
    return documentSnapshot.docs;
  }

  Future<List<dynamic>> getReclamoFecha(
      Timestamp timestampStart, Timestamp timestampEnd) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final List<String> items = sharedPreferences.getStringList('acces_token')!;
    final uid = items[1];
    QuerySnapshot<dynamic> documentSnapshot = await _reclamos
        .where('fecha', isGreaterThanOrEqualTo: timestampStart)
        .where('fecha', isLessThanOrEqualTo: timestampEnd)
        .where('uuid', isEqualTo: uid)
        .get();
    return documentSnapshot.docs;
  }

  Future<bool> addReclamo(Map<String, dynamic> data) async {
    return await _reclamos
        .add(data)
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<dynamic> getReclamo(String documentId) async {
    DocumentSnapshot documentSnapshot = await _reclamos.doc(documentId).get();
    return documentSnapshot.data();
  }

  Future<List<dynamic>> getReclamosPorUsuarios() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final List<String> items = sharedPreferences.getStringList('acces_token')!;
    final uid = items[1];
    QuerySnapshot<dynamic> documentSnapshot = await _reclamos
        .where('uuid', isEqualTo: uid)
        .orderBy('fecha', descending: true)
        .get();
    return documentSnapshot.docs;
  }

  Future<void> eliminarReclamo(String documentoId) async {
    _reclamos.doc(documentoId).delete().then((value) {
      print('Documento eliminado correctamente.');
    }).catchError((error) {
      print('Error al eliminar el documento: $error');
    });
  }

  Future<void> verificarTextoOfensivo(String texto) async {
    String baseUrl = 'https://proy-topic.fly.dev/api';
    String textoCompleto =
        'respóndeme con falso o verdadero si este texto contiene alguna palabra ofensiva:';
    textoCompleto = textoCompleto + texto;
    final url = Uri.parse('$baseUrl/chatgpt/turbo');
    Map<String, dynamic> pregunta = {"pregunta": textoCompleto};
    try {
      final res = await http.post(url,
          headers: {'Accept': 'application/json'}, body: pregunta);
      final data = jsonDecode(res.body);
      print(data);
      // return data;
    } catch (e) {
      print('Sucedio algun error');
      print(e);
    }
    //  return 'hola mundo';
  }

  Future<String> verificarTextoOfensivoDos(String texto) async {
    String textoCompleto =
        'respóndeme con solomente FALSO o VERDADERO si este texto contiene alguna palabra ofensiva:';
    textoCompleto = textoCompleto + texto;
    try {
      final resp = await dio.post(
          'https://proy-topic.fly.dev/api/chatgpt/turbo',
          data: {"pregunta": textoCompleto});
      final data = resp.data;
      print(data);
      return data['body']['choices'][0]['message']['content'];
    } catch (e) {
      print('Sucedio algun error');
      print(e);
      return "error";
    }
  }

  Future<String> verificarFotoQueCoinsida(
      String descripcion, String urlFoto) async {
    String textoCompleto =
        'respóndeme con solo falso o verdadero si este texto: ';
    // String descripcion = 'El alumbrado publico dejó de funcionar, por favor venir a reparar lo mas pronto posible, gracias. ';
    try {
      final reponseVision = await dio.post(
          'https://proy-topic.fly.dev/api/vision/reconocer',
          data: {"imageURL": urlFoto});
      final data = reponseVision.data;
      print(data['body'].toString());
      textoCompleto =
          '$textoCompleto $descripcion Tiene alguna relacion con estas palabras: ${data['body'].toString()}';
      final resp = await dio.post(
          'https://proy-topic.fly.dev/api/chatgpt/turbo',
          data: {"pregunta": textoCompleto});
      final datafinal = resp.data;
      print(datafinal);
      return datafinal['body']['choices'][0]['message']['content'];
    } catch (e) {
      print('Sucedio algun error');
      print(e);
      return "error";
    }
  }

  Future<bool> reclamoNoRepetidoElMismoDia(String categoria) async {
    bool existenDosReclamos = false;
    DateTime hoy = DateTime.now();
    DateTime start = DateTime(hoy.year, hoy.month, hoy.day);
    DateTime end = DateTime.now();
    QuerySnapshot<dynamic> documentSnapshot = await _reclamos
        .where('categoria', isEqualTo: categoria)
        .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('fecha', descending: true)
        .get();
    if (documentSnapshot.docs.length >= 2) {
      existenDosReclamos = true;
    }
    return existenDosReclamos;
  }

  Future<List<String>> getCategorias() async {
    List<String> nombres = [];
    CollectionReference personasRef =
        FirebaseFirestore.instance.collection('categorias');
    QuerySnapshot querySnapshot = await personasRef.get();
    querySnapshot.docs.forEach((doc) {
      nombres.add(doc['nombre']);
    });
    return nombres;
  }

  Future<void> pruebaDeConexion(String texto) async {
    String baseUrl = 'https://proy-topic.fly.dev/api';
    final url = Uri.parse('$baseUrl/vision/get-prueba');
    try {
      final res = await http.get(url, headers: {'Accept': 'application/json'});
      final data = jsonDecode(res.body);
      print(data);
      // return data;
    } catch (e) {
      print('Sucedio algun error');
      print(e);
    }
  }

  /* Future<List<String>> uploadReclamoStorage(
      List<Map<String, dynamic>> dataStorage) async {
    List<String> listaUrl = [];
    dataStorage.forEach((element) async {
      final Reference ref = storage.ref('reclamos').child(element['name']);
      final UploadTask uploadTask = ref.putFile(element['foto']);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
      final String url = await snapshot.ref.getDownloadURL();
      listaUrl.add(url);
    });
    return listaUrl;
  } */

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
