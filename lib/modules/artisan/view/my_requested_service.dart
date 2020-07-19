import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/artisan/model/service_request.dart';
import 'package:quickfix/modules/artisan/provider/artisan_provider.dart';
import 'package:quickfix/modules/artisan/widget/my_requested_service.dart';
import 'package:quickfix/util/const.dart';

class MyRequestedService extends StatefulWidget {
  MyRequestedService({Key key}) : super(key: key);

  @override
  _MyRequestedServiceState createState() => _MyRequestedServiceState();
}

class _MyRequestedServiceState extends State<MyRequestedService> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<RequestArtisanService>(
        builder: (context, requestArtisanService, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'My Requested Service',
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
                child: FutureBuilder(
                  future: requestArtisanService.getMyRequestedService(),
                  builder: (BuildContext context, AsyncSnapshot myService) {
                    if (myService.hasData) {
                      return myService.data.fold((Failure failure) {
                        return Center(
                          child: Text(
                            '${failure.message}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }, (List<ServiceRequest> jobs) {
                        return RefreshIndicator(
                          onRefresh: () {
                            requestArtisanService.getRequests();
                            return Future.value();
                          },
                          child: ListView.builder(
                            itemCount: requestArtisanService
                                        .serviceRequests.length ==
                                    null
                                ? 0
                                : requestArtisanService.serviceRequests.length,
                            itemBuilder: (BuildContext context, int index) {
                              ServiceRequest serviceRequest =
                                  requestArtisanService.serviceRequests[index];
                              print(serviceRequest.toMap());
                              return MyRequestedServiceWidget(
                                title: serviceRequest.requestingMobile,
                                subtitle: 'Please confirm availability',
                                status: serviceRequest.status,
                                job: serviceRequest,
                                datePosted: serviceRequest.dateRequested,
                              );
                            },
                          ),
                        );
                      });
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
