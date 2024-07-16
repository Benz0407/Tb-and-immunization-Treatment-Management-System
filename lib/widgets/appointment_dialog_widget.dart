import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/appointment_model.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/immunization_model.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/services/appointment_service.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/date_selection.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/notification.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/spaces.dart';

class AppointmentFormDialog extends StatefulWidget {
  final Immunization immunization;
  final Function(Appointment) onSaveAppointment;

  const AppointmentFormDialog({
    super.key,
    required this.onSaveAppointment,
    required this.immunization,
  });

  @override
  AppointmentFormDialogState createState() => AppointmentFormDialogState();
}

class AppointmentFormDialogState extends State<AppointmentFormDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AppointmentService _appointmentService = AppointmentService(); 

  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _bhwOrNurseController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();




  late SnackbarHelper _snackbarHelper;

  @override
  void initState() {
    super.initState();
    _snackbarHelper = SnackbarHelper(context);
  }

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('MM/dd/yyyy').format(pickedDate);
      });
    }
  }

  void _selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        controller.text = pickedTime.format(context);
      });
    }
  }

  void _saveForm() async{
    if (_formKey.currentState!.validate()) {
      Appointment appointment = Appointment(
        immunizationId: widget.immunization.id,
        purpose: _purposeController.text,
        date: _dateController.text,
        time: _timeController.text,
        bhwOrNurse: _bhwOrNurseController.text,
        notes: _notesController.text,
      );

      // Print the appointment data for debugging
      print('Appointment Data:');
      print('Immunization ID: ${appointment.immunizationId}');
      print('Purpose: ${appointment.purpose}');
      print('Date: ${appointment.date}');
      print('Time: ${appointment.time}');
      print('BHW or Nurse: ${appointment.bhwOrNurse}');
      print('Notes: ${appointment.notes}');

      widget.onSaveAppointment(appointment);
      await _appointmentService.addAppointment(appointment); 
      _snackbarHelper.showSnackbar('Appointment saved successfully');
      Navigator.of(context).pop();
    } else {
      _snackbarHelper.showSnackbar('Please fill in all required fields');
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
                            'Appointment Details',
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
                            labelText: 'Purpose of Appointment',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter the purpose',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Purpose is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        GestureDetector(
                          onTap: () => _selectDate(context, _dateController),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                labelText: 'Date of Appointment',
                                suffix: Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                                hintText: 'Select date',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        verticalSpacing(12),
                        GestureDetector(
                          onTap: () => _selectTime(context, _timeController),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _timeController,
                              decoration: const InputDecoration(
                                labelText: 'Time of Appointment',
                                suffix: Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                                hintText: 'Select time',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Time is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: _bhwOrNurseController,
                          decoration: const InputDecoration(
                            labelText: 'BHW/Nurse',
                            hintText: 'Enter BHW/Nurse name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'BHW/Nurse name is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            labelText: 'Notes',
                            hintText: 'Enter any notes',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        verticalSpacing(30),
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
                              onPressed: _saveForm,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFFB4CD78),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text('Save'),
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
