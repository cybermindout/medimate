// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medimate/screens/Admin/db/doctorfunction.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';

class DoctorSearchDelegate extends SearchDelegate<DoctorModel> {
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
    final List<DoctorModel> doctorList = doctorListNotifier.value;

    final filteredDoctors = query.isEmpty
        ? doctorList
        : doctorList
            .where(
              (doctor) =>
                  doctor.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.separated(
      itemBuilder: (context, index) {
        final data = filteredDoctors[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: FileImage(File(data.photo)),
          ),
          title: Text("Dr. ${data.name}"),
          onTap: () {
            close(context, data);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: filteredDoctors.length,
    );
  }
}
