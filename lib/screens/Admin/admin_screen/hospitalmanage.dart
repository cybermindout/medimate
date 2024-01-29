// ignore_for_file: unused_local_variable, prefer_const_constructors, await_only_futures, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medimate/screens/Admin/db/hospital_function.dart';
import 'package:medimate/screens/Admin/db/location_function.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';
import 'package:medimate/screens/Admin/model/location_model.dart';
import 'package:medimate/screens/Admin/model/special_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class HospitalManagePage extends StatefulWidget {
  const HospitalManagePage({Key? key});

  @override
  State<HospitalManagePage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalManagePage> {
  final _hospitalController = TextEditingController();
  final _editController = TextEditingController();

  File? _selectedImage;

  late Box<LocationModel> locBox;
  late Box<SpecialModel> specBox;

  List<LocationModel> location = [];
  List<SpecialModel> specialList = [];
  List<String> selectedSpecializations = [];

  String? selectedLocationName;

  @override
  void initState() {
    super.initState();
    initialFunctions();
  }

  void initialFunctions() async {
    locBox = await Hive.openBox<LocationModel>('loc_db');
    getHospitals();
    getLocations();
    getSpecializations();
    reload();
    openHiveBoxes();
  }

  void reload() {
    Future.delayed(Duration(milliseconds: 20), () {
      setState(() {});
    });
  }

  Future<void> addHospitalButton() async {
    final hos = _hospitalController.text.trim();
    final imagepath = _selectedImage!.path;
    if (hos.isEmpty) {
      return;
    } else {
      final hospital = HospitalModel(
        hos: hos,
        photo: imagepath,
        id: -1,
        loc: selectedLocationName ?? '',
        specialization:
            selectedSpecializations.join(','), // Join specializations
      );
      addHospital(hospital);
    }
  }

  Future<void> openHiveBoxes() async {
    locBox = await Hive.openBox<LocationModel>('loc_db');
    specBox = await Hive.openBox<SpecialModel>('spec_db');
    updateLists();
  }

  void updateLists() {
    setState(() {
      location = locBox.values.toList();
      specialList = specBox.values.toList();
      if (!location.any((loc) => loc.loc == selectedLocationName)) {
        selectedLocationName = null;
      }
    });
  }

  Future<void> getSpecializations() async {
    specBox = await Hive.openBox<SpecialModel>('spec_db');
    setState(() {
      specialList = specBox.values.toList();
      selectedSpecializations = specialList.map((spec) => spec.spec).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Container(
      padding: EdgeInsets.all(0.0),
      decoration: backBoxDecoration(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // appbar
          appBar: AppBar(
            title: Text("Hospital"),
            backgroundColor: Colors.transparent,
          ),

          // body
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: hospitalListNotifier.value.length,
                    itemBuilder: (context, index) {
                      final data = hospitalListNotifier.value[index];

                      return Card(
                        elevation: 3.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              image: FileImage(File(data.photo)),
                            ),
                            SizedBox(height: 5),
                            Text(
                              data.hos,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 0),
                            Text(
                              data.loc,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _editSheet(context, data.photo, data.hos,
                                        data.id!, selectedLocationName);
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteHospital(data.id!);
                                    _hospitalController.clear();
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _addSheet(context);
            },
            mini: true,
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  // to add section
  void _addSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // add photo
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: const Color.fromARGB(255, 18, 18, 18),
                              ),
                            ),
                            child: _selectedImage != null
                                ? Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.fill,
                                  )
                                : Center(child: Icon(Icons.add_a_photo)),
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                _pickImage().then((_) {
                                  setState(() {}); // Refresh the UI
                                });
                              },
                              icon: Icon(Icons.photo_library_outlined),
                              tooltip: "select from gallery",
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),

                    // hospital txt
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'cannot be empty';
                        }
                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return 'Only characters are allowed';
                        }
                        return null;
                      },
                      controller: _hospitalController,
                      decoration:
                          InputDecoration(hintText: "Enter Hospital Name"),
                    ),
                    SizedBox(height: 20),

                    // location dropdown
                    DropdownButtonFormField<String>(
                      validator: (value) {
                        if (value == null) {
                          return 'Select Location';
                        }
                        return null;
                      },
                      value: selectedLocationName,
                      items: location.map((LocationModel location) {
                        return DropdownMenuItem<String>(
                          value: location.loc,
                          child: Text(location.loc),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLocationName = newValue;
                        });
                      },
                      decoration: InputDecoration(hintText: "Select Location"),
                    ),

                    // specialization checkboxes
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: specialList.map((spec) {
                        return CheckboxListTile(
                          title: Text(spec.spec),
                          value: selectedSpecializations.contains(spec.spec),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) {
                                if (value) {
                                  selectedSpecializations.add(spec.spec);
                                } else {
                                  selectedSpecializations.remove(spec.spec);
                                }
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    // button
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        addHospitalButton();
                        _hospitalController.clear();
                        reload();

                        Navigator.pop(context);
                      },
                      child: Text("Add"),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _editSheet(BuildContext context, String photo, String hospital, int id,
      String? selectedLocationName) {
    _editController.text = hospital;
    _selectedImage = File(photo);

    List<String> initialSpecializations = hospitalListNotifier.value
        .firstWhere((element) => element.id == id)
        .specialization
        .split(',');

    List<String> selectedSpecializations = List.from(initialSpecializations);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // edit photo
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: const Color.fromARGB(255, 18, 18, 18),
                              ),
                            ),
                            child: _selectedImage != null
                                ? Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.fill,
                                  )
                                : Center(child: Icon(Icons.add_a_photo)),
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                _pickImage().then((_) {
                                  setState(() {}); // Refresh the UI
                                });
                              },
                              icon: Icon(Icons.photo_library_outlined),
                              tooltip: "select from gallery",
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),

                    // special txt
                    TextFormField(
                      controller: _editController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: "Edit Hospital",
                      ),
                    ),
                    SizedBox(height: 25),

                    DropdownButtonFormField<String>(
                      validator: (value) {
                        if (value == null) {
                          return "select location";
                        }
                        return null;
                      },
                      value: selectedLocationName,
                      items: location.map((LocationModel location) {
                        return DropdownMenuItem<String>(
                          value: location.loc,
                          child: Text(location.loc),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLocationName = newValue;
                        });
                      },
                      decoration: InputDecoration(hintText: "Select Location"),
                    ),

                    // specialization checkboxes
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: specialList.map((spec) {
                        return CheckboxListTile(
                          title: Text(spec.spec),
                          value: selectedSpecializations.contains(spec.spec),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) {
                                if (value) {
                                  selectedSpecializations.add(spec.spec);
                                } else {
                                  selectedSpecializations.remove(spec.spec);
                                }
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 25),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.green[400]),
                      ),
                      onPressed: () {
                        String joinedSpecializations =
                            selectedSpecializations.join(',');

                        editHospital(
                          id,
                          _editController.text,
                          _selectedImage!.path,
                          selectedLocationName.toString(),
                          joinedSpecializations,
                        );
                        _hospitalController.clear();
                        Navigator.pop(context);
                      },
                      child: Text("Save"),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // image from photos
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }
}
