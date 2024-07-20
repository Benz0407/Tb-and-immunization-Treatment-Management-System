import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/event_model.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/immunization_model.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/screens/details_screen.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/screens/tb_immunization.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/services/event_services.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/services/immunization_service.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/spaces.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/widgets/event_form_dialog.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/widgets/form_dialog_widget.dart';

class ImminizationScreen extends StatefulWidget {
  const ImminizationScreen({super.key});

  @override
  State<ImminizationScreen> createState() => _ImminizaitonScreenState();
}

class _ImminizaitonScreenState extends State<ImminizationScreen> {
  late Future<List<Immunization>> futureImmunization;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _hasEventToday = false;
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    refreshImmunizationList();
  }

  void refreshImmunizationList() {
    setState(() {
      futureImmunization = ImmunizationService().fetchImmunization();
      _checkForEvents();
    });
  }

  Future<void> _checkForEvents() async {
    try {
      EventService eventService = EventService();
      List<Event> events = await eventService.fetchEvents();

      for (Event event in events) {
        try {
          // print('Fetching participants for event with ID: ${event.id}');
          List<String> participants =
              await eventService.fetchEventParticipants(event.id!);
          event.participants = participants;
        } catch (e) {
          // print('Error fetching participants for event ${event.id}: $e');
        }
      }

      setState(() {
        _events = events;
        DateTime today = DateTime.now();
        _hasEventToday = events.any((event) {
          DateTime eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
          return eventDate.year == today.year &&
              eventDate.month == today.month &&
              eventDate.day == today.day;
        });
      });
    } catch (e) {
      print('Error checking for events: $e');
    }
  }

  void searchImmunizations(String query) {
    setState(() {
      _searchQuery = query;
      futureImmunization = ImmunizationService().searchImmunizations(query);
    });
  }

  void handleEventSaved(Map<String, dynamic> eventData) {
    refreshImmunizationList();
  }

  void _showEventDetailsDialog(Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Event Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Purpose: ${event.purpose}'),
                Text('Date: ${event.date}'),
                Text('Time: ${event.time}'),
                Text('Venue: ${event.venue}'),
                Text('Participants: ${event.participants?.join(", ")}'),
                Text('BHW/Nurse: ${event.bhwOrNurse}'),
                Text('Notes: ${event.notes}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              MaterialPageRoute(builder: (context) => const ManagementScreen()),
            );
          },
        ),
        title: Center(
          child: Column(
            children: [
              const Text(
                'Immunization Records',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
      body: Column(
        children: [
          verticalSpacing(20),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                filled: true,
                fillColor: Colors.grey.shade200,
                suffixIcon: const Icon(Icons.search),
                hintText: 'Search...',
              ),
              onChanged: (value) {
                searchImmunizations(value);
              },
            ),
          ),
          if (_hasEventToday)
            GestureDetector(
              onTap: () {
                _showEventDetailsDialog(
                  _events.firstWhere((event) {
                    DateTime eventDate =
                        DateFormat('yyyy-MM-dd').parse(event.date);
                    DateTime today = DateTime.now();
                    return eventDate.year == today.year &&
                        eventDate.month == today.month &&
                        eventDate.day == today.day;
                  }),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                color: Colors.orange,
                child: const Text(
                  "There's an event scheduled for today.",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          verticalSpacing(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF93A764),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: const Size(100, 45),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Generate Report',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          verticalSpacing(10),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<Immunization>>(
                future: futureImmunization,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text("No immunization records found."));
                  } else {
                    List<Immunization> immunizations = snapshot.data!;
                    List<Immunization> filteredList = _searchQuery.isEmpty
                        ? immunizations
                        : immunizations
                            .where((immunization) =>
                                immunization.id
                                    .toString()
                                    .contains(_searchQuery) ||
                                immunization.name
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase()) ||
                                immunization.vaccineName
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase()))
                            .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DataTable(
                        showCheckboxColumn: false,
                        columnSpacing: 15,
                        headingRowColor: WidgetStateColor.resolveWith(
                            (states) => const Color(0xFFB4CD78)),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: SizedBox(
                              width: 150,
                              child: Text(
                                'Name',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 60,
                              child: Text(
                                'V Name',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 60,
                              child: Text(
                                'Vaccination\nBrand',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                        rows: filteredList.map((immunization) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Text(immunization.name),
                              ),
                              DataCell(
                                Text(immunization.vaccineName),
                              ),
                              DataCell(
                                Text(immunization.vaccineBrand),
                              ),
                            ],
                            onSelectChanged: (bool? selected) {
                              if (selected == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ImmunizationDetailsScreen(
                                      immunization: immunization,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          // const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
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
                        return FormDialogWidget(
                          onImmunizationAddedOrUpdated: refreshImmunizationList,
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Add Record',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                horizontalSpacing(10),
                ElevatedButton(
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
                        return EventFormDialog(
                          onSaveEvent: (eventData) {
                            // Handle event data here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Event created successfully')),
                            );
                            refreshImmunizationList();
                          },
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Create Event',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                verticalSpacing(50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
