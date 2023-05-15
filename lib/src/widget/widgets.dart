import 'package:flutter/material.dart';

class Widgets {
    static alertSnackbar(BuildContext context, String content){
    final snackBar = SnackBar(content: Text(content));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}