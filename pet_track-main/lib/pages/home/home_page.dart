import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_track/pages/home/widgets/animal_clinic_tab.dart';
import 'package:pet_track/pages/home/widgets/map_tab.dart';
import 'package:pet_track/pages/home/widgets/pet_food_tab.dart';
import 'package:pet_track/pages/home/widgets/vaccination_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentTab = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _navigationTapped(int tab) {
    _tabController.animateTo(tab);
    setState(() => currentTab = tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: MaterialStateProperty.all(
            const IconThemeData(size: 24, color: Colors.grey),
          ),
          indicatorColor: Colors.blueAccent.withOpacity(0.2),
        ),
        child: NavigationBar(
          selectedIndex: currentTab,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: _navigationTapped,
          height: 60,
          backgroundColor: Colors.white,
          destinations: const [
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.map),
              selectedIcon:
                  Icon(FontAwesomeIcons.mapMarkedAlt, color: Colors.blueAccent),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.store),
              selectedIcon: Icon(
                FontAwesomeIcons.storeAlt,
                color: Colors.blueAccent,
              ),
              label: 'Pet Food',
            ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.hospitalAlt),
              selectedIcon:
                  Icon(FontAwesomeIcons.hospitalAlt, color: Colors.blueAccent),
              label: 'Animal Clinic',
            ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.syringe),
              selectedIcon:
                  Icon(FontAwesomeIcons.syringe, color: Colors.blueAccent),
              label: 'Vaccinations',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          MapTab(),
          PetFoodTab(),
          AnimalClinicTab(),
          VaccinationTab(),
        ],
      ),
    );
  }
}
