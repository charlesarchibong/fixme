import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/providers/app_provider.dart';
import 'package:quickfix/providers/profile_provider.dart';
import 'package:quickfix/screens/login.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/widgets/service_images.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _profileScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _profileScaffoldKey,
      body: FutureBuilder(
        future: Utils.getUserSession(),
        builder: (context, snapshot) {
          return Padding(
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
            child: snapshot.hasData
                ? ListView(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Consumer<ProfileProvider>(
                                builder: (context, profileProvider, child) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  profileProvider.profilePicture == null
                                      ? Image.asset(
                                          "assets/dp.png",
                                          fit: BoxFit.cover,
                                          width: 100.0,
                                          height: 100.0,
                                        )
                                      : Image.file(
                                          profileProvider.profilePicture,
                                          fit: BoxFit.cover,
                                          width: 100.0,
                                          height: 100.0,
                                        ),
                                  RaisedButton(
                                    onPressed: () {
                                      profileProvider.getImage();
                                    },
                                    child: Icon(
                                      Icons.photo_camera,
                                      color: Colors.white,
                                    ),
                                    elevation: 5,
                                    color: Colors.red,
                                  )
                                ],
                              );
                            }),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.firstName +
                                          ' ' +
                                          snapshot.data.lastName,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.email,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () async {
                                        Utils.clearUserSession();
                                        Utils.clearApiKey();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return LoginScreen();
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                      Divider(),
                      Container(height: 15.0),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Account Information".toUpperCase(),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Full Name",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          snapshot.data.firstName +
                              ' ' +
                              snapshot.data.lastName,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 20.0,
                          ),
                          onPressed: () {},
                          tooltip: "Edit",
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          snapshot.data.email,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Phone",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          snapshot.data.phoneNumber,
                        ),
                      ),
                      Divider(),
                      Container(height: 15.0),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Service Information".toUpperCase(),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 14,
                      ),
                      ListTile(
                        title: Text(
                          "Service Category",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          snapshot.data.serviceArea,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Service Subcategories",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          'Washing, Cleaning, Cooking',
                        ),
                        trailing: InkWell(
                          onTap: () {
                            _showSubCategoryDialog(
                                context, _profileScaffoldKey);
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Consumer<ProfileProvider>(
                            builder: (context, profileProvider, child) {
                              return Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Service Images",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (profileProvider.images.length <=
                                              5) {
                                            profileProvider.getServiceImage();
                                          } else {}
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  profileProvider.images.length == 0
                                      ? Center(
                                          child: Text('No images uploaded yet'),
                                        )
                                      : ServicesImages(),
                                ],
                              );
                            },
                          )),
                      Divider(),
                      ListTile(
                        title: Text(
                          "Dark Theme",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        trailing: Switch(
                          value: Provider.of<AppProvider>(context).theme ==
                                  Constants.lightTheme
                              ? false
                              : true,
                          onChanged: (v) async {
                            if (v) {
                              Provider.of<AppProvider>(context, listen: false)
                                  .setTheme(Constants.darkTheme, "dark");
                            } else {
                              Provider.of<AppProvider>(context, listen: false)
                                  .setTheme(Constants.lightTheme, "light");
                            }
                          },
                          activeColor: Theme.of(context).accentColor,
                        ),
                      ),
                      Container(
                        height: 50,
                      ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      ProfileShimmer(),
                      SizedBox(
                        height: 20,
                      ),
                      ListTileShimmer(),
                      ListTileShimmer(),
                      ListTileShimmer(),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

_showSubCategoryDialog(
    BuildContext context, GlobalKey<ScaffoldState> profileScaffoldKey) {
  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  showDialog(
      context: context,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 3.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _controller,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                return value.isEmpty
                                    ? 'Subcategory can not be empty'
                                    : null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Enter subcategory',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      child: profileProvider.loading
                          ? Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            )
                          : Text("Save"),
                      padding: EdgeInsets.all(10.0),
                      textColor: Colors.white,
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          profileProvider.setLoading();
                          profileProvider
                              .addSubCategory(_controller.text)
                              .then((value) {
                            profileProvider.setNotLoading();
                            Navigator.of(context).pop();
                            profileScaffoldKey.currentState
                                .showSnackBar(SnackBar(
                              content: Text('Subcategory was added'),
                              duration: Duration(seconds: 5),
                            ));
                          }).catchError((e) {
                            print(e);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ));
}

class MyBottomSheetLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(); // return your bottomSheetLayout
  }
}
