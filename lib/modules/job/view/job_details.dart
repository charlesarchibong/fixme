import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/artisan/view/details.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/job/provider/my_request_provider.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/widgets/smooth_star_rating.dart';

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
  List biddersList = List();
  String error = '';
  bool loading = true;
  Future<void> getBidders() async {
    final myRequestProvider = Provider.of<MyRequestProvider>(
      context,
      listen: false,
    );
    final gotten = await myRequestProvider.getJobBidders(widget.job);
    gotten.fold((Failure failure) {
      setState(() {
        loading = false;
        error = failure.message;
      });
      FlushBarCustomHelper.showErrorFlushbar(
        context,
        'Error',
        failure.message,
      );
    }, (List bidders) {
      print(bidders.toString());
      setState(() {
        loading = false;
        biddersList = bidders;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getBidders();
    super.initState();
  }

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
      body: SingleChildScrollView(
        child: Padding(
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
    return loading
        ? CircularProgressIndicator()
        : Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Job Bidders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              biddersList != null && biddersList.length > 0
                  ? RefreshIndicator(
                      onRefresh: () => getBidders(),
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              biddersList == null ? 0 : biddersList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map bids = biddersList[index];
                            return ListTile(
                              title: Text(
                                "${bids['bidder_info']['user_first_name']} ${bids['bidder_info']['user_last_name']}",
                                style: TextStyle(
//                    fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              leading: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(
                                  "${Constants.uploadUrl + bids['bidder_info']['profile_pic_file_name']}",
                                ),
                              ),
                              trailing: jobDetailsPopButton(),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      SmoothStarRating(
                                        starCount: 1,
                                        color: Constants.ratingBG,
                                        allowHalfRating: true,
                                        rating: 5.0,
                                        size: 12.0,
                                      ),
                                      SizedBox(width: 6.0),
                                      Text(
                                        "5.0 (${bids['bidder_info']['reviews']} Reviews)",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6.0),
                                  Text(
                                    "Bid Price - N${bids['bidding_price']}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6.0),
                                  Text(
                                    "Distance - ${bids['bidder_info']['distance']}km",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ProductDetails(
                                        userData: bids['bidder_info'],
                                        distance: bids['bidder_info']
                                            ['distance'],
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    )
                  : Text(
                      'No Artisan has bid this job yet!',
                    )
            ],
          );
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

  Widget jobDetailsPopButton() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {}
        if (value == 2) {}
      },
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.check,
                color: Colors.green,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text('Accept'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text('Decline'),
            ],
          ),
        ),
      ],
    );
  }
}
