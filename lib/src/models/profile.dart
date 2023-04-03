import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    required this.name,
    required this.uuid,
    required this.faces,
    required this.collections,
  });

  String name;
  String uuid;
  List<Face> faces;
  List<Collection> collections;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        name: json["name"],
        uuid: json["uuid"],
        faces: List<Face>.from(json["faces"].map((x) => Face.fromJson(x))),
        collections: List<Collection>.from(
            json["collections"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "uuid": uuid,
        "faces": List<dynamic>.from(faces.map((x) => x.toJson())),
        "collections": List<dynamic>.from(collections.map((x) => x.toJson())),
      };
}

class Collection {
  Collection({
    required this.uuid,
    required this.name,
  });

  String uuid;
  String name;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        uuid: json["uuid"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
      };
}

class Face {
  Face({
    required this.uuid,
    required this.url,
  });

  String uuid;
  String url;

  factory Face.fromJson(Map<String, dynamic> json) => Face(
        uuid: json["uuid"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "url": url,
      };
}
