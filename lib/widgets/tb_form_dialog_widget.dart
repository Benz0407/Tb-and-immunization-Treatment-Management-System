import 'package:flutter/material.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/tb_model.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/services/tb_service.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/date_selection.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/notification.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/utils/spaces.dart';

class TbFormDialogWidget extends StatefulWidget {
  final Tuberculosis? tuberculosis;
  final VoidCallback? onTbAddedOrUpdated;
  const TbFormDialogWidget(
      {super.key,
      this.tuberculosis,
      required this.onTbAddedOrUpdated});

  @override
  TbFormDialogWidgetState createState() => TbFormDialogWidgetState();
}

class TbFormDialogWidgetState extends State<TbFormDialogWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TbService _tbService = TbService();
  late SnackbarHelper _snackbarHelper;

  TextEditingController nameController = TextEditingController();
  TextEditingController tbBrandController = TextEditingController();
  TextEditingController batchNumController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController dateAdministeredController = TextEditingController();
  TextEditingController administeredByController = TextEditingController();
  TextEditingController tbDiagnosisDateController = TextEditingController();
  TextEditingController tbTypeController = TextEditingController();
  TextEditingController treatmentStartDateController = TextEditingController();
  TextEditingController medicinePrescribedController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TextEditingController treatmentCompletionDateController = TextEditingController();
  TextEditingController diagnosticTestConductedController = TextEditingController();
  TextEditingController diagnosticTestResultController = TextEditingController();
  TextEditingController vaccinationHistoryController = TextEditingController();
  TextEditingController treatmentOutcomeController = TextEditingController();
  TextEditingController followupDateController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  String? diagnosticTestResult;

  @override
  void initState() {
    super.initState();
    _snackbarHelper = SnackbarHelper(context);
    if (widget.tuberculosis != null) {
      _populateFields(widget.tuberculosis!);
    }
  }

  void _populateFields(Tuberculosis tuberculosis) {
    nameController.text = tuberculosis.name;
    tbBrandController.text = tuberculosis.tbBrand;
    batchNumController.text = tuberculosis.batchNumber;
    expiryDateController.text = tuberculosis.expiryDate;
    dateAdministeredController.text = tuberculosis.dateAdministered;
    administeredByController.text = tuberculosis.administeredBy;
    tbDiagnosisDateController.text = tuberculosis.tbDiagnosisDate;
    tbTypeController.text = tuberculosis.tbType;
    treatmentStartDateController.text = tuberculosis.treatmentStartDate;
    medicinePrescribedController.text = tuberculosis.medicinePrescribed;
    dosageController.text = tuberculosis.dosage;
    frequencyController.text = tuberculosis.frequency;
    treatmentCompletionDateController.text = tuberculosis.treatmentCompletionDate;
    diagnosticTestConductedController.text = tuberculosis.diagnosticTestConducted;
    diagnosticTestResult = tuberculosis.diagnosticTestResult;
    vaccinationHistoryController.text = tuberculosis.vaccinationHistory;
    treatmentOutcomeController.text = tuberculosis.treatmentOutcome;
    followupDateController.text = tuberculosis.followupDate;
    notesController.text = tuberculosis.notes;
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
      Tuberculosis tuberculosis = Tuberculosis(
        name: nameController.text,
        tbBrand: tbBrandController.text,
        batchNumber: batchNumController.text,
        expiryDate: expiryDateController.text,
        dateAdministered: dateAdministeredController.text,
        administeredBy: administeredByController.text,
        tbDiagnosisDate: tbDiagnosisDateController.text,
        tbType: tbTypeController.text,
        treatmentStartDate: treatmentStartDateController.text,
        medicinePrescribed: medicinePrescribedController.text,
        dosage: dosageController.text,
        frequency: frequencyController.text,
        treatmentCompletionDate: treatmentCompletionDateController.text,
        diagnosticTestConducted: diagnosticTestConductedController.text,
        diagnosticTestResult: diagnosticTestResult!,
        vaccinationHistory: vaccinationHistoryController.text,
        treatmentOutcome: treatmentOutcomeController.text,
        followupDate: followupDateController.text,
        notes: notesController.text,
      );

      try {
        if (widget.tuberculosis == null) {
          await _tbService.saveTuberculosis(tuberculosis);
          _snackbarHelper.showSnackbar('Tuberculosis record saved successfully');
        } else {
          // Update existing tuberculosis record
          tuberculosis.id = widget.tuberculosis!.id;
          await _tbService.updateTuberculosis(tuberculosis);
          _snackbarHelper.showSnackbar('Tuberculosis record updated successfully');
        }
        widget.onTbAddedOrUpdated?.call();
      } catch (e) {
        _snackbarHelper.showSnackbar('Failed to save tuberculosis record');
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
                            'Tuberculosis Record',
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
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
                          controller: tbBrandController,
                          decoration: const InputDecoration(
                            labelText: 'TB Brand',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter TB Brand',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'TB Brand is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: batchNumController,
                          decoration: const InputDecoration(
                            labelText: 'Batch Number',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter Batch Number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Batch Number is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        GestureDetector(
                          onTap: () => _selectDate(context, expiryDateController),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: expiryDateController,
                              decoration: const InputDecoration(
                                labelText: 'Expiry Date',
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
                        verticalSpacing(12),
                        GestureDetector(
                          onTap: () => _selectDate(context, dateAdministeredController),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: dateAdministeredController,
                              decoration: const InputDecoration(
                                labelText: 'Date Administered',
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
                          controller: administeredByController,
                          decoration: const InputDecoration(
                            labelText: 'Administered By',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter Administered By',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Administered By is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        GestureDetector(
                          onTap: () => _selectDate(context, tbDiagnosisDateController),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: tbDiagnosisDateController,
                              decoration: const InputDecoration(
                                labelText: 'TB Diagnosis Date',
                                suffix: Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                                hintText: 'Select TB Diagnosis Date',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'TB Diagnosis Date is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: tbTypeController,
                          decoration: const InputDecoration(
                            labelText: 'TB Type',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter TB Type',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'TB Type is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        GestureDetector(
                          onTap: () => _selectDate(context, treatmentStartDateController),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: treatmentStartDateController,
                              decoration: const InputDecoration(
                                labelText: 'Treatment Start Date',
                                suffix: Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                                hintText: 'Select Treatment Start Date',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Treatment Start Date is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: medicinePrescribedController,
                          decoration: const InputDecoration(
                            labelText: 'Medicine Prescribed',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter Medicine Prescribed',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Medicine Prescribed is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: dosageController,
                          decoration: const InputDecoration(
                            labelText: 'Dosage',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter Dosage',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Dosage is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: frequencyController,
                          decoration: const InputDecoration(
                            labelText: 'Frequency',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter Frequency',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Frequency is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        GestureDetector(
                          onTap: () => _selectDate(context, treatmentCompletionDateController),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: treatmentCompletionDateController,
                              decoration: const InputDecoration(
                                labelText: 'Treatment Completion Date',
                                suffix: Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                                hintText: 'Select Treatment Completion Date',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Treatment Completion Date is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: diagnosticTestConductedController,
                          decoration: const InputDecoration(
                            labelText: 'Diagnostic Test Conducted',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter Diagnostic Test Conducted',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Diagnostic Test Conducted is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        const Text(
                          'Diagnostic Test Result',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        RadioListTile<String>(
                          title: const Text('Positive'),
                          value: 'Positive',
                          groupValue: diagnosticTestResult,
                          onChanged: (value) {
                            setState(() {
                              diagnosticTestResult = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Negative'),
                          value: 'Negative',
                          groupValue: diagnosticTestResult,
                          onChanged: (value) {
                            setState(() {
                              diagnosticTestResult = value;
                            });
                          },
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: vaccinationHistoryController,
                          decoration: const InputDecoration(
                            labelText: 'Vaccination History',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter Vaccination History',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vaccination History is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: treatmentOutcomeController,
                          decoration: const InputDecoration(
                            labelText: 'Treatment Outcome',
                            suffix: Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            hintText: 'Enter Treatment Outcome',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Treatment Outcome is required';
                            }
                            return null;
                          },
                        ),
                        verticalSpacing(12),
                        GestureDetector(
                          onTap: () => _selectDate(context, followupDateController),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: followupDateController,
                              decoration: const InputDecoration(
                                labelText: 'Follow-up Date',
                                suffix: Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                                hintText: 'Select Follow-up Date',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Follow-up Date is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        verticalSpacing(12),
                        TextFormField(
                          controller: notesController,
                          decoration: const InputDecoration(
                            labelText: 'Notes',
                            hintText: 'Enter any additional notes',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        verticalSpacing(12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFC1D986),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Save form data or perform other actions
                                  _saveForm();
                                  Navigator.of(context).pop();
                                }
                              },
                                child: const Text(
                                  'Save',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
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
