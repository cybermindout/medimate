import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medimate/screens/Admin/db/appointment_functions.dart';
import 'package:medimate/screens/Admin/model/appoinment_model.dart';
import 'package:medimate/screens/Guest/guest_screen/login_screen.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/User/user_screen/appointments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({super.key});

  @override
  State<MyAppointments> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  @override
  void initState() {
    super.initState();
    getUser();
  }

  String userEmail = '';

  UserModel? currentUser;

  int age = 0;

//to get logged in user
  Future<void> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('currentUser') ?? '';

    final userBox = await Hive.openBox<UserModel>('user_db');
    currentUser = userBox.values.firstWhere(
      (user) => user.email == userEmail,
    );

    prefs.setString('userName', currentUser?.fullname ?? '');

//getting appointment details
    getUserAppointment(currentUser!.fullname);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backBoxDecoration(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "MY APPOINTMENTS",
              style: appBarTitleStyle(),
            ),
          ),
          body: currentUser != null
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 700,
                        child: ValueListenableBuilder(
                          valueListenable: userAppointmentListNotifier,
                          builder: (BuildContext ctx,
                              List<AppointmentModel> userAppointmentList,
                              Widget? child) {
                            if (userAppointmentList.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "No appointments made",
                                      style: GoogleFonts.play(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: Colors.grey),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BookAppointment(),
                                              ));
                                        },
                                        child: Text("Book appointment"))
                                  ],
                                ),
                              );
                            }

                            return ListView.separated(
                                itemBuilder: ((context, index) {
                                  final data = userAppointmentList[index];

                                  return Container(
                                    child: ListTile(
                                      horizontalTitleGap: 20,
                                      contentPadding: EdgeInsets.all(5),
                                      leading: Text("   ${index + 1}"),
                                      title: InkWell(
                                          onTap: () {},
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                DateFormat('dd-MM-yyyy HH:mm')
                                                    .format(data.date),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${data.description} ${data.name} ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Text(
                                                  "Email : ${data.email}, Mob:${data.mobile}"),
                                              Text("Gender:${data.gender}"),
                                              Text("Hospital:${data.hospital}"),
                                              Text("Docotr:${data.doctor}")
                                            ],
                                          )),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          //Text('Date: ${data.mobile}'),
                                          Text('Address: ${data.address}'),
                                          // Text('booked by: ${data.user}'),
                                          //Text('Mobile: ${data.mobile}'),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                separatorBuilder: ((context, index) {
                                  return const Divider();
                                }),
                                itemCount: userAppointmentList.length);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        Text("USER NOT LOGGED IN"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ));
                            },
                            child: Text("PROCEED TO LOGIN"))
                      ],
                    ),
                  ),
                )),
    );
  }
}
