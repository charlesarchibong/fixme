import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/modules/profile/provider/profile_provider.dart';

class EditProfilePopUp extends StatefulWidget {
  @override
  _EditProfilePopUpState createState() => _EditProfilePopUpState();
}

class _EditProfilePopUpState extends State<EditProfilePopUp> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

showProfilePopUp(
    BuildContext context,
    GlobalKey<ScaffoldState> profileScaffoldKey,
    String firstName,
    String lastName) {
  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController =
      TextEditingController(text: firstName);
  TextEditingController _lastNameController =
      TextEditingController(text: lastName);
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            height: 300,
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    elevation: 4.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: TextFormField(
                                        controller: _firstNameController,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          return value == ''
                                              ? 'Firstname can not be empty'
                                              : null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Enter FirstName',
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Card(
                                    elevation: 4.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: TextFormField(
                                        controller: _lastNameController,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          return value == ''
                                              ? 'Lastname can not be empty'
                                              : null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Enter Lastname',
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
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
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              // profileProvider.setLoading();
                              // profileProvider
                              //     .addSubCategory(input)
                              //     .then((value) {
                              //   profileProvider.setNotLoading();
                              await profileProvider.updateProfile(
                                  firstName, lastName);
                              Navigator.of(context).pop();
                              profileScaffoldKey.currentState
                                  .showSnackBar(SnackBar(
                                content: Text('Profile was added'),
                                duration: Duration(seconds: 5),
                              ));
                              // }).catchError((e) {
                              //   print(e);
                              //   profileProvider.setNotLoading();
                              //   Navigator.of(context).pop();
                              //   profileScaffoldKey.currentState
                              //       .showSnackBar(SnackBar(
                              //     content: Text(
                              //       e.toString().split(':')[1],
                              //       style: TextStyle(
                              //         color: Colors.red,
                              //       ),
                              //     ),
                              //     duration: Duration(seconds: 5),
                              //   ));
                              // });
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
      });
}
