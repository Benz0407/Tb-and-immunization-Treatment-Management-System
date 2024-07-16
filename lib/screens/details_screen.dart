import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/appointment_model.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/immunization_model.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/screens/immunization_screem.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/services/appointment_service.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/services/immunization_service.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/spaces.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/widgets/appointment_dialog_widget.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/widgets/appointments_widget.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/widgets/form_dialog_widget.dart';

class ImmunizationDetailsScreen extends StatefulWidget {
  final Immunization immunization;

  const ImmunizationDetailsScreen({Key? key, required this.immunization}) : super(key: key);

  @override
  State<ImmunizationDetailsScreen> createState() =>
      _ImmunizationDetailsScreenState();
}

class _ImmunizationDetailsScreenState extends State<ImmunizationDetailsScreen> {
  late Future<Immunization> futureImmunization;
  late Future<List<Appointment>> futureAppointments;

  @override
  void initState() {
    super.initState();
    futureImmunization = Future.value(widget.immunization);
    futureAppointments = AppointmentService()
        .fetchAppointmentsByImmunizationId(widget.immunization.id);
  }

  void refreshImmunizationDetails() {
    setState(() {
      futureImmunization =
          ImmunizationService().fetchImmunizationById(widget.immunization.id);
      futureAppointments = AppointmentService()
          .fetchAppointmentsByImmunizationId(widget.immunization.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE, dd/MM/yyyy').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ImminizationScreen(),
              ),
            );
          },
        ),
        title: Center(
          child: Column(
            children: [
              FutureBuilder<Immunization>(
                future: futureImmunization,
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
        future: Future.wait([futureImmunization, futureAppointments]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            Immunization immunization = snapshot.data![0];
            List<Appointment> appointments = snapshot.data![1];

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
                                return FormDialogWidget(
                                  immunization: immunization,
                                  onImmunizationAddedOrUpdated: () {
                                    refreshImmunizationDetails();
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
                            'Immunization Details',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildInfoField('Vaccination History', immunization.history),
                    buildInfoField('Vaccine Name', immunization.vaccineName),
                    buildInfoField('Vaccine Brand', immunization.vaccineBrand),
                    buildInfoField('Batch Number', immunization.batchNumber),
                    buildInfoField('Expiry Date', immunization.expiryDate),
                    buildInfoField(
                        'Date Administered', immunization.dateAdministered),
                    buildInfoField(
                        'Administered By', immunization.administeredBy),
                    appointments.isNotEmpty
                        ? AppointmentsListWidget(
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
                              return AppointmentFormDialog(
                                onSaveAppointment: (appointment) {
                                  refreshImmunizationDetails();
                                },
                                immunization: immunization,
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