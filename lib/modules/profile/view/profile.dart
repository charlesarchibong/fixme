import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/auth/view/login.dart';
import 'package:quickfix/modules/profile/model/bank_code.dart';
import 'package:quickfix/modules/profile/model/service_image.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/modules/profile/provider/profile_provider.dart';
import 'package:quickfix/modules/profile/widget/edit_profile.dart';
import 'package:quickfix/modules/profile/widget/service_images.dart';
import 'package:quickfix/modules/transfer/view/transfer_fund.dart';
import 'package:quickfix/providers/app_provider.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/widgets/spinner.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

BankCode selected;

class _ProfileState extends State<Profile> {
  final _profileScaffoldKey = GlobalKey<ScaffoldState>();

  // final _formKey = GlobalKey<FormState>();

  String subServices;

  bool savingBankDetails = false;

  List<ServiceImage> serviceImages = List();

  TextEditingController _accountNumberController = TextEditingController();

  User user;

  getSubService() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    String service = await profileProvider.getSubService();
    setState(() {
      subServices = service;
    });
  }

  getServiceImages() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    final images = await profileProvider.getServiceImagesFromServer();
    images.fold((Failure failure) {
      print(failure.message);
      setState(() {
        serviceImages = List();
      });
    }, (List<ServiceImage> list) {
      setState(() {
        serviceImages = list;
      });
    });
  }

  void getUser() async {
    user = await Utils.getUserSession();
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getSubService();
    getServiceImages();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileProiver = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      key: _profileScaffoldKey,
      body: user == null
          ? Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Consumer<ProfileProvider>(
                            builder: (context, profileProvider, child) {
                          return _profileImage(profileProvider, user);
                        }),
                      ),
                      _profileName(user, context)
                    ],
                  ),
                  Divider(),
                  Container(height: 15.0),
                  _accountInformation(),
                  _profileDetailsTiles(
                    title: 'Full Name',
                    subTitle: '${user.firstName} ${user.lastName}',
                    hasTrailing: true,
                    trailingIcon: FaIcon(
                      FontAwesomeIcons.edit,
                      size: 25.0,
                      color: Colors.grey,
                    ),
                    toolTip: 'Edit',
                    onPressed: () {
                      showProfilePopUp(context, _profileScaffoldKey,
                          user.firstName, user.lastName);
                    },
                  ),
                  _profileDetailsTiles(
                    title: 'Email',
                    subTitle: user.email,
                    hasTrailing: false,
                  ),
                  _profileDetailsTiles(
                    title: 'Phone',
                    subTitle: user.fullNumber,
                    hasTrailing: false,
                  ),
                  Divider(),
                  Container(height: 15.0),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Transaction Information",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _profileDetailsTiles(
                    title: 'Wallet Balance',
                    subTitle: 'N200',
                    hasTrailing: false,
                  ),
                  _profileDetailsTiles(
                    title: 'Account Number',
                    subTitle: user.accountNumber,
                    hasTrailing: false,
                  ),
                  _profileDetailsTiles(
                    title: 'Bank Name',
                    subTitle: 'Providus Bank',
                    hasTrailing: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        child: Text(
                          "Withdraw Fund",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () async {
                          // getArtisanByLocation();
                        },
                      ),
                      SizedBox(width: 15),
                      RaisedButton(
                        child: Text(
                          "Transfer Fund",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TransferFund(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Divider(),
                  Container(height: 15.0),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Service Information",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 14,
                  ),
                  _profileDetailsTiles(
                    title: 'Service Category',
                    subTitle: user.serviceArea,
                    hasTrailing: false,
                  ),
                  _profileDetailsTiles(
                    title: 'Service Subcategories',
                    subTitle: subServices ?? 'No Subcategory available yet',
                    hasTrailing: true,
                    trailingIcon: FaIcon(
                      FontAwesomeIcons.plus,
                      color: Colors.grey,
                      size: 25.0,
                    ),
                    toolTip: 'Add Subcategory',
                    onPressed: () async {
                      _showSubCategoryDialog(context, _profileScaffoldKey);
                      await getSubService();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _servicesImages(serviceImages, profileProiver),
                  Divider(),
                  _darkTheme(),
                  Container(
                    height: 50,
                  ),
                ],
              )),
    );
  }

  Widget _darkTheme() {
    return ListTile(
      title: Text(
        "Dark Theme",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Switch(
        value: Provider.of<AppProvider>(context).theme == Constants.lightTheme
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
    );
  }

  Widget _servicesImages(
      List<ServiceImage> list, ProfileProvider profileProvider) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 30.0,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Service Images",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (list.length <= 5) {
                          profileProvider.setLoading();
                          profileProvider.getServiceImage().then((value) {
                            profileProvider.setNotLoading();
                            print('s');
                          }).catchError((onError) {
                            print('e');

                            profileProvider.setNotLoading();
                          });
                          final images = await profileProvider
                              .getServiceImagesFromServer();

                          setState(() {
                            images.fold((Failure failure) {
                              print(failure.message);
                              list = List();
                            }, (List<ServiceImage> imges) {
                              list = imges;
                            });
                          });
                        } else {}
                      },
                      child: profileProvider.loading
                          ? Spinner(
                              icon: FontAwesomeIcons.spinner,
                              color: Colors.grey,
                            )
                          : FaIcon(
                              FontAwesomeIcons.plus,
                              color: Colors.grey,
                              size: 25.0,
                            ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                list.length == 0
                    ? Center(
                        child: Text('No images uploaded yet'),
                      )
                    : ServicesImages(),
              ],
            ));
      },
    );
  }

  Widget _profileDetailsTiles({
    String title,
    String subTitle,
    bool hasTrailing,
    Widget trailingIcon,
    Function() onPressed,
    String toolTip,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(subTitle),
      trailing: hasTrailing
          ? IconButton(
              icon: trailingIcon,
              onPressed: onPressed != null ? () => onPressed() : () {},
              tooltip: toolTip,
            )
          : Text(''),
    );
  }

  Widget _accountInformation() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Text(
        "Account Information",
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

Widget _profileName(User snapshot, BuildContext context) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              snapshot.firstName + ' ' + snapshot.lastName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              snapshot.fullNumber,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: () async {
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
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    ),
    flex: 3,
  );
}

Widget _profileImage(ProfileProvider profileProvider, User user) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: <Widget>[
      user.profilePicture == null || user.profilePicture == ''
          ? Image.asset(
              "assets/dp.png",
              fit: BoxFit.cover,
              width: 100.0,
              height: 100.0,
            )
          : Image.network(
              '${user.profilePicture}',
              fit: BoxFit.cover,
              width: 100.0,
              height: 100.0,
            ),
      RaisedButton(
        onPressed: () {
          profileProvider.setLoading();
          profileProvider.getImage().then((value) {
            // FlushBarCustomHelper.showInfoFlushbar(context, title, message)
            profileProvider.setNotLoading();
          }).catchError((e) {
            profileProvider.setNotLoading();
          });
        },
        child: profileProvider.loading
            ? Spinner(
                icon: FontAwesomeIcons.spinner,
                color: Colors.white,
              )
            : FaIcon(
                FontAwesomeIcons.upload,
                color: Colors.white,
              ),
        elevation: 5,
        color: Color.fromRGBO(153, 0, 153, 1.0),
      )
    ],
  );
}

void showEditAccountDetails(
    BuildContext context,
    List<BankCode> listOfBank,
    TextEditingController accountNumberController,
    GlobalKey<FormState> formKey,
    ProfileProvider profileProvider) {
  bool loading = false;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return listOfBank.length > 0
                ? Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0)), //this right here
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
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Form(
                                        key: formKey,
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Card(
                                              elevation: 4.0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                child: TextFormField(
                                                  controller:
                                                      accountNumberController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  validator: (value) {
                                                    return value == ''
                                                        ? 'Account Number can not be empty'
                                                        : null;
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Enter Account Number',
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
                                                child: DropdownButton<BankCode>(
                                                  value: selected,
                                                  hint: Text(
                                                    'Select Bank Name',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  isExpanded: true,
                                                  underline: SizedBox(),
                                                  icon: Icon(
                                                      Icons.arrow_downward,
                                                      color: Colors.black),
                                                  items: listOfBank
                                                      .map((BankCode v) {
                                                    return DropdownMenuItem<
                                                        BankCode>(
                                                      value: v,
                                                      child: Text(v.name),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (BankCode newValue) {
                                                    setState(() {
                                                      selected = newValue;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FlatButton(
                                    child: loading
                                        ? CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                          )
                                        : Text("Save"),
                                    padding: EdgeInsets.all(10.0),
                                    textColor: Colors.white,
                                    color: Theme.of(context).accentColor,
                                    onPressed: () async {
                                      if (formKey.currentState.validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                                        final updated = await profileProvider
                                            .updateBankDetails(selected,
                                                accountNumberController.text);
                                        updated.fold((Failure failure) {
                                          setState(() {
                                            loading = true;
                                          });
                                          Navigator.of(context).pop();

                                          FlushBarCustomHelper
                                              .showErrorFlushbar(context,
                                                  'Error', failure.message);
                                        }, (bool updated) {
                                          setState(() {
                                            loading = true;
                                          });
                                          Navigator.of(context).pop();

                                          FlushBarCustomHelper.showInfoFlushbar(
                                              context,
                                              'Success',
                                              'Account Details was updated');
                                        });
                                        listOfBank.clear();
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
                  )
                : Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0)), //this right here
                    child: Container(
                      height: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 9,
                            right: 9,
                          ),
                          child: Container(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
          },
        );
      });
}

_showSubCategoryDialog(
    BuildContext context, GlobalKey<ScaffoldState> profileScaffoldKey) {
  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  String input = '';
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
                        onChanged: (value) {
                          input = value;
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
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    profileProvider.setLoading();

                    final added = await profileProvider.addSubCategory(input);
                    Navigator.of(context).pop();

                    profileProvider.setNotLoading();
                    added.fold((Failure failure) {
                      FlushBarCustomHelper.showErrorFlushbar(
                          context, 'Error', failure.message);
                    }, (bool added) {
                      FlushBarCustomHelper.showInfoFlushbar(
                        context,
                        'Success',
                        'Subservice was added',
                      );
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
