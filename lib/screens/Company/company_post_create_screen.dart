import 'package:canoe_trip_planner/components/appBarMenu.dart';
import 'package:canoe_trip_planner/models/canoe_price.dart';
import 'package:canoe_trip_planner/models/company.dart';
import 'package:canoe_trip_planner/models/company_map_route.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:canoe_trip_planner/provider/company_map_route_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import 'company_map_create_screen.dart';

class CompanyPostScreen extends StatefulWidget {
  static const String id = 'company_post_screen';
  @override
  _CompanyPostFormState createState() => _CompanyPostFormState();
}

class _CompanyPostFormState extends State<CompanyPostScreen> {
  final _formKey = GlobalKey<FormState>();
  CompanyMapRoute mapRoute = CompanyMapRoute();
  Company company = Company();
  CompanyMapRouteProvider companyMapRouteProvider =
      locator<CompanyMapRouteProvider>();

  static List<CanoePrice> canoePrices = [null];

  void initState() {
    companyMapRouteProvider.getCompanyProfile();

    print(companyMapRouteProvider.state);

    super.initState();
  }

  saveProfile() {
    company.canoePrice = canoePrices;
    // mapRouteProvider.saveCompanyProfile(company);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CompanyMapRouteProvider>(
      create: (context) => companyMapRouteProvider,
      child: Consumer<CompanyMapRouteProvider>(
          builder: (context, companyMapRouteProvider, child) {
        return Scaffold(
          appBar: AppBar(title: Text('Canoe planner')),
          drawer: AppBarMenu(),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Contact email',
                      icon: Icon(
                        Icons.email,
                      ),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Please enter a email' : null,
                    onSaved: (value) => company.contactEmail = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Address',
                      icon: Icon(
                        Icons.add_location,
                      ),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Please enter a address' : null,
                    onSaved: (value) => company.address = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Work hours',
                      icon: Icon(
                        Icons.access_time,
                      ),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Please enter the work hours' : null,
                    onSaved: (value) => company.workHours = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Contact number',
                      icon: Icon(
                        Icons.phone,
                      ),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Please enter a number' : null,
                    onSaved: (value) => company.contactNumber = value,
                  ),
                  ...getPostsUi(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                    child: RaisedButton(
                      elevation: 5.0,
                      child: Text('Add a map route'),
                      onPressed: () async {
                        await Navigator.pushNamed(
                                context, CompanyMapCreateScreen.id)
                            .then((value) => mapRoute.polyline = value);

                        // submitForm();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                    child: RaisedButton(
                      elevation: 5.0,
                      child: Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          saveProfile();
                          // submitForm();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  List<Widget> getPostsUi() {
    List<Widget> canoePriceWidget = [];
    for (int i = 0; i < canoePrices.length; i++) {
      canoePriceWidget.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: CanoePriceFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == canoePrices.length - 1, i),
          ],
        ),
      ));
    }
    return canoePriceWidget;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          canoePrices.add(CanoePrice());
        } else
          canoePrices.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CanoePriceFields extends StatefulWidget {
  final int index;
  CanoePriceFields(this.index);
  @override
  _CanoePriceFieldsState createState() => _CanoePriceFieldsState();
}

class _CanoePriceFieldsState extends State<CanoePriceFields> {
  final lowPrice =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  CanoePrice _canoePrice;
  String dropdownValue;

  @override
  void initState() {
    super.initState();
    _canoePrice = CanoePrice();
    dropdownValue = _canoePrice.type;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _canoePrice = _CompanyPostFormState.canoePrices[widget.index] ??
          (_CompanyPostFormState.canoePrices[widget.index] = CanoePrice());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: dropdownValue,
          onChanged: (value) {
            print(value);
            _CompanyPostFormState.canoePrices[widget.index].type =
                value.toString();
            print(_CompanyPostFormState.canoePrices[widget.index].type);
            setState(() {
              dropdownValue =
                  _CompanyPostFormState.canoePrices[widget.index].type;
            });
          },
          items: <String>['Vienvietė', 'Dvivietė', 'Trivietė', 'Keturvietė']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(
          width: 60,
          child: new TextField(
            controller: lowPrice,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _CompanyPostFormState.canoePrices[widget.index].price =
                  lowPrice.numberValue;
              print(lowPrice.numberValue);
              print(_CompanyPostFormState.canoePrices[widget.index].price);
            }, // Only numbers can be entered
          ),
        ),
      ],
    );
  }
}
