// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:topicos_proy/src/Controllers/usuario_controller.dart';

class LoginPin extends StatefulWidget {
  const LoginPin({super.key});

  @override
  State<LoginPin> createState() => _LoginPinState();
}

class _LoginPinState extends State<LoginPin> {
  var selectedindex = 0;
  String code = '';
  String msg = '';
  int seconds = 0;
  int intentos = 0;
  bool habilitado = true;
  var firebaseUsuario = FirebaseUsuario();
  // late usaurio;
  void _startCountDwn(){
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
          setState(() {
            seconds--;
          });
      }else{
        habilitado = true;
        timer.cancel();
      }
     });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w500,
      color: Colors.black.withBlue(40),
    );
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    print("Code is $code");
    return Scaffold(
      backgroundColor: Colors.black.withBlue(40),
      body: Column(children: [
        Container(
          height: height * 0.15,
          width: width,
          color: Colors.black.withBlue(40),
          alignment: Alignment.center,
          child: Text('$msg time: $seconds intentos: $intentos', style: TextStyle(color: Colors.white,fontSize: 20),),
        ),
        Container(
          height: height * 0.85,
          width: width,
          decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(children: [
            Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DigitHolder(
                        width: width,
                        index: 0,
                        selectedIndex: selectedindex,
                        code: code,
                      ),
                      DigitHolder(
                          width: width,
                          index: 1,
                          selectedIndex: selectedindex,
                          code: code),
                      DigitHolder(
                          width: width,
                          index: 2,
                          selectedIndex: selectedindex,
                          code: code),
                      DigitHolder(
                          width: width,
                          index: 3,
                          selectedIndex: selectedindex,
                          code: code),
                    ],
                  ),
                )),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () {
                            addDigit(1);
                          },
                          child: Text('1', style: textStyle)),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () {
                            addDigit(2);
                          },
                          child: Text('2', style: textStyle)),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () {
                            addDigit(3);
                          },
                          child: Text('3', style: textStyle)),
                    ),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () {
                            addDigit(4);
                          },
                          child: Text('4', style: textStyle)),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () {
                            addDigit(5);
                          },
                          child: Text('5', style: textStyle)),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () {
                            addDigit(6);
                          },
                          child: Text('6', style: textStyle)),
                    ),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () {
                            addDigit(7);
                          },
                          child: Text('7', style: textStyle)),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () {
                            addDigit(8);
                          },
                          child: Text('8', style: textStyle)),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () {
                            addDigit(9);
                          },
                          child: Text('9', style: textStyle)),
                    ),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () {
                            backspace();
                          },
                          child: Icon(Icons.backspace_outlined,
                              color: Colors.black.withBlue(40), size: 30)),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () {
                            addDigit(0);
                          },
                          child: Text('0', style: textStyle)),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed:habilitado? () async {
                            try {
                              /* final respuesta =
                                  await firebaseUsuario.login(code);

                                  print(respuesta['status']);
                                  if (respuesta['status']) {
                                    print('Redirigir al PErfil');
                                     intentos = 0;
                                      msg = 'Pin incorrecto';
                                      seconds = 0;
                                      setState(() {
                                        
                                      });
                                  }else{
                                    if (respuesta['intentos']<3) {
                                      intentos = respuesta['intentos'];
                                      msg = 'Pin incorrecto';
                                      setState(() {
                                        
                                      });
                                    }else{
                                      intentos = 0;
                                      intentos = respuesta['intentos'];
                                      msg = 'Pin incorrecto';
                                      seconds = respuesta['seconds'];
                                      habilitado = false;
                                      _startCountDwn();
                                    }
                                  } */
                              // print(usaurio['uuid']);


                              // if (usaurio != null) {
                              //   // ignore: use_build_context_synchronously
                              //   Navigator.pushNamed(context, 'profile',
                              //       arguments: usaurio['uuid']);
                              // } else {
                              //   showDialog(
                              //       context: context,
                              //       builder: ((context) => AlertDialog(
                              //             title: const Text('Warnning'),
                              //             content:
                              //                 const Text('Unregistered user'),
                              //             actions: [
                              //               TextButton(
                              //                   onPressed: () {
                              //                     Navigator.of(context)
                              //                         .pushNamedAndRemoveUntil(
                              //                             'login',
                              //                             (Route<dynamic>
                              //                                     route) =>
                              //                                 false);
                              //                   },
                              //                   child: const Text('Yes'))
                              //             ],
                              //           )));
                              // }
                            } catch (e) {
                              print(e);
                            }
                          }:null,
                          child: Icon(Icons.check,
                              color: Colors.black.withBlue(40), size: 30)),
                    ),
                  ],
                )),
          ]),
        )
      ]),
    );
  }

  addDigit(int digit) {
    if (code.length > 3) {
      return;
    }
    setState(() {
      code = code + digit.toString();
      print('Code is $code');
      selectedindex = code.length;
    });
  }

  backspace() {
    if (code.length == 0) {
      return;
    }
    setState(() {
      code = code.substring(0, code.length - 1);
      selectedindex = code.length;
    });
  }
}

class DigitHolder extends StatelessWidget {
  final int selectedIndex;
  final int index;
  final String code;
  const DigitHolder({
    required this.selectedIndex,
    Key? key,
    required this.width,
    required this.index,
    required this.code,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: width * 0.17,
      width: width * 0.17,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: index == selectedIndex ? Colors.blue : Colors.transparent,
              offset: Offset(0, 0),
              spreadRadius: 1.5,
              blurRadius: 2,
            )
          ]),
      child: code.length > index
          ? Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.black.withBlue(40),
                shape: BoxShape.circle,
              ),
            )
          : Container(),
    );
  }
}
