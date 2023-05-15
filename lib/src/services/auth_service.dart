import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthServices {
  final baseUrl = 'http://34.176.0.165:3000/api';
  var dio = Dio();
  AuthServices();
  Future<dynamic> login(email, password) async {
    final url = Uri.parse('$baseUrl/auth/login-user');
    try {
      final res = await http.post(url,
          headers: {'Accept': 'application/json'}, body: {email, password});
      final data = jsonDecode(res.body);
      return data;
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> registrarUsuario(
      Map<String, dynamic> usuario, imagenPath, fileName) async {
    final url = Uri.parse('$baseUrl/auth/register-user');
    try {
      final res = await http.post(url,
          headers: {'Accept': 'application/json'},
          body: {usuario, imagenPath, fileName});
      final data = jsonDecode(res.body);
      return data;
    } catch (e) {
      return e;
    }
  }
  Future<dynamic> verificarCi(String ci) async {
    final url = Uri.parse('$baseUrl/auth/verificar-ci');
    try {
      final res = await http
          .post(url, headers: {'Accept': 'application/json'}, body: {"ci": ci});
      final data = jsonDecode(res.body);
      return data;
    } catch (e) {
      return e;
    }
  }
  Future<bool> verificarFoto(String image64, String uuid) async {
    final url = Uri.parse('$baseUrl/auth/verificar-foto');
    try {
      final res = await http.post(url,
          headers: {'Accept': 'application/json'}, body: {image64, uuid});
      final data = jsonDecode(res.body);
      return data;
    } catch (e) {
      return false;
    }
  }
  Future<dynamic> changePassword(String newPassword) async {}
  Future<bool> signOut(user) async {
    final url = Uri.parse('$baseUrl/auth/logout');
    try {
      final res = await http.post(url,
          headers: {'Accept': 'application/json'}, body: {user});
      final data = jsonDecode(res.body);
      return data;
    } catch (e) {
      return false;
    }
  }
}
