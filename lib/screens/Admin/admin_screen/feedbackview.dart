import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:medimate/screens/Admin/db/feedback_function.dart';
import 'package:medimate/screens/Admin/model/feedback_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class FeedbackViewPage extends StatefulWidget {
  const FeedbackViewPage({super.key});

  @override
  State<FeedbackViewPage> createState() => _FeedbackViewPageState();
}

class _FeedbackViewPageState extends State<FeedbackViewPage> {
  @override
  Widget build(BuildContext context) {
    //to view feedbacks
    getFeedbacks();

    return Container(
      decoration: backBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "FEEDBACKS",
            style: appBarTitleStyle(),
          ),
        ),

        //body
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 690,
                child: ValueListenableBuilder(
                  valueListenable: feedbackListener,
                  builder: (BuildContext ctx, List<FeedBackModel> feedbackList,
                      Widget? child) {
                    return ListView.separated(
                        itemBuilder: ((context, index) {
                          final data = feedbackList[index];

                          return Slidable(
                            endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  //delete
                                  SlidableAction(
                                    onPressed: (context) {
                                      deleteFeedbacks(data.id!);
                                    },
                                    icon: Icons.delete,
                                    backgroundColor:
                                        const Color.fromARGB(255, 248, 3, 3),
                                  ),
                                ]),
                            child: Container(
                              child: ListTile(
                                horizontalTitleGap: 20,
                                contentPadding: EdgeInsets.all(5),
                                leading: Text("   ${index + 1}"),
                                title: InkWell(
                                    onTap: () {},
                                    child: Text(
                                      data.title,
                                      style: titleStyle(),
                                    )),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.date,
                                      style: dateTextStyle(),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      data.content,
                                      style: contentTextStyle(),
                                    )
                                  ],
                                ),
                                //trailing: Text(data.date),
                              ),
                            ),
                          );
                        }),
                        separatorBuilder: ((context, index) {
                          return const Divider();
                        }),
                        itemCount: feedbackList.length);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle contentTextStyle() => TextStyle(fontWeight: FontWeight.w500);

  TextStyle dateTextStyle() => TextStyle();

//title text style
  TextStyle titleStyle() =>
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 18);
}
