import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medimate/screens/Admin/db/hospital_function.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart'; 

class HospitalSearchDelegate extends SearchDelegate<HospitalModel> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final List<HospitalModel> hospitalList = hospitalListNotifier.value;

    final filteredHospitals = query.isEmpty
        ? hospitalList
        : hospitalList
            .where(
              (hospital) =>
                  hospital.hos.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.separated(
      itemBuilder: (context, index) {
        final data = filteredHospitals[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: FileImage(File(data.photo)),
          ),
          title: Text(data.hos),
          onTap: () {
            close(context, data);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: filteredHospitals.length,
    );
  }
}