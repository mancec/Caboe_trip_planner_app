import 'package:canoe_trip_planner/components/appBarMenu.dart';
import 'package:canoe_trip_planner/components/company_profile.dart';
import 'package:canoe_trip_planner/components/roundedButton.dart';
import 'package:canoe_trip_planner/models/canoe_price.dart';
import 'package:canoe_trip_planner/models/company.dart';
import 'package:canoe_trip_planner/models/company_map_route.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:canoe_trip_planner/provider/company_map_route_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'company_map_create_screen.dart';

class CompanyProfileScreen extends StatefulWidget {
  static const String id = 'company_profile_screen';
  @override
  _CompanyProfileFormState createState() => _CompanyProfileFormState();
}

class _CompanyProfileFormState extends State<CompanyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  CompanyMapRoute mapRoute = CompanyMapRoute();
  Company company = Company();
  CompanyMapRouteProvider mapRouteProvider = CompanyMapRouteProvider();

  static List<CanoePrice> canoePrices = [null];

  saveProfile() {
    company.canoePrice = canoePrices;
    mapRouteProvider.saveCompanyProfile(company);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canoe planner')),
      drawer: AppBarMenu(),
      body: CompanyProfileForm(
        company: company,
        onSave: () {
          canoePrices.add(canoePrice);
          setState(() {});
        },
      ),
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
      _canoePrice = _CompanyProfileFormState.canoePrices[widget.index] ??
          (_CompanyProfileFormState.canoePrices[widget.index] = CanoePrice());
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
            _CompanyProfileFormState.canoePrices[widget.index].type =
                value.toString();
            print(_CompanyProfileFormState.canoePrices[widget.index].type);
            setState(() {
              dropdownValue =
                  _CompanyProfileFormState.canoePrices[widget.index].type;
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
              _CompanyProfileFormState.canoePrices[widget.index].price =
                  lowPrice.numberValue;
              print(lowPrice.numberValue);
              print(_CompanyProfileFormState.canoePrices[widget.index].price);
            }, // Only numbers can be entered
          ),
        ),
      ],
    );
  }
}
