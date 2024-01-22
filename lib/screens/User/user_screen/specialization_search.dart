// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medimate/screens/Admin/db/special_function.dart';
import 'package:medimate/screens/Admin/model/special_model.dart';

class SpecializationSearchDelegate extends SearchDelegate<SpecialModel> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions to display at the top right (e.g., a clear button).
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
    // Leading widget (usually a back button).
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Build and return the search results based on the query.
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Build and return search suggestions based on the query.
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final List<SpecialModel> hospitalList = specListNotifier.value;

    final filteredSpecialization = query.isEmpty
        ? hospitalList
        : hospitalList
            .where(
                (spec) => spec.spec.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.separated(
      itemBuilder: (context, index) {
        final data = filteredSpecialization[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: FileImage(File(data.photo)),
          ),
          title: Text(data.spec),
          onTap: () {
            // You can handle what happens when a suggestion is tapped.
            close(context, data);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: filteredSpecialization.length,
    );
  }
}
