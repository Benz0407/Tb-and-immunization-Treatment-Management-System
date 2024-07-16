import 'package:flutter/material.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/services/event_services.dart';

class MultiSelectWithSelectAll extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectWithSelectAll({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
  });

  @override
  MultiSelectWithSelectAllState createState() => MultiSelectWithSelectAllState();
}

class MultiSelectWithSelectAllState extends State<MultiSelectWithSelectAll> {
  bool _isSelectAll = false;


  void _toggleSelectAll(bool? value) {
    setState(() {
      _isSelectAll = value ?? false;
      widget.onSelectionChanged(_isSelectAll ? List.from(widget.items) : []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _isSelectAll,
              onChanged: _toggleSelectAll,
            ),
            const Text('All Residents'),
          ],
        ),
      ],
    );
  }
}
