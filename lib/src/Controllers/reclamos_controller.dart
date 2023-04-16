// ignore_for_file: avoid_print
import 'dart:convert';
// import 'package:http/http.dart' show FormData;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:topicos_proy/src/models/perfil.dart';

class ReclamosService {
  final baseUrl = 'http://192.168.1.10/proy-topic/public/api';
  // final token = '38c466edd5f14894950fa82570c8da5d';
  ReclamosService();
  var dio = Dio();

  getEjemplo() async {
    final url = Uri.parse('$baseUrl/ejemplo');
    try {
      // final res = await http.get(url);
      await http.get(url).then((value) {
        print(value.body);
      });
      // final data = listarPersonasFromJson(res.body);
      // return data;
    } catch (e) {
      print(e);
      // return null;
    }
  }

  Future registrarUsuario(Map<String, dynamic> data) async {
    // print(data);
    final perfil = Perfil(
        ci: data['ci'].toString(),
        name: data['name'],
        telefono: data['telefono'].toString(),
        email: data['email'],
        uuid: data['uuid']);
    final url = Uri.parse('$baseUrl/user_register');
    try {
      // final res = await http.get(url);
      final res = await http.post(url,
          headers: {'Accept': 'application/json'}, body: perfil.toJson());
      final data = jsonDecode(res.body);
      return data;
    } catch (e) {
      print('Sucedio algun error');
      print(e);
    }
  }

  Future registrarReclamo(Map<String, dynamic> reclamo) async {
    // print(data);
    final url = Uri.parse('$baseUrl/registrar_reclamo');
    try {
      // final res = await http.get(url);
      final res = await http.post(url,
          headers: {'Accept': 'application/json'}, body: reclamo);
      final data = jsonDecode(res.body);
      return data;
    } catch (e) {
      print('Sucedio algun error');
      print(e);
    }
  }

  Future uploadPhotos(Map<String, dynamic> dataPhoto) async {
    // print(data);
    final url = Uri.parse('$baseUrl/uploadPhoto');
    try {
      // final res = await http.get(url);
      final res = await http.post(url,
          headers: {'Accept': 'application/json'}, body: dataPhoto);
      final data = jsonDecode(res.body);
      return data;
    } catch (e) {
      print('Sucedio algun error');
      print(e);
    }
  }

  Future uploadAvatar(String imagePath) async {
    try {
      FormData datitos = FormData.fromMap({
        "reclamo_id": '1',
        "image": await MultipartFile.fromFile(imagePath)
      });
      final resp = await dio.post(
          'http://192.168.1.10/proy-topic/public/api/uploadAvatar',
          options: Options(headers: {
            "Content-Type":
                "multipart/form-data; boundary=<calculated when request is sent>"
          }),
          data: datitos);
      return resp.data;
    } catch (e) {
      print('Sucedio algun error');
      print(e);
    }
  }

  //SUBIR FOTOS MASIVO
  Future subirFotos(List listImagePath) async {
    List<MultipartFile> lista = [];

    for (var i = 0; i < listImagePath.length; i++) {
      print(listImagePath.elementAt(i));
      MultipartFile multipartFile =
          await MultipartFile.fromFile(listImagePath.elementAt(i));
      lista.add(multipartFile);
    }

    try {
      FormData datitos = FormData.fromMap({
        "reclamo_id": '1',
        'images': lista.map((e) => MapEntry('images[]', e))
      });
      // datitos.add("image", lista);
      final resp = await dio.post(
          'http://192.168.1.10/proy-topic/public/api/uploadPhoto',
          options: Options(headers: {
            "Content-Type":
                "multipart/form-data; boundary=<calculated when request is sent>"
          }),
          data: datitos);
      print(resp.data);
      // return resp.data;
    } catch (e) {
      print('Sucedio algun error');
      print(e);
    }
  }
}
