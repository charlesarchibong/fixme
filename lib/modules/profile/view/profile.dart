import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../helpers/flush_bar.dart';
import '../../../models/failure.dart';
import '../../../util/Utils.dart';
import '../../../widgets/spinner.dart';
import '../../auth/view/login.dart';
import '../../transfer/view/transfer_fund.dart';
import '../model/bank_code.dart';
import '../model/bank_information.dart';
import '../model/service_image.dart';
import '../model/user.dart';
import '../provider/profile_provider.dart';
import '../widget/change_service.dart';
import '../widget/edit_profile.dart';
import '../widget/service_images.dart';

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

  String profileImage;

  BankInformation bankInformation;

  getSubService() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    String service = await profileProvider.getSubService();

    if (mounted) {
      setState(() {
        subServices = service;
      });
    }
  }

  getBankInformation() async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      final response = await profileProvider.getAccountInfo();

      setState(() {
        bankInformation = response;

        print(bankInformation.balance);
      });
    } catch (e) {}
  }

  getServiceImages() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    await profileProvider.getServiceImagesFromServer();
  }

  Future getUser() async {
    var result = await Utils.getUserSession();
    setState(() {
      user = result;
    });

    profileImage = await Utils.getProfilePicture();
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getUser();
    getSubService();
    getServiceImages();
    getBankInformation();
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
                child: CircularProgressIndicator(),
              ),
            )
          : FutureBuilder(
              future: getUser(),
              builder: (context, snapshot) {
                return Padding(
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
                                return _profileImage(
                                    profileProvider, user, profileImage);
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
                            showProfilePopUp(
                              context,
                              _profileScaffoldKey,
                              user.firstName,
                              user.lastName,
                            );
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
                        bankInformation != null
                            ? _profileDetailsTiles(
                                title: 'Wallet Balance',
                                subTitle: 'N${double.parse(
                                  bankInformation.balance.toString(),
                                )}',
                                hasTrailing: false,
                              )
                            : ListTileShimmer(
                                padding: EdgeInsets.all(0),
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
                                "Transfer Fund From Fixme Wallet",
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
                          toolTip: 'Add Subcategory',
                          hasTrailing: true,
                          trailingIcon: FaIcon(
                            FontAwesomeIcons.edit,
                            color: Colors.grey,
                            size: 25.0,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => ChangeService(),
                            );
                          },
                        ),
                        _profileDetailsTiles(
                          title: 'Service Subcategories',
                          subTitle:
                              subServices ?? 'No Subcategory available yet',
                          hasTrailing: true,
                          trailingIcon: FaIcon(
                            FontAwesomeIcons.plus,
                            color: Colors.grey,
                            size: 25.0,
                          ),
                          toolTip: 'Add Subcategory',
                          onPressed: () async {
                            _showSubCategoryDialog(
                                context, _profileScaffoldKey);
                            await getSubService();
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _servicesImages(serviceImages, profileProiver),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ));
              }),
    );
  }

  // Widget _darkTheme() {
  //   return ListTile(
  //     title: Text(
  //       "Dark Theme",
  //       style: TextStyle(
  //         fontSize: 17,
  //         fontWeight: FontWeight.w700,
  //       ),
  //     ),
  //     trailing: Switch(
  //       value: Provider.of<AppProvider>(context).theme == Constants.lightTheme
  //           ? false
  //           : true,
  //       onChanged: (v) async {
  //         if (v) {
  //           Provider.of<AppProvider>(context, listen: false)
  //               .setTheme(Constants.darkTheme, "dark");
  //         } else {
  //           Provider.of<AppProvider>(context, listen: false)
  //               .setTheme(Constants.lightTheme, "light");
  //         }
  //       },
  //       activeColor: Theme.of(context).accentColor,
  //     ),
  //   );
  // }

  Widget _servicesImages(
      List<ServiceImage> list, ProfileProvider profileProvider) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        print(list);
        return Consumer<ProfileProvider>(
            builder: (context, profileProvider1, child) {
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
                          if (profileProvider1.images.length <= 5) {
                            profileProvider.setLoading();
                            await profileProvider1
                                .getServiceImage()
                                .then((value) async {
                              profileProvider1.setNotLoading();
                              print('s');
                              await profileProvider1
                                  .getServiceImagesFromServer();
                              profileProvider1.setNotLoading();
                            }).catchError((onError) {
                              print('e');

                              profileProvider1.setNotLoading();
                            });
                          } else {}
                        },
                        child: profileProvider1.loading
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
                  profileProvider1.images.length == 0
                      ? Center(
                          child: Text('No images uploaded yet'),
                        )
                      : ServicesImages(
                          listImages: profileProvider1.images,
                        ),
                ],
              ));
        });
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

Widget _profileImage(
    ProfileProvider profileProvider, User user, String profileImage) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: <Widget>[
      Image(
        image: CacheImage('$profileImage'),
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

_showSubCategoryDialog(
    BuildContext context, GlobalKey<ScaffoldState> profileScaffoldKey) {
  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  String input = '';
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(builder: (context, setState) {
      return Dialog(
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
                        autovalidate: true,
                        key: _formKey,
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
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
                            border: InputBorder.none,
                          ),
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
      );
    }),
  );
}
