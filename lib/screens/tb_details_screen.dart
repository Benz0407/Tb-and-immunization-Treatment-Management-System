import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/tb_appointment_model.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/tb_model.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/services/appointment_service.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/services/tb_service.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/spaces.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/widgets/tb_appointment_dialog_widget.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/widgets/tb_appointments_widget.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/widgets/tb_form_dialog_widget.dart';

class TbDetailsScreen extends StatefulWidget {
  final Tuberculosis tb;

  const TbDetailsScreen({super.key, required this.tb});

  @override
  State<TbDetailsScreen> createState() => _TbDetailsScreenState();
}

class _TbDetailsScreenState extends State<TbDetailsScreen> {
  late Future<Tuberculosis> futureTb;
  late Future<List<TbAppointment>> futureAppointments;

  @override
  void initState() {
    super.initState();
    futureTb = Future.value(widget.tb);
    futureAppointments = AppointmentService().fetchAppointmentsByTbId(widget.tb.id);
  }

  void refreshTbDetails() {
    setState(() {
      futureTb = TbService().fetchTuberculosisById(widget.tb.id);
      futureAppointments = AppointmentService().fetchAppointmentsByTbId(widget.tb.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, dd/MM/yyyy').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Column(
            children: [
              FutureBuilder<Tuberculosis>(
                future: futureTb,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (!snapshot.hasData) {
                    return const Text('Loading...');
                  } else {
                    return Text(
                      snapshot.data!.name,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    );
                  }
                },
              ),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
        actions: const [
          CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([futureTb, futureAppointments]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            Tuberculosis tb = snapshot.data![0];
            List<TbAppointment> appointments = snapshot.data![1];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        verticalSpacing(10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF93A764),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            minimumSize: const Size(100, 45),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TbFormDialogWidget(
                                  tuberculosis: tb,
                                  onTbAddedOrUpdated: () {
                                    refreshTbDetails();
                                  },
                                );
                              },
                            );
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    verticalSpacing(8),
                    Card(
                      color: const Color(0xFFC1D986),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const SizedBox(
                        height: 50, // Adjust card height
                        width: double.infinity, // Adjust card width
                        child: ListTile(
                          title: Text(
                            'Tuberculosis Details',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildInfoField('TB Brand', tb.tbBrand),
                    buildInfoField('Batch Number', tb.batchNumber),
                    buildInfoField('Expiry Date', tb.expiryDate),
                    buildInfoField('Date Administered', tb.dateAdministered),
                    buildInfoField('Administered By', tb.administeredBy),
                    buildInfoField('TB Diagnosis Date', tb.tbDiagnosisDate),
                    buildInfoField('TB Type', tb.tbType),
                    buildInfoField('Treatment Start Date', tb.treatmentStartDate),
                    buildInfoField('Medicine Prescribed', tb.medicinePrescribed),
                    buildInfoField('Dosage', tb.dosage),
                    buildInfoField('Frequency', tb.frequency),
                    buildInfoField('Treatment Completion Date', tb.treatmentCompletionDate),
                    buildInfoField('Diagnostic Test Conducted', tb.diagnosticTestConducted),
                    buildInfoField('Diagnostic Test Result', tb.diagnosticTestResult),
                    buildInfoField('Vaccination History', tb.vaccinationHistory),
                    buildInfoField('Treatment Outcome', tb.treatmentOutcome),
                    buildInfoField('Follow-up Date', tb.followupDate),
                    buildInfoField('Notes', tb.notes),
                    appointments.isNotEmpty
                        ? TbAppointmentsListWidget(
                            appointments: appointments,
                          )
                        : Container(),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF93A764),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size(100, 50),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return TbAppointmentFormDialog(
                                tuberculosis: tb,
                                onSaveAppointment: (appointment) {
                                  refreshTbDetails();
                                }
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Create Appointment',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}
