import 'dart:convert';

List<ListarPersonas> listarPersonasFromJson(String str) =>
    List<ListarPersonas>.from(
        json.decode(str).map((x) => ListarPersonas.fromJson(x)));

String listarPersonasToJson(List<ListarPersonas> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListarPersonas {
  ListarPersonas({
    required this.uuid,
    required this.name,
    required this.faces,
    required this.collections,
  });

  String uuid;
  String name;
  List<Face> faces;
  List<Collection> collections;

  factory ListarPersonas.fromJson(Map<String, dynamic> json) => ListarPersonas(
        uuid: json["uuid"],
        name: json["name"],
        faces: List<Face>.from(json["faces"].map((x) => Face.fromJson(x))),
        collections: List<Collection>.from(
            json["collections"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "faces": List<dynamic>.from(faces.map((x) => x.toJson())),
        "collections": List<dynamic>.from(collections.map((x) => x.toJson())),
      };
}

class Collection {
  Collection({
    required this.name,
    required this.uuid,
  });

  String name;
  String uuid;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        name: json["name"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "uuid": uuid,
      };
}

class Face {
  Face({
    required this.url,
    required this.uuid,
  });

  String url;
  String uuid;

  factory Face.fromJson(Map<String, dynamic> json) => Face(
        url: json["url"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "uuid": uuid,
      };
}
