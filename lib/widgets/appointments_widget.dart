import 'package:flutter/material.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/appointment_model.dart';

class AppointmentsListWidget extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentsListWidget({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.withOpacity(0.3),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Appointments:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              Appointment appointment = appointments[index];
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Appointment Details'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Purpose: ${appointment.purpose}'),
                            Text('Date: ${appointment.date}, Time: ${appointment.time}'),
                            Text('BHW/Nurse Assigned: ${appointment.bhwOrNurse}'),
                            Text('Notes: ${appointment.notes}')
                            
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text('Purpose: ${appointment.purpose}'),
                    subtitle: Text('Date: ${appointment.date}, Time: ${appointment.time}'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}