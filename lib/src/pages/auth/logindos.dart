import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:topicos_proy/src/pages/auth/camara.dart';

class LoginDos extends StatefulWidget {
  const LoginDos({super.key});

  @override
  State<LoginDos> createState() => _LoginDosState();
}

class _LoginDosState extends State<LoginDos> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0XFF3C3E52),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 50.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/img/facial.png',
                      width: 120.0,
                    ),
                    const Text(
                      "Face Recognition ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      width: 150,
                      child: const Text(
                        "Authenticate using yout face instead of your password",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, height: 1.5),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await availableCameras().then((value) =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CamaraApp(cameras: value))));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF04A5ED),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 24.0),
                          child: Text(
                            "Authenticate",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
