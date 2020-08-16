import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/flush_bar.dart';
import '../models/failure.dart';
import '../modules/job/model/job.dart';
import '../modules/job/provider/pending_job_provider.dart';

class CustomPopupButton extends StatefulWidget {
  final Job job;
  final int index;

  const CustomPopupButton({
    Key key,
    this.job,
    this.index,
  }) : super(key: key);

  @override
  _CustomPopupButtonState createState() => _CustomPopupButtonState();
}

class _CustomPopupButtonState extends State<CustomPopupButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          bool loading = false;
          final _formKey = GlobalKey<FormState>();
          final _jobProvider = Provider.of<PendingJobProvider>(
            context,
            listen: false,
          );
          TextEditingController _amountController = TextEditingController();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return Dialog(
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
                                        // color: Colors.white,
                                        borderRadius: BorderRadius.all(
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
                                              color: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5.0,
                                                  right: 5.0,
                                                ),
                                                child: TextFormField(
                                                  autofillHints: [
                                                    AutofillHints
                                                        .transactionAmount
                                                  ],
                                                  controller: _amountController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    return value == ''
                                                        ? 'Bidding price can not be empty'
                                                        : null;
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Enter Bidding Pricing',
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
                                              backgroundColor: Colors.white,
                                            )
                                          : Text(
                                              "Bid Job",
                                            ),
                                      padding: EdgeInsets.all(
                                        10.0,
                                      ),
                                      textColor: Colors.white,
                                      color: Theme.of(context).accentColor,
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          final bidJob =
                                              await _jobProvider.bidJob(
                                            widget.job,
                                            double.parse(
                                              _amountController.text,
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                          bidJob.fold((Failure failure) {
                                            FlushBarCustomHelper
                                                .showErrorFlushbar(
                                              context,
                                              'Error',
                                              failure.message,
                                            );
                                          }, (bool bidded) {
                                            _jobProvider.removeJobFromList(
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
              Text('Bid for this Job'),
            ],
          ),
        ),
      ],
    );
  }
}
