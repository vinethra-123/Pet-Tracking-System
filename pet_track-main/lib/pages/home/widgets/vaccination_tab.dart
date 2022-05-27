import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pet_track/data/firestore.dart';
import 'package:pet_track/data/vaccination.dart';
import 'package:pet_track/pages/home/widgets/vaccination_form.dart';

class VaccinationTab extends StatefulWidget {
  const VaccinationTab({Key? key}) : super(key: key);

  @override
  VaccinationTabState createState() => VaccinationTabState();
}

class VaccinationTabState extends State<VaccinationTab> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: StreamBuilder<List<Vaccination>>(
            stream: Firestore.getVaccinations(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(strokeWidth: 1));
              }
              if (snapshot.connectionState == ConnectionState.done) {}
              List<Vaccination> data = (snapshot.data ?? []);
              if (data.isEmpty) {
                return const Center(
                    child: Text(
                  "There are no vaccinations.\nPlease add a new one.",
                  textAlign: TextAlign.center,
                ));
              }

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    Vaccination vaccination = data[i];
                    return ListTile(
                      visualDensity: const VisualDensity(vertical: 2),
                      isThreeLine: true,
                      title: Text(
                          "Pet: ${vaccination.pet}\nNext vaccination: ${DateFormat.yMd().format(vaccination.next)}"),
                      subtitle: Text(
                          "Last vaccination:${DateFormat.yMd().format(vaccination.current)}\nDoctor: ${vaccination.doctor}"),
                      trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => Get.defaultDialog(
                                title: "Are you sure?",
                                content: Text(
                                    "Selected Vaccination for ${vaccination.pet} will be deleted."),
                                onConfirm: () async {
                                  await Firestore.deleteVaccination(
                                      vaccination.id);
                                  Get.back();
                                },
                                onCancel: () => {},
                              )),
                    );
                  });
            }),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Vaccinations'),
      automaticallyImplyLeading: false,
      elevation: 1,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w300,
      ),
      backgroundColor: Colors.blueAccent,
      actions: [addButton()],
    );
  }

  IconButton addButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => Get.defaultDialog(
        title: "Add new vaccination",
        barrierDismissible: false,
        content: const VaccinationForm(),
      ),
    );
  }
}
