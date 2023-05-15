import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:topicos_proy/src/models/datarecognition.dart';

class AuthService {
  //INI PROPIEDADES DEL AUTH
  final baseUrl = 'https://api.luxand.cloud';
  final token = 'd3b1e27cd4c544b19e48a65125ca0112';
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final storage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference get users => _users;
//FIN PROPIEDADES DEL AUTH
  AuthService();

//FIN METODOS AUTH
  Future<dynamic> login(email, password) async {
    Map<String, dynamic> respuesta;
    try {
      //INI VALIDACION EMAIL VERIFICADO
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        respuesta = {
          "status": false,
          "reason": "verifyEmail",
          "msg": "Email no verificado revise su correo"
        };
        return respuesta;
        //FIN VALIDACION EMAIL VERIFICADO
      }
      //INI VALIDACION SI CAMBIÓ SU PASSWORD
      QuerySnapshot<dynamic> documentSnapshot =
          await _users.where('authUid', isEqualTo: user!.uid).get();
      Map<String, dynamic> dataUsuario = documentSnapshot.docs[0].data();
      if (!dataUsuario['changePassword']) {
        respuesta = {
          "status": false,
          "reason": "changePassword",
          "msg": "Por seguridad debe cambiar su contraseña"
        };
        return respuesta;
        //FIN VALIDACION SI CAMBIÓ SU PASSWORD
      }
      //INI SI ESTA BLOQUEDDO
      if (dataUsuario['bloqueado']) {
        //INI SI ESTA BLOQUEADO Y TERMINÓ SU TIEMPO DE BLOQUEO, SE DESBLOQUEA AL USUARIO
        if (dataUsuario['timer'].seconds <= Timestamp.now().seconds) {
          Map<String, dynamic> desbloquear = {
            'bloqueado': false,
            'intentos': 0
          };
          await _users.doc(documentSnapshot.docs[0].id).update(desbloquear);
          documentSnapshot =
              await _users.where('authUid', isEqualTo: user.uid).get();
          dataUsuario = documentSnapshot.docs[0].data();
          respuesta = {
            "status": true,
            "reason": "login",
            "msg":
                "uid: ${userCredential.user!.uid}, email: ${userCredential.user!.email}"
          };
          return respuesta;
          //FIN SI ESTA BLOQUEADO Y TERMINÓ SU TIEMPO DE BLOQUEO, SE DESBLOQUEA AL USUARIO
        } else {
          //INI SI SU TIEMPO DE BLOQUEO SIGUE VIGENTE, RETORNAMOS EL TIEMPO RESTANTE PARA SU DESBLOQUEO
          int diferencia =
              dataUsuario['timer'].seconds - Timestamp.now().seconds;
          respuesta = {
            "status": false,
            "reason": "locked",
            "msg": "bloqueado por $diferencia segundos"
          };
          return respuesta;
          //FIN SI SU TIEMPO DE BLOQUEO SIGUE VIGENTE, RETORNAMOS EL TIEMPO RESTANTE PARA SU DESBLOQUEO
        }
        //FIN SI ESTA BLOQUEDDO
      } else {
        //INI SI NO ESTÁ BLOQUEADO Y PASA TODAS LAS VALIDACIONES, EL USUARIO SE LOGEA
        respuesta = {
          "status": true,
          "reason": "login",
          "msg":
              "uid: ${userCredential.user!.uid}, email: ${userCredential.user!.email}"
        };
        return respuesta;
        //FIN SI NO ESTÁ BLOQUEADO Y PASA TODAS LAS VALIDACIONES, EL USUARIO SE LOGEA
      }
    } on FirebaseAuthException catch (e) {
      //INI SI EL CORREO ES INCORRECTO
      if (e.code == 'user-not-found') {
        respuesta = {"status": false, "reason": "email", "msg": e.code};
        return respuesta;
        //FIN SI EL CORREO ES INCORRECTO
      } else if (e.code == 'wrong-password') {
        //INI SI EL PASSWORD ES INCORRECTO
        QuerySnapshot<dynamic> documentSnapshot =
            await _users.where('email', isEqualTo: email).get();
        Map<String, dynamic> dataUsuario = documentSnapshot.docs[0].data();
        if (!dataUsuario['bloqueado']) {
          //INI INCREMENTAMOS INTENTOS
          if (dataUsuario['intentos'] != 2) {
            int increment = dataUsuario['intentos'] + 1;
            Map<String, dynamic> data = {'intentos': increment};
            await users.doc(documentSnapshot.docs[0].id).update(data);
            respuesta = {
              'status': false,
              "reason": "password",
              'msg': 'wrong-password ntento Nro $increment'
            };
            return respuesta;
            //INI INCREMENTAMOS INTENTOS
          } else {
            //INI BLOQUEAMOS POR EXESO DE INTENTOS
            DateTime date = DateTime.now();
            date = date.add(const Duration(minutes: 1));
            Map<String, dynamic> timer = {
              'bloqueado': true,
              'timer': Timestamp.fromDate(date)
            };
            await users.doc(documentSnapshot.docs[0].id).update(timer);
            int increment = dataUsuario['intentos'] + 1;
            respuesta = {
              'status': false,
              "reason": "password",
              'msg': 'wrong-password ntento Nro $increment',
              'bloqueado': true
            };
            return respuesta;
            //FIN BLOQUEAMOS POR EXESO DE INTENTOS
          }
        }
        respuesta = {"status": false, "reason": "other", "msg": e.code};
        return respuesta;
        //FIN SI EL PASSWORD ES INCORRECTO
      }
    }
  }

  Future<dynamic> registrarUsuario(
      Map<String, dynamic> usuario, imagenPath, fileName) async {
    Map<String, dynamic> respuesta;
    String name = Timestamp.now().seconds.toString() + fileName;
    File avatar = File(imagenPath);
    try {
      //INI REGISTRAR EN AUTH Y ENVIAR EMAIL
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: usuario['email'], password: usuario['ci']);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      //FIN REGISTRAR EN AUTH Y ENVIAR EMAIL
      // INI GUARDAR AVATAR EN STORAGE
      final Reference ref = storage.ref('avatares').child(name);
      final UploadTask uploadTask = ref.putFile(avatar);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
      final String url = await snapshot.ref.getDownloadURL();
      //FIN GUARDAR AVATAR EN STORAGE
      //INI ACTUALIZAR USUARIO
      Map<String, dynamic> usuarioUpdate = {
        "telefono": usuario['telefono'],
        "email": usuario['email'],
        "password": usuario['ci'],
        "authUid": userCredential.user!.uid,
        "avatar": url,
        "changePassword": false,
        "bloqueado": false,
        "intentos": 0,
        "timer": Timestamp.now()
      };
      QuerySnapshot<dynamic> documentSnapshot =
          await _users.where('ci', isEqualTo: usuario['ci']).get();
      await _users.doc(documentSnapshot.docs[0].id).update(usuarioUpdate);
      //FIN ACTUALIZAR USUARIO
      respuesta = {
        "status": true,
        "msg": "Registrado con exito!!",
        "verifyEmail": "Se envio un correo de verificacion"
      };
      return respuesta;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        respuesta = {
          "status": false,
          "msg": e.code,
        };
        return respuesta;
      } else if (e.code == 'email-already-in-use') {
        respuesta = {
          "status": false,
          "msg": e.code,
        };
        return respuesta;
      }
      //CUALQUIER OTRA EXCEPCION INCLUIDA LA DE LOS 6 CARACTERES
      respuesta = {
        "status": false,
        "msg": e.code,
      };
      return respuesta;
    } catch (e) {
      respuesta = {
        "status": false,
        "msg": e,
      };
      return respuesta;
    }
  }

  Future<dynamic> verificarCi(String ci) async {
    Map<String, dynamic> resp;
    QuerySnapshot<dynamic> documentSnapshotCi =
        await _users.where('ci', isEqualTo: ci).get();
    if (documentSnapshotCi.size == 0) {
      resp = {
        "match": false,
        "name": "SN",
        "msg": "Usuario no registrado en el Segip",
        "uuid": "none"
      };
    } else {
      Map<String, dynamic> user = documentSnapshotCi.docs[0].data();
      resp = {
        "match": true,
        "name": user["name"],
        "msg": "Usuario registrado en el Segip, puede continuar",
        "uuid": user['uuid']
      };
    }
    return resp;
  }

  Future<bool> verificarFoto(String image64, String uuid) async {
    final url = Uri.parse('$baseUrl/photo/search/v2');
    try {
      final res = await http
          .post(url, headers: {'token': token}, body: {'photo': image64});
      final data = dataRecognitionFromJson(res.body);
      if (data.isEmpty) {
        return false;
      } else {
        if (data[0].uuid == uuid) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> changePassword(String newPassword) async {
    Map<String, dynamic> respuesta; 
    try {
      User? user = _firebaseAuth.currentUser;
      await user?.updatePassword(newPassword);
      QuerySnapshot<dynamic> documentSnapshot =
            await _users.where('email', isEqualTo: user?.email).get();
        Map<String, dynamic> data = {'changePassword': true};
            await users.doc(documentSnapshot.docs[0].id).update(data);
        respuesta = {
          "status":true,
          "msg":"Password cambiado satisfactoriamente"
        };
        return respuesta;
    } on FirebaseAuthException catch (e) {
        respuesta = {
          "status":false,
          "msg":'error: ${e.code}'
        };
        return respuesta;
    }
  }

  Future<bool> signOut() async {
    await _firebaseAuth.signOut();
    return true;
  }

  //FIN METODOS AUTH

  Future<dynamic> getUserWhitUuid(uuid) async {
    QuerySnapshot<Object?> documentSnapshot =
        await users.where('uuid', isEqualTo: uuid).get();
    return documentSnapshot.docs[0];
  }

  Future<bool> addUser(Map<String, dynamic> data) async {
    return await _users
        .add(data)
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<String> uploadAvatartorage(File avatar, String fileName) async {
    try {
      final Reference ref = storage.ref('avatares').child(fileName);
      final UploadTask uploadTask = ref.putFile(avatar);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
      final String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return "";
    }
  }

  Future<dynamic> getUser() async {
    const String uid = "zhFiV0xrj5OAx3jbNy3e";
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();
    return documentSnapshot.data();
  }
}
