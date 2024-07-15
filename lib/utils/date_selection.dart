import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelection {
  final TextEditingController dateController;
  final StateSetter setState;

  DateSelection({required this.dateController, required this.setState});

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('MM-dd-yyyy').format(picked);
      });
    }
  }
}
