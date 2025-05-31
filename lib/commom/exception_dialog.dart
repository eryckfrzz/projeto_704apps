import 'package:flutter/material.dart';

Future<dynamic> showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(color: Colors.red)),
        content: Text(content, style: TextStyle(color: Colors.black)),
        actions: [TextButton(onPressed: () {
          Navigator.pop(context, true);
        }, child: Text('Continuar')), TextButton(onPressed: () {
          Navigator.pop(context, false);
        }, child: Text('Cancelar'))],
      );
    },
  );
}
