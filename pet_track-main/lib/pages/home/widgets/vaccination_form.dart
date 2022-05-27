import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_track/data/firestore.dart';

class VaccinationForm extends StatefulWidget {
  const VaccinationForm({Key? key}) : super(key: key);

  @override
  _VaccinationFormState createState() => _VaccinationFormState();
}

class _VaccinationFormState extends State<VaccinationForm> {
  bool saving = false;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedCurrentDate = DateTime.now();
  DateTime selectedNextDate = DateTime.now();
  final TextEditingController _pet = TextEditingController();
  final TextEditingController _doctor = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _current = TextEditingController();
  final TextEditingController _next = TextEditingController();

  _selectCurrentDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedCurrentDate,
        firstDate: DateTime(2019, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedCurrentDate) {
      setState(() {
        selectedCurrentDate = picked;
        var date =
            "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
        _current.text = date;
      });
    }
  }

  _selectNextDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedNextDate,
        firstDate: DateTime(2019, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedNextDate) {
      setState(() {
        selectedNextDate = picked;
        var date =
            "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
        _next.text = date;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => saving = true);
      await Firestore.addVaccination(
        _pet.text,
        _doctor.text,
        _place.text,
        selectedCurrentDate,
        selectedNextDate,
      );
      setState(() => saving = false);
      Get.back();
    }
  }

  String? _validator(String? value) {
    if (value?.isEmpty ?? true) {
      return "Value cannot be empty";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: saving ? null : () => _selectCurrentDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _current,
                    decoration: InputDecoration(
                      labelText: "Current Date",
                      enabled: !saving,
                      icon: const Icon(Icons.calendar_today),
                    ),
                    validator: _validator,
                  ),
                ),
              ),
              GestureDetector(
                onTap: saving ? null : () => _selectNextDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _next,
                    decoration: InputDecoration(
                      labelText: "Next Date",
                      enabled: !saving,
                      icon: const Icon(Icons.calendar_today),
                    ),
                    validator: _validator,
                  ),
                ),
              ),
              TextFormField(
                controller: _pet,
                decoration: InputDecoration(labelText: 'Pet', enabled: !saving),
                validator: _validator,
              ),
              TextFormField(
                controller: _doctor,
                decoration:
                    InputDecoration(labelText: 'Doctor', enabled: !saving),
                validator: _validator,
              ),
              TextFormField(
                controller: _place,
                decoration:
                    InputDecoration(labelText: 'Place', enabled: !saving),
                validator: _validator,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: saving ? null : _submit,
                    child: saving
                        ? const SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1,
                            ),
                          )
                        : const Text("Add"),
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
