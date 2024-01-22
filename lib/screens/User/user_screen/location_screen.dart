// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medimate/screens/Admin/db/location_function.dart';
import 'package:medimate/screens/Admin/model/location_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/User/user_screen/location_search.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      decoration: backBoxDecoration(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "Location",
              style: appBarTitleStyle(),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: LocationSearchDelegate());
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    // Listing locations
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 580,
                        child: ValueListenableBuilder(
                          valueListenable: locListNotifier,
                          builder: (BuildContext ctx,
                              List<LocationModel> locationList, Widget? child) {
                            final filteredLocations = _searchController
                                    .text.isEmpty
                                ? locationList
                                : locationList
                                    .where((location) => location.loc
                                        .toLowerCase()
                                        .contains(_searchController.text
                                            .toLowerCase()))
                                    .toList();

                            if (locationList.isEmpty) {
                              return Center(
                                child: Text(
                                  "Will be updated soon",
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: const Color.fromARGB(
                                        255, 195, 195, 195),
                                  ),
                                ),
                              );
                            }

                            return ListView.separated(
                              itemBuilder: ((context, index) {
                                final data = locationList[index];
                                return Container(
                                  decoration: locationDecoration(),
                                  child: ListTile(
                                    horizontalTitleGap: 20,
                                    contentPadding: EdgeInsets.all(5),
                                    title: Align(
                                      child: Column(
                                        children: [
                                          Text(
                                            data.loc,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              separatorBuilder: (context, index) => SizedBox(
                                  height: 10), // Add space between items
                              itemCount: filteredLocations.length,
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
