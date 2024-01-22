// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:medimate/screens/Admin/db/location_function.dart';
import 'package:medimate/screens/Admin/model/location_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class LocationManagePage extends StatefulWidget {
  const LocationManagePage({Key? key}) : super(key: key);

  @override
  State<LocationManagePage> createState() => _LocationManagePageState();
}

class _LocationManagePageState extends State<LocationManagePage> {
  final _locationController = TextEditingController();
  final _editController = TextEditingController();

  // to add location
  Future<void> addLocationButton() async {
    final _loc = _locationController.text.trim();
    if (_loc.isEmpty) {
      return;
    } else {
      final _location = LocationModel(loc: _loc, id: -1);
      addLocation(_location);
    }
  }

  // Function to show a confirmation dialog before deleting
  Future<void> _showDeleteConfirmationDialog(int id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Location"),
          content: Text("Are you sure you want to delete this location?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteLocation(id);
                getLocations();
                Navigator.of(context).pop(); 
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backBoxDecoration(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // appbar
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text("Locations", style: appBarTitleStyle()),
          ),

          // body
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ValueListenableBuilder(
              valueListenable: locListNotifier,
              builder: (BuildContext ctx, List<LocationModel> locationList,
                  Widget? child) {
                return ListView.builder(
                  itemCount: locationList.length,
                  itemBuilder: (context, index) {
                    final data = locationList[index];

                    return Card(
                      elevation: 3.0,
                      child: ListTile(
                        title: Text(
                          data.loc,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _editSheet(context, data.loc, data.id!);
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
                // location txt
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
                  controller: _locationController,
                  decoration: InputDecoration(hintText: "Enter location"),
                ),
                SizedBox(height: 20),

                // button
                ElevatedButton(
                  onPressed: () {
                    addLocationButton();
                    _locationController.clear();
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

  void _editSheet(BuildContext context, String location, int id) {
    _editController.text = location;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // location txt
                TextFormField(
                  controller: _editController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Edit Location",
                  ),
                ),
                SizedBox(height: 25),

                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.green[400])),
                  onPressed: () {
                    editLocation(id, _editController.text, location);
                    _locationController.clear();
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
}
