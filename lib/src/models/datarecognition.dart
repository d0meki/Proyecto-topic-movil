import 'dart:convert';

List<DataRecognition> dataRecognitionFromJson(String str) =>
    List<DataRecognition>.from(
        json.decode(str).map((x) => DataRecognition.fromJson(x)));

String dataRecognitionToJson(List<DataRecognition> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataRecognition {
  DataRecognition({
    required this.name,
    required this.probability,
    required this.rectangle,
    required this.uuid,
    required this.collections,
  });

  String name;
  double probability;
  Rectangle rectangle;
  String uuid;
  List<Collection> collections;

  factory DataRecognition.fromJson(Map<String, dynamic> json) =>
      DataRecognition(
        name: json["name"],
        probability: json["probability"]?.toDouble(),
        rectangle: Rectangle.fromJson(json["rectangle"]),
        uuid: json["uuid"],
        collections: List<Collection>.from(
            json["collections"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "probability": probability,
        "rectangle": rectangle.toJson(),
        "uuid": uuid,
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

class Rectangle {
  Rectangle({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  int left;
  int top;
  int right;
  int bottom;

  factory Rectangle.fromJson(Map<String, dynamic> json) => Rectangle(
        left: json["left"],
        top: json["top"],
        right: json["right"],
        bottom: json["bottom"],
      );

  Map<String, dynamic> toJson() => {
        "left": left,
        "top": top,
        "right": right,
        "bottom": bottom,
      };
}
