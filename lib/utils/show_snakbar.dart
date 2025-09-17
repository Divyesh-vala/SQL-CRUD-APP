import 'package:flutter/material.dart';

showSnakbar(BuildContext context, {required String msg}) {
  return ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(msg)));
}

showSuccessSnakbar(BuildContext context, {required String msg}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
    ),
  );
}

showFailSnakbar(BuildContext context, {required String msg}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    ),
  );
}
