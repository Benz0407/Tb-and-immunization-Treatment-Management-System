import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/screens/immunization_screem.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/screens/tb_screen.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  int _selectedIndex = 2;
  
    void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
          onPressed: () {},
        ),
        title: Center(
          child: Column(
            children: [
              const Text(
                'Management',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                managementButton('Immunization', 'assets/immunization.png', const ImminizationScreen()),
                const SizedBox(width: 20), // Space between buttons
                managementButton('Tuberculosis', 'assets/tuberculosis.png', const TbScreen()),
              ],
            ),
            const SizedBox(height: 20), // Space between rows
            managementButton('Pregnant Women', 'assets/pregnant_woman.png', const TbScreen()),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100, // Adjust height as needed
        decoration: const BoxDecoration(
          color: Color(0xFFB4CD78),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
               backgroundColor:Color(0xFFB4CD78),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
               backgroundColor:Color(0xFFB4CD78),
              label: 'Residents',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monitor_heart),
               backgroundColor:Color(0xFFB4CD78),
              label: 'Management',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services),
               backgroundColor:Color(0xFFB4CD78),
              label: 'Services',
            ),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: Colors.transparent, // Set to transparent to show the container color
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          selectedFontSize: 20,
          selectedIconTheme: const IconThemeData(color: Colors.black, size: 40),
          onTap: _onItemTapped,
          elevation: 0, // Remove elevation shadow
        ),
      ),
    );
  }
  

  Widget managementButton(String title, String imagePath, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 150,
            width: 150,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}