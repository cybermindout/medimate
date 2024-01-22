// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medimate/screens/Admin/db/special_function.dart';
import 'package:medimate/screens/Admin/model/special_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class SpecialPage extends StatefulWidget {
  const SpecialPage({super.key});

  @override
  State<SpecialPage> createState() => _SpecialPageState();
}

class _SpecialPageState extends State<SpecialPage> {
  final _specialController = TextEditingController();
  final _editController = TextEditingController();

  File? _selectedImage;

  // to add special
  Future<void> addSpecialButton() async {
    final _spec = _specialController.text.trim();
    final imagepath = _selectedImage!.path;
    if (_spec.isEmpty) {
      return;
    } else {
      final _special = SpecialModel(spec: _spec, photo: imagepath, id: -1);
      addspecial(_special);
    }
  }

  @override
  void initState() {
    super.initState();
    getspecial();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});

    return Container(
      decoration: backBoxDecoration(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // appbar
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text("Specializations", style: appBarTitleStyle()),
          ),

          // body
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ValueListenableBuilder(
              valueListenable: specListNotifier,
              builder: (BuildContext ctx, List<SpecialModel> specialList,
                  Widget? child) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: specialList.length,
                  itemBuilder: (context, index) {
                    final data = specialList[index];

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
                            data.spec,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _editSheet(
                                      context, data.photo, data.spec, data.id!);
                                },
                                icon: Icon(Icons.edit, color: Colors.blue),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showDeleteConfirmationDialog(data.id!);
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
                );
              },
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
                            _pickImage();
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'cannot be empty';
                    }
                    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return 'Only characters are allowed';
                    }
                    return null;
                  },
                  controller: _specialController,
                  decoration: InputDecoration(hintText: "Enter specialization"),
                ),
                SizedBox(height: 20),

                // button
                ElevatedButton(
                  onPressed: () {
                    addSpecialButton();
                    _specialController.clear();
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
  }

  void _editSheet(BuildContext context, String photo, String special, int id) {
    _editController.text = special;
    _selectedImage = File(photo);

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                            _pickImage();
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
                    hintText: "Edit Specialization",
                  ),
                ),
                SizedBox(height: 25),

                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.green[400])),
                  onPressed: () {
                    editspecial(id, _editController.text, _selectedImage!.path);
                    _specialController.clear();
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

  //dialog before deleting
  Future<void> _showDeleteConfirmationDialog(int id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Specialization"),
          content: Text("Are you sure you want to delete this specialization?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deletespec(id);
                getspecial();
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
