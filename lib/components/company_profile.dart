import 'package:canoe_trip_planner/models/company.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyProfileForm extends StatelessWidget {
  final Function onEmailSaved;
  final Function onAddressSaved;
  final Function onWorkHoursSaved;
  final Function onContactNumberSaved;
  final Company company;

  final formKey;

  CompanyProfileForm(
      {this.onEmailSaved,
      this.formKey,
      this.onAddressSaved,
      this.onWorkHoursSaved,
      this.onContactNumberSaved,
      this.company});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            TextFormField(
                initialValue: company.contactEmail ?? '',
                decoration: InputDecoration(
                  hintText: 'Contact email',
                  icon: Icon(
                    Icons.email,
                  ),
                ),
                validator: (value) =>
                    value.isEmpty ? 'Please enter a email' : null,
                onSaved: onEmailSaved),
            TextFormField(
                initialValue: company.address ?? '',
                decoration: InputDecoration(
                  hintText: 'Address',
                  icon: Icon(
                    Icons.add_location,
                  ),
                ),
                validator: (value) =>
                    value.isEmpty ? 'Please enter a address' : null,
                onSaved: onAddressSaved),
            TextFormField(
                initialValue: company.workHours ?? '',
                decoration: InputDecoration(
                  hintText: 'Work hours',
                  icon: Icon(
                    Icons.access_time,
                  ),
                ),
                validator: (value) =>
                    value.isEmpty ? 'Please enter the work hours' : null,
                onSaved: onWorkHoursSaved),
            TextFormField(
                initialValue: company.contactNumber,
                decoration: InputDecoration(
                  hintText: 'Contact number',
                  icon: Icon(
                    Icons.phone,
                  ),
                ),
                validator: (value) =>
                    value.isEmpty ? 'Please enter a number' : null,
                onSaved: onContactNumberSaved),
            //...getPostsUi(),
          ],
        ),
      ),
    );
  }
}
