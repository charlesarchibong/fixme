import 'package:flutter/material.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/util/const.dart';

class JobDetails extends StatefulWidget {
  final Job job;
  final bool isOwner;

  JobDetails({
    Key key,
    @required this.job,
    @required this.isOwner,
  }) : super(
          key: key,
        );

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Job Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget jobDetails() {
    return Container();
  }

  Widget jobBidders() {
    return Container();
  }
}
