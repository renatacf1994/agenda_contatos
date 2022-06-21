import 'package:flutter/material.dart';

Widget botaoWidget(String text, void Function() f){
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.red,
    minimumSize: const Size(88, 44),
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  return TextButton(
    style: flatButtonStyle,
    onPressed: f,
    child: Text(
        text,
      style: const TextStyle(
        fontSize: 20.0,
      ),
    ),
  );
}