// To parse this JSON data, do
//
//     final usuarioFind = usuarioFindFromJson(jsonString);

import 'dart:convert';

UsuarioFind usuarioFindFromJson(String str) => UsuarioFind.fromJson(json.decode(str));

String usuarioFindToJson(UsuarioFind data) => json.encode(data.toJson());

class UsuarioFind {
    final String email;
    final String password;
    final String avatar;
    final String telefono;
    final String ci;
    final String name;
    final int intentos;
    final bool bloqueado;
    final int seconds;
    final String pin;
    final String uuid;
    final Timer timer;

    UsuarioFind({
        required this.email,
        required this.password,
        required this.avatar,
        required this.telefono,
        required this.ci,
        required this.name,
        required this.intentos,
        required this.bloqueado,
        required this.seconds,
        required this.pin,
        required this.uuid,
        required this.timer,
    });

    factory UsuarioFind.fromJson(Map<String, dynamic> json) => UsuarioFind(
        email: json["email"],
        password: json["password"],
        avatar: json["avatar"],
        telefono: json["telefono"],
        ci: json["ci"],
        name: json["name"],
        intentos: json["intentos"],
        bloqueado: json["bloqueado"],
        seconds: json["seconds"],
        pin: json["pin"],
        uuid: json["uuid"],
        timer: Timer.fromJson(json["timer"]),
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "avatar": avatar,
        "telefono": telefono,
        "ci": ci,
        "name": name,
        "intentos": intentos,
        "bloqueado": bloqueado,
        "seconds": seconds,
        "pin": pin,
        "uuid": uuid,
        "timer": timer.toJson(),
    };
}

class Timer {
    final Timestamp timestamp;
    final int minutos;

    Timer({
        required this.timestamp,
        required this.minutos,
    });

    factory Timer.fromJson(Map<String, dynamic> json) => Timer(
        timestamp: Timestamp.fromJson(json["timestamp"]),
        minutos: json["minutos"],
    );

    Map<String, dynamic> toJson() => {
        "timestamp": timestamp.toJson(),
        "minutos": minutos,
    };
}

class Timestamp {
    final int seconds;
    final int nanoseconds;

    Timestamp({
        required this.seconds,
        required this.nanoseconds,
    });

    factory Timestamp.fromJson(Map<String, dynamic> json) => Timestamp(
        seconds: json["_seconds"],
        nanoseconds: json["_nanoseconds"],
    );

    Map<String, dynamic> toJson() => {
        "_seconds": seconds,
        "_nanoseconds": nanoseconds,
    };
}
