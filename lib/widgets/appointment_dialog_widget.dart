import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/appointment_model.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/immunization_model.dart';

class AppointmentFormDialog extends StatefulWidget {
  final Immunization immunization;
  final Function(Appointment) onSaveAppointment;

  const AppointmentFormDialog({super.key, required this.onSaveAppointment, required this.immunization});

  @override
  AppointmentFormDialogState createState() => AppointmentFormDialogState();
}

class AppointmentFormDialogState extends State<AppointmentFormDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _bhwOrNurseController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _residentNameController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Appointment'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _purposeController,
              decoration: const InputDecoration(labelText: 'Purpose of Appointment'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Date of Appointment'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 5),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                    _dateController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _timeController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Time of Appointment'),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedTime = pickedTime;
                    _timeController.text = pickedTime.format(context);
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _bhwOrNurseController,
              decoration: const InputDecoration(labelText: 'Which BHW/Nurse set the appointment'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _residentNameController,
              decoration: const InputDecoration(labelText: "Resident's Name"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Appointment appointment = Appointment(
              purpose: _purposeController.text,
              date: _dateController.text,
              time: _timeController.text,
              bhwOrNurse: _bhwOrNurseController.text,
              notes: _notesController.text,
              residentName: _residentNameController.text,
            );
            widget.onSaveAppointment(appointment);
            Navigator.of(context).pop();
          },
          child: const Text('Save Appointment'),
        ),
      ],
    );
  }
}
