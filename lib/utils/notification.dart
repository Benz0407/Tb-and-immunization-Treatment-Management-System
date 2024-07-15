import 'package:flutter/material.dart';

class SnackbarHelper {
  BuildContext context;

  SnackbarHelper(this.context);

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
