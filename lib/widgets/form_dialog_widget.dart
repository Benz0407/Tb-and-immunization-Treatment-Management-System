import 'package:flutter/material.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/immunization_model.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/services/immunization_service.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/date_selection.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/notification.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/spaces.dart';

class FormDialogWidget extends StatefulWidget {
  final Immunization? immunization;
  final VoidCallback? onImmunizationAddedOrUpdated;
  const FormDialogWidget(
      {super.key,
      this.immunization,
      required this.onImmunizationAddedOrUpdated});

  @override
  FormDialogWidgetState createState() => FormDialogWidgetState();
}

class FormDialogWidgetState extends State<FormDialogWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImmunizationService _immunizationService = ImmunizationService();
  late SnackbarHelper _snackbarHelper;

  TextEditingController nameController = TextEditingController();
  TextEditingController historyController = TextEditingController();
  TextEditingController vaccineNameController = TextEditingController();
  TextEditingController vaccinationBrandController = TextEditingController();
  TextEditingController batchNumController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController dateAdministeredController = TextEditingController();
  TextEditingController adminisiteredByController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _snackbarHelper = SnackbarHelper(context);
    if (widget.immunization != null) {
      _populateFields(widget.immunization!);
    }
  }

  void _populateFields(Immunization immunization) {
    nameController.text = immunization.name;
    historyController.text = immunization.history;
    vaccineNameController.text = immunization.vaccineName;
    vaccinationBrandController.text = immunization.vaccineBrand;
    batchNumController.text = immunization.batchNumber;
    expiryDateController.text = immunization.expiryDate;
    dateAdministeredController.text = immunization.dateAdministered;
    adminisiteredByController.text = immunization.administeredBy;
  }

  void _selectDate(BuildContext context, TextEditingController controller) {
    DateSelection dateSelection = DateSelection(
      dateController: controller,
      setState: setState,
    );
    dateSelection.selectDate(context);
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      Immunization immunization = Immunization(
        name: nameController.text,
        history: historyController.text,
        vaccineName: vaccineNameController.text,
        vaccineBrand: vaccinationBrandController.text,
        batchNumber: batchNumController.text,
        expiryDate: expiryDateController.text,
        dateAdministered: dateAdministeredController.text,
        administeredBy: adminisiteredByController.text,
      );

      try {
        if (widget.immunization == null) {
          await _immunizationService.saveImmunization(immunization);
          _snackbarHelper.showSnackbar('Immunization saved successfully');
        } else {
          // Update existing immunization record
          immunization.id = widget.immunization!.id;
          await _immunizationService.updateImmunization(immunization);
          _snackbarHelper.showSnackbar('Immunization updated successfully');
        }
        widget.onImmunizationAddedOrUpdated?.call();
      } catch (e) {
        _snackbarHelper.showSnackbar('Failed to save immunization');
      }
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
                          margin: const EdgeInsets.all(0),
                          child: const Text(
                            'Immunization Record',
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
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name ',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter your Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: historyController,
                          decoration: const InputDecoration(
                            labelText: 'History ',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Medical History',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'History is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: vaccineNameController,
                          decoration: const InputDecoration(
                            labelText: 'Vaccine Name ',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter Vaccine Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vaccine Name is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: vaccinationBrandController,
                          decoration: const InputDecoration(
                            labelText: 'Vaccine Brand ',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter Vaccine Brand',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vaccine Brand is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: batchNumController,
                                decoration: const InputDecoration(
                                  labelText: 'Batch Number ',
                                  suffix: Text(
                                    '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  hintText: 'Enter batch number',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Batch Number is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            horizontalSpacing(10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _selectDate(context, expiryDateController),
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: expiryDateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Expiry Date ',
                                      suffix: Text(
                                        '*',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      hintText: 'Select Expiry Date',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Expiry Date is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalSpacing(12),
                        GestureDetector(
                          onTap: () =>
                              _selectDate(context, dateAdministeredController),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: dateAdministeredController,
                              decoration: const InputDecoration(
                                labelText: 'Date Administered ',
                                suffix: Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                                hintText: 'Select Date Administered',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date Administered is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: adminisiteredByController,
                          decoration: const InputDecoration(
                            labelText: 'Administered By ',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter nurse/doctor\'s name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Administered By is required';
                            }
                            return null;
                          },
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
                                backgroundColor:
                                    const Color(0xFFB4CD78), // White text color
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text('Close'),
                            ),
                            const SizedBox(width: 16.0),
                            TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Save form data or perform other actions
                                  _saveForm();
                                  Navigator.of(context).pop();
                                }
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
