import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/job_category.dart';
import 'package:quickfix/modules/job/provider/post_job_provider.dart';
import 'package:quickfix/modules/profile/provider/profile_provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class ChangeService extends StatefulWidget {
  const ChangeService({
    Key key,
  }) : super(key: key);

  @override
  _ChangeServiceState createState() => _ChangeServiceState();
}

class _ChangeServiceState extends State<ChangeService> {
  List<JobCategory> _services = List();
  // final _formKey = GlobalKey<FormState>();
  JobCategory selectedService;
  bool loading = false;
  Future getJobCategory() async {
    final postJob = Provider.of<PostJobProvider>(context, listen: false);
    final fetched = await postJob.getJobCategories();
    fetched.fold((Failure failure) {
      if (mounted) {}
      FlushBarCustomHelper.showErrorFlushbar(
        context,
        'Error',
        'An error occured, please try again!',
      );
    }, (List<JobCategory> list) {
      if (mounted)
        setState(() {
          _services = list;
        });
    });
  }

  Future changeService() async {
    try {
      setState(() {
        loading = true;
      });
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);

      final response =
          await profileProvider.changeServices(id: selectedService.id);

      print(response);

      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    getJobCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Change Service",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Theme.of(context).accentColor,
              ),
            ),
            Card(
              elevation: 3.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: SearchableDropdown.single(
                  value: selectedService,
                  hint: Text(
                    'Select Services',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  isExpanded: true,
                  underline: SizedBox(),
                  // icon: Icon(
                  //   Icons.arrow_downward,
                  //   color: Colors.grey,
                  // ),
                  items: _services.map((JobCategory value) {
                    return DropdownMenuItem<JobCategory>(
                      value: value,
                      child: Text(value.service),
                    );
                  }).toList(),
                  searchHint: "Search Service",
                  onChanged: (newValue) {
                    setState(() {
                      selectedService = newValue;
                    });
                    print(selectedService.id);
                  },
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              height: 50.0,
              child: loading
                  ? Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : RaisedButton(
                      child: Text(
                        "Add Job".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        if (selectedService == null) {
                          setState(() {
                            loading = false;
                          });
                          debugPrint('Error');
                          FlushBarCustomHelper.showErrorFlushbar(
                            context,
                            'Error',
                            'Please select a job category!',
                          );
                          return;
                        }
                        print('bby uploading');

                        await changeService();
                      },
                      color: Theme.of(context).accentColor,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
