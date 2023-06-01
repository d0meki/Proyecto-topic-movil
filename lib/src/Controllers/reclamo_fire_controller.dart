import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class FirebaseReclamo {
  FirebaseReclamo();
  final CollectionReference _reclamos =
      FirebaseFirestore.instance.collection('reclamos');
  final storage = FirebaseStorage.instance;

  CollectionReference get reclamos => _reclamos;

  Future<List<dynamic>> getReclamos() async {
    QuerySnapshot<Object?> documentSnapshot = await _reclamos.get();
    return documentSnapshot.docs;
  }

  Future<List<dynamic>> getReclamoCategoria(String categoria) async {
    QuerySnapshot<dynamic> documentSnapshot =
        await _reclamos.where('categoria', isEqualTo: categoria).get();
    return documentSnapshot.docs;
  }

  Future<List<dynamic>> getReclamoEstado(String estado) async {
    QuerySnapshot<dynamic> documentSnapshot =
        await _reclamos.where('estado', isEqualTo: estado).get();
    return documentSnapshot.docs;
  }

  Future<List<dynamic>> getReclamoFecha(
      Timestamp timestampStart, Timestamp timestampEnd) async {
    QuerySnapshot<dynamic> documentSnapshot = await _reclamos
        .where('fecha', isGreaterThanOrEqualTo: timestampStart)
        .where('fecha', isLessThanOrEqualTo: timestampEnd)
        .get();
    return documentSnapshot.docs;
  }

  Future<bool> addReclamo(Map<String, dynamic> data) async {
    return await _reclamos
        .add(data)
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<dynamic> getReclamo(documentId) async {
    DocumentSnapshot documentSnapshot = await _reclamos.doc(documentId).get();
    return documentSnapshot.data();
  }

  Future<String> verificarTextoOfensivo(String texto) async {
    const apiKey = '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';
    String textoCompleto =
        'respóndeme con falso o verdadero si este texto contiene alguna palabra ofensiva:';
    textoCompleto = textoCompleto + texto;
    String url = "https://api.openai.com/v1/chat/completions";
    Map<String, String> headers = {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
    };

    Map<String, dynamic> body = {
      'model': 'text-davinci-003',
      'prompt': textoCompleto,
      'temperature': 0,
      'max_token': 2000,
      'top_p': 1,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0
    };
    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));
    // Map<String, dynamic> newresponse =  jsonDecode(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String respuesta = jsonResponse['choices'][0]['message']['content'];
      print(respuesta);
      return respuesta;
    } else {
      throw Exception(
          ' ${response.statusCode} Error al obtener la respuesta de ChatGPT.');
    }
  }

  Future<List<String>> uploadReclamoStorage(
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
