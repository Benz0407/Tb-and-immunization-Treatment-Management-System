import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/event_model.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/services/event_services.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/custom_multiselect.dart';


class EventFormDialog extends StatefulWidget {
  final Function onSaveEvent;

  const EventFormDialog({super.key, required this.onSaveEvent});

  @override
  EventFormDialogState createState() => EventFormDialogState();
}

class EventFormDialogState extends State<EventFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _bhwOrNurse = 'Who set the event';
  List<String> _selectedParticipants = [];
  List<String> _allParticipants = [];

  @override
  void initState() {
    super.initState();
    _loadAllParticipants();
  }

  Future<void> _loadAllParticipants() async {
    try {
      List<String> participants = await EventService().fetchAllParticipants();
      setState(() {
        _allParticipants = participants;
      });
    } catch (e) {
      // print('Error fetching participants: $e');
    }
  }

  Future<void> _saveEvent() async {
    Event eventData = Event(
      purpose: _purposeController.text,
      date: _dateController.text,
      time: _timeController.text,
      venue: _venueController.text,
      bhwOrNurse: _bhwOrNurse,
      notes: _notesController.text,
    );

    try {
      await EventService().saveEvent(eventData, _selectedParticipants);
      widget.onSaveEvent(eventData); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save event')),
      );
      // print('Error saving event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      backgroundColor: Colors.grey,
      child: Container(
        width: screenSize.width * 0.9,
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: const Color(0xFFC1D986),
                          child: const Text(
                            'Create Event',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _purposeController,
                          decoration: const InputDecoration(
                            labelText: 'Purpose of event',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter the purpose of the event',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a purpose';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              _dateController.text =
                                  DateFormat('MM/dd/yyyy').format(pickedDate);
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                labelText: 'Date of event',
                                suffix: Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                                hintText: 'Select the date of the event',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              _timeController.text = pickedTime.format(context);
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _timeController,
                              decoration: const InputDecoration(
                                labelText: 'Time of event',
                                suffix: Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                                hintText: 'Select the time of the event',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a time';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _venueController,
                          decoration: const InputDecoration(
                            labelText: 'Venue of event',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter the venue of the event',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a venue';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        const Text('List of Participants'),
                        MultiSelectWithSelectAll(
                          items: _allParticipants,
                          selectedItems: _selectedParticipants,
                          onSelectionChanged: (selectedItems) {
                            setState(() {
                              _selectedParticipants = selectedItems;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          readOnly: true,
                          onTap: () async {
                            List<String>? selectedParticipants =
                                await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                List<String> initialSelected =
                                    List.from(_selectedParticipants);
                                return AlertDialog(
                                  title: const Text('Select Participants'),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children:
                                            _allParticipants.map((participant) {
                                          bool isSelected = initialSelected
                                              .contains(participant);
                                          return CheckboxListTile(
                                            title: Text(participant),
                                            value: isSelected,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                if (value ?? false) {
                                                  initialSelected
                                                      .add(participant);
                                                } else {
                                                  initialSelected
                                                      .remove(participant);
                                                }
                                              });
                                            },
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(null); 
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            initialSelected);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (selectedParticipants != null) {
                              setState(() {
                                _selectedParticipants = selectedParticipants;
                              });
                            }
                          },
                          controller: TextEditingController(
                              text: _selectedParticipants.join(", ")),
                          decoration: const InputDecoration(
                            labelText: 'Select Participants',
                            hintText: 'Tap to select participants',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (_selectedParticipants.isEmpty) {
                              return 'Please select at least one participant';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _bhwOrNurse,
                          items: [
                            'Who set the event',
                            'Nurse 1',
                            'Nurse 2',
                            'Nurse 3',
                            'Nurse 4',
                            'Nurse 5',
                            'BHW 1',
                            'BHW 2',
                            'BHW 3',
                            'BHW 4',
                            'BHW 5'
                          ].map((label) {
                            return DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _bhwOrNurse = newValue!;
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == 'Who set the event' || value == null || value.isEmpty) {
                              return 'Please select an option';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Notes',
                            hintText: 'Enter any notes for the event',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFFB4CD78),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 16.0),
                            TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _saveEvent();
                                  Navigator.of(context).pop();
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFFB4CD78),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text('Save event'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
