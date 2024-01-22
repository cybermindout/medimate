// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:medimate/screens/Admin/db/location_function.dart';
import 'package:medimate/screens/Admin/model/location_model.dart';

class LocationSearchDelegate extends SearchDelegate<LocationModel> {
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
    final List<LocationModel> locationList = locListNotifier.value;

    final filteredlocations = query.isEmpty
        ? locationList
        : locationList
            .where(
              (location) =>
                  location.loc.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.separated(
      itemBuilder: (context, index) {
        final data = filteredlocations[index];
        return ListTile(
          title: Text(data.loc),
          onTap: () {
            close(context, data);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: filteredlocations.length,
    );
  }
}
