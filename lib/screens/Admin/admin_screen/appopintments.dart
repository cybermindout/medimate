// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medimate/screens/Admin/db/appointment_functions.dart';
import 'package:medimate/screens/Admin/model/appoinment_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentViewPage extends StatefulWidget {
  const AppointmentViewPage({super.key});

  @override
  State<AppointmentViewPage> createState() => _AppointmentViewPageState();
}

class _AppointmentViewPageState extends State<AppointmentViewPage> {
  DateTime? selectedDateTime;

  Future<void> _showDeleteConfirmationDialog(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Appointment"),
          content: Text("Are you sure you want to delete this appointment?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteAppointment(id);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getAppointment();
    return Container(
      decoration: backBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "APPOINTMENTS",
            style: appBarTitleStyle(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Date filter buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text("Filter by Date"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _clearDateFilter();
                    },
                    child: Text("View All Dates"),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 700,
                child: ValueListenableBuilder(
                  valueListenable: appointmentListNotifier,
                  builder: (BuildContext ctx,
                      List<AppointmentModel> appointmentList, Widget? child) {
                    // Filter appointments based on selectedDateTime
                    List<AppointmentModel> filteredList = appointmentList
                        .where((appointment) =>
                            selectedDateTime == null ||
                            appointment.date.isAfter(selectedDateTime!))
                        .toList();

                    return ListView.separated(
                      itemBuilder: ((context, index) {
                        final data = filteredList[index];

                        return Container(
                          child: ListTile(
                            horizontalTitleGap: 20,
                            contentPadding: EdgeInsets.all(5),
                            leading: Text("   ${index + 1}"),
                            title: InkWell(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('EEE dd-MM-yyyy h:mm a')
                                        .format(data.date),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${data.description} ${data.name} ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Text("Gender:${data.gender}"),
                                  Text("Email : ${data.email}"),
                                  Text("Mob:${data.mobile}"),
                                  Text('Address: ${data.address}'),
                                  Text('Location: ${data.location}'),
                                  Text('Hosital: ${data.hospital}'),
                                  Text('Doctor: ${data.doctor}'),
                                  Text('Date: ${data.booktime}'),
                                ],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text('Booked by: ${data.user} / ${data.email}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Call button
                                IconButton(
                                  onPressed: () {
                                    _launchDialer(data.mobile);
                                  },
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.green,
                                  ),
                                ),

                                // Delete button
                                IconButton(
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(data.id!);
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      separatorBuilder: ((context, index) {
                        return const Divider();
                      }),
                      itemCount: filteredList.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //launch dialer
  void _launchDialer(String phoneNumber) async {
    Uri phoneno = Uri.parse('tel:+91$phoneNumber');
    if (await launchUrl(phoneno)) {
      //dialer opened
    } else {
      SnackBar(content: Text("couldn't launch dialer"));
    }
  }

  // Date filter function
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDateTime) {
      setState(() {
        selectedDateTime = pickedDate;
      });
    }
  }

  // Clear date filter function
  void _clearDateFilter() {
    setState(() {
      selectedDateTime = null;
    });
  }
}
