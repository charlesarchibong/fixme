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
            Center(
              child: Image.asset(
                'assets/job_details.png',
                width: 250,
              ),
            ),
            _jobDetails(),
            SizedBox(height: 10.0),
            widget.isOwner ? _jobBidders() : Text(''),
          ],
        ),
      ),
    );
  }

  Widget _jobDetails() {
    return Column(
      children: <Widget>[
        _jobListTile(
          'Job Title',
          widget.job.jobTitle,
        ),
        _jobListTile(
          'Job Description',
          widget.job.description,
        ),
        _jobListTile(
          'Job Budget',
          'N${widget.job.price.toString()}',
        ),
        _jobListTile(
          'Job Status',
          widget.job.status,
        ),
        // _jobListTile('Job Status', widget.job.,),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _jobBidders() {
    return Container();
  }

  Widget _jobListTile(String title, String subTitle) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subTitle,
      ),
    );
  }

  Widget _jobBiddersListTile() {}
}
