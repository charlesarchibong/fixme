import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/artisan/view/details.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/job/provider/my_request_provider.dart';
import 'package:quickfix/modules/job/provider/pending_job_provider.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/widgets/smooth_star_rating.dart';

class JobDetails extends StatefulWidget {
  final Job job;
  final bool isOwner;
  final int index;

  JobDetails({
    Key key,
    @required this.job,
    @required this.isOwner,
    this.index,
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
    if (widget.isOwner) {
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
              // SizedBox(height: 4.0),
              widget.isOwner
                  ? _jobBidders()
                  : RaisedButton(
                      child: Text(
                        'Bid for this Job',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Color.fromRGBO(153, 0, 153, 1),
                      onPressed: () {
                        bool loading = false;
                        final _formKey = GlobalKey<FormState>();
                        final _jobProvider = Provider.of<PendingJobProvider>(
                          context,
                          listen: false,
                        );
                        TextEditingController _amountController =
                            TextEditingController();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0)), //this right here
                                    child: Container(
                                      height: 400,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 9,
                                                right: 9,
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5.0),
                                                      ),
                                                    ),
                                                    child: Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          Card(
                                                            elevation: 4.0,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 5.0,
                                                                right: 5.0,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                autofillHints: [
                                                                  AutofillHints
                                                                      .transactionAmount
                                                                ],
                                                                controller:
                                                                    _amountController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                validator:
                                                                    (value) {
                                                                  return value ==
                                                                          ''
                                                                      ? 'Bidding price can not be empty'
                                                                      : null;
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Enter Bidding Pricing',
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  FlatButton(
                                                    child: loading
                                                        ? CircularProgressIndicator(
                                                            backgroundColor:
                                                                Colors.white,
                                                          )
                                                        : Text(
                                                            "Bid Job",
                                                          ),
                                                    padding: EdgeInsets.all(
                                                      10.0,
                                                    ),
                                                    textColor: Colors.white,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    onPressed: () async {
                                                      if (_formKey.currentState
                                                          .validate()) {
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        final bidJob =
                                                            await _jobProvider
                                                                .bidJob(
                                                          widget.job,
                                                          double.parse(
                                                            _amountController
                                                                .text,
                                                          ),
                                                        );
                                                        Navigator.of(context)
                                                            .pop();
                                                        bidJob.fold(
                                                            (Failure failure) {
                                                          FlushBarCustomHelper
                                                              .showErrorFlushbar(
                                                            context,
                                                            'Error',
                                                            failure.message,
                                                          );
                                                        }, (bool bidded) {
                                                          _jobProvider
                                                              .removeJobFromList(
                                                                  widget.index);
                                                          FlushBarCustomHelper
                                                              .showInfoFlushbar(
                                                            context,
                                                            'Success',
                                                            'You have bidded this job, kindly wait for response',
                                                          );
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      }),
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
                height: 10,
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
                            return Container(
                              margin: EdgeInsets.only(
                                bottom: 10.0,
                              ),
                              child: ListTile(
                                title: Row(
                                  children: <Widget>[
                                    Text(
                                      "${bids['bidder_info']['user_first_name']} ${bids['bidder_info']['user_last_name']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "(${bids['status'][0].toUpperCase()}${bids['status'].substring(1)})",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _getBidStatusColor(
                                          bids['status'],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                leading: CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage: NetworkImage(
                                    "${Constants.uploadUrl + bids['bidder_info']['profile_pic_file_name']}",
                                  ),
                                ),
                                trailing: jobDetailsPopButton(
                                  bidderMobile: bids['bidder_mobile'],
                                  bidId: bids['sn'],
                                  index: index,
                                ),
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
                                          borderColor: Constants.ratingBG,
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
                                      "Distance - ${bids['distance']}km",
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
                                            distance: bids['distance']);
                                      },
                                    ),
                                  );
                                },
                              ),
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

  Color _getBidStatusColor(String status) {
    if (status == 'pending') {
      return Colors.orange;
    } else if (status == 'accepted') {
      return Colors.green;
    } else {
      return Colors.red;
    }
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

  Widget jobDetailsPopButton({
    int bidId,
    String bidderMobile,
    int index,
  }) {
    final myRequestProvider = Provider.of<MyRequestProvider>(
      context,
      listen: false,
    );
    return PopupMenuButton(
      onSelected: (value) async {
        if (value == 1) {
          FlushBarCustomHelper.showInfoFlushbar(
            context,
            'Processing',
            'Approving this bid',
          );
          final approved = await myRequestProvider.approveBidder(
            bidId,
            bidderMobile,
          );
          approved.fold((Failure failure) {
            FlushBarCustomHelper.showErrorFlushbar(
              context,
              'Error',
              failure.message,
            );
          }, (bool approved) {
            FlushBarCustomHelper.showInfoFlushbar(
              context,
              'Success',
              'Bid has been approved successfully!',
            );
          });
        }
        if (value == 2) {
          FlushBarCustomHelper.showInfoFlushbar(
            context,
            'Processing',
            'Rejecting this bid',
          );
          final approved = await myRequestProvider.rejectBidder(
            bidId,
            bidderMobile,
          );
          approved.fold((Failure failure) {
            FlushBarCustomHelper.showErrorFlushbar(
              context,
              'Error',
              failure.message,
            );
          }, (bool approved) {
            FlushBarCustomHelper.showInfoFlushbar(
              context,
              'Success',
              'Bid has been rejected successfully!',
            );
            setState(() {
              biddersList.removeAt(index);
            });
          });
        }
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
              Text('Approve this bid'),
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
