import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  @override
  Widget build(BuildContext context) {
    getAppointment();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "APPOINTMENTS",
          style: appBarTitleStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 700,
              child: ValueListenableBuilder(
                valueListenable: appointmentListNotifier,
                builder: (BuildContext ctx,
                    List<AppointmentModel> appointmentList, Widget? child) {
                  return ListView.separated(
                      itemBuilder: ((context, index) {
                        final data = appointmentList[index];

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
                                    DateFormat('dd-MM-yyyy HH:mm')
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
                                  Text("${data.gender}"),
                                  Text("Email : ${data.email}"),
                                  Text("Mob:${data.mobile}"),
                                  Text('Address: ${data.address}'),
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
                                  icon: Icon(Icons.call),
                                ),
                                // Delete button
                                IconButton(
                                  onPressed: () {
                                    // Perform the delete action
                                    // deleteTelemedicine(data.id!);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      separatorBuilder: ((context, index) {
                        return const Divider();
                      }),
                      itemCount: appointmentList.length);
                },
              ),
            ),
          ],
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
}
