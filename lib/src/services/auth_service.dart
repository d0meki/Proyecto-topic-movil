import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class AuthService {
  final baseUrl = 'http://34.176.0.165:3000/api';
  var dio = Dio();

  AuthService();

  login() {
    //retornar user bloqueado
  }
  registrar() {
    //reotornar correo existente
  }

 Future verificarCi(String ci) async {
    final url = Uri.parse('$baseUrl/auth/verificar-ci');
    try {
      final res = await http.post(url,
          headers: {'Accept': 'application/json'}, body: {"ci":ci});
      final data = jsonDecode(res.body);
      print(data);
      // return data;
    } catch (e) {
      print('Sucedio algun error');
      print(e);
    }
  }

  verificarFotoSegip() {}
}
