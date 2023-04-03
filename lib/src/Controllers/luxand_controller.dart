// ignore_for_file: avoid_print
import 'package:topicos_proy/src/models/datarecognition.dart';
import 'package:topicos_proy/src/models/profile.dart';

import '../models/listapersona.dart';
import 'package:http/http.dart' as http;

class LuxandService {
  final baseUrl = 'https://api.luxand.cloud';
  final token = '38c466edd5f14894950fa82570c8da5d';
  LuxandService();

  Future listarPersonas() async {
    final url = Uri.parse('$baseUrl/v2/person');
    try {
      final res = await http.get(url, headers: {'token': token});
      final data = listarPersonasFromJson(res.body);
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future reconocerCara(String image64) async {
    final url = Uri.parse('$baseUrl/photo/search/v2');
    try {
      final res = await http
          .post(url, headers: {'token': token}, body: {'photo': image64});
      final data = dataRecognitionFromJson(res.body);
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getProfile(uuid) async {
    final url = Uri.parse('$baseUrl/v2/person/$uuid');
    try {
      final res = await http.get(url, headers: {'token': token});
      final data = profileFromJson(res.body);
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
