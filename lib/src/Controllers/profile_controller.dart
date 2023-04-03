// import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:topicos_proy/src/models/profile.dart';

// void main(List<String> arguments) async {
void getProfile(List<String> arguments) {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  final url = Uri.https('localhost:8080/api/chatgpt/get-algo');

  // Await the http get response, then decode the json-formatted response.

  http.get(url).then((res) => {print(profileFromJson(res.body))});
  // var response = await http.get(url);
  // if (response.statusCode == 200) {
  //   var jsonResponse =
  //       convert.jsonDecode(response.body) as Map<String, dynamic>;
  //   var itemCount = jsonResponse['totalItems'];
  //   // print('Number of books about http: $itemCount.');
  // } else {
  //   // print('Request failed with status: ${response.statusCode}.');
  // }
}
