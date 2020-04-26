import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Location location = new Location();

LocationData _locationData;

Future _serviceEnabled() async {
  await location.serviceEnabled().then((value) {
    if (!value) {
      location.requestService();
      if (!value) {
        return;
      }
    }
  });
}

Future _permissionGranted() async {
  await location.hasPermission().then((value) {
    if (value == PermissionStatus.denied) {
      location.requestPermission();
      if (value != PermissionStatus.granted) {
        return;
      }
    }
  });
}

@override
void initState() {
  _serviceEnabled();
  _permissionGranted();
  location.getLocation().then((value) {
    print(value);
    _locationData = value;
  });
}

class _HomeState extends State<Home> {
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    location.getLocation().then((value) {
      print(value);
      _locationData = value;
    });
    LatLng _lastMapPosition =
        LatLng(_locationData.latitude, _locationData.longitude);
    location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _locationData = locationData;
        _lastMapPosition =
            LatLng(locationData.latitude, locationData.longitude);
      });
    });

    final Set<Marker> _markers = {};
    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(_lastMapPosition.toString()),
      position: _lastMapPosition,
      infoWindow: InfoWindow(
        title: 'User',
        snippet: 'You',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    ));
    void _onCameraMove(CameraPosition position) {
      _lastMapPosition = position.target;
    }

    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height - 50.0,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _lastMapPosition, zoom: 12.0),
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.2,
          maxChildSize: 1.0,

//          expand: true,
          builder: (BuildContext context, myscrollController) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: radius,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(2, 2))
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Nice to see you!',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Request for Service',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
