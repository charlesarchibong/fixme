import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/artisan/model/service_request.dart';
import 'package:quickfix/modules/artisan/provider/artisan_provider.dart';
import 'package:quickfix/modules/artisan/widget/my_service_request.dart';
import 'package:quickfix/util/const.dart';

class MyServiceRequests extends StatefulWidget {
  MyServiceRequests({Key key}) : super(key: key);

  @override
  _MyServiceRequestsState createState() => _MyServiceRequestsState();
}

class _MyServiceRequestsState extends State<MyServiceRequests> {
  bool isLoading = false;
  String error = '';
  List<ServiceRequest> servicesRequests = List();

  void _getServiceRequests() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final artisanProvider = Provider.of<ArtisanProvider>(
      context,
      listen: false,
    );

    final reqs = await artisanProvider.getRequests();

    reqs.fold((Failure failure) {
      Logger().i(failure);
      if (mounted) {
        setState(() {
          isLoading = false;
          error = failure.message;
        });
      }
    }, (List<ServiceRequest> jobs) {
      Logger().i(jobs.toString());
      if (mounted) {
        setState(() {
          isLoading = false;
          servicesRequests = jobs;
        });
        Logger().i(servicesRequests.length);
      }
    });
  }

  @override
  void initState() {
    _getServiceRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Requests from Users',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: isLoading == false
                  ? error.isNotEmpty
                      ? Center(
                          child: Text(
                            '$error',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () {
                            _getServiceRequests();
                            return Future.value();
                          },
                          child: ListView.builder(
                            itemCount: servicesRequests.length == null
                                ? 0
                                : servicesRequests.length,
                            itemBuilder: (BuildContext context, int index) {
                              ServiceRequest serviceRequest =
                                  servicesRequests[index];

                              return MyServiceRequestWidget(
                                title: serviceRequest.requestingMobile,
                                subtitle: 'Please confirm availability',
                                status: serviceRequest.status,
                                job: serviceRequest,
                                datePosted: serviceRequest.dateRequested,
                              );
                            },
                          ),
                        )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            )
          ],
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
}
