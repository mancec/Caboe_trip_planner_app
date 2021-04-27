import 'package:flutter/material.dart';
import 'package:canoe_trip_planner/utils/helper.dart';

class AlertDialogWidget extends StatelessWidget {
  final String title;

  AlertDialogWidget({this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Route: ' + title.inCaps),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('Are you sure you want to delete this route?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Confirm'),
          onPressed: () {
            print('Confirmed');
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
