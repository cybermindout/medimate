// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medimate/screens/Admin/db/special_function.dart';
import 'package:medimate/screens/Admin/model/special_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/User/user_screen/specialization_search.dart';

class SpecializationPage extends StatefulWidget {
  const SpecializationPage({super.key});

  @override
  State<SpecializationPage> createState() => _SpecializationPageState();
}

class _SpecializationPageState extends State<SpecializationPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getspecial();
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
                  "Specialization",
                  style: appBarTitleStyle(),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: SpecializationSearchDelegate());
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
                        //listing specialization
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 580,
                            child: ValueListenableBuilder(
                              valueListenable: specListNotifier,
                              builder: (BuildContext ctx,
                                  List<SpecialModel> specialList,
                                  Widget? child) {
                                // Search part
                                final filteredspecials =
                                    _searchController.text.isEmpty
                                        ? specialList
                                        : specialList
                                            .where((spec) => spec.spec
                                                .toLowerCase()
                                                .contains(_searchController.text
                                                    .toLowerCase()))
                                            .toList();

                                if (specialList.isEmpty) {
                                  return Center(
                                    child: Text(
                                      "Will be updated soon",
                                      style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: const Color.fromARGB(
                                              255, 195, 195, 195)),
                                    ),
                                  );
                                }

                                return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  itemBuilder: ((context, index) {
                                    final data = specialList[index];
                                    return Container(
                                      decoration: backBoxDecoration(),
                                      child: ListTile(
                                        horizontalTitleGap: 20,
                                        contentPadding: EdgeInsets.all(5),
                                        title: Align(
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 50,
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage: FileImage(
                                                  File(data.photo),
                                                ),
                                              ),
                                              Text(
                                                data.spec,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color.fromARGB(
                                                        255, 0, 0, 0)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  itemCount: filteredspecials.length,
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ));
  }
}
