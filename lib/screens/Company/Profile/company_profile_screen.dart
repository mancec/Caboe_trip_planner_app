import 'package:canoe_trip_planner/components/appBarMenu.dart';
import 'package:canoe_trip_planner/components/company_price_fields.dart';
import 'package:canoe_trip_planner/components/company_profile.dart';
import 'package:canoe_trip_planner/models/canoe_price.dart';
import 'package:canoe_trip_planner/models/company.dart';
import 'package:canoe_trip_planner/models/company_map_route.dart';
import 'package:canoe_trip_planner/provider/company_map_route_provider.dart';
import 'package:canoe_trip_planner/screens/Company/company_map_list_screen.dart';
import 'package:canoe_trip_planner/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CompanyProfileScreen extends StatefulWidget {
  static const String id = 'company_profile_screen';
  @override
  _CompanyProfileFormState createState() => _CompanyProfileFormState();
}

class _CompanyProfileFormState extends State<CompanyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  Company company = Company();
  CompanyMapRouteProvider mapRouteProvider = CompanyMapRouteProvider();
  List<MoneyMaskedTextController> lowPrice = [MoneyMaskedTextController()];
  static List<CanoePrice> canoePrices = [CanoePrice()];

  @override
  void initState() {
    super.initState();
  }

  saveProfile() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // submitForm();
      company.canoePrice = canoePrices;
      mapRouteProvider.saveCompanyProfile(company);
      _formKey.currentState.reset();
      Navigator.pushNamed(context, CompanyMapListScreen.id);
      // setState(() {
      //   canoePrices = [CanoePrice()];
      //   lowPrice = [MoneyMaskedTextController()];
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canoe planner')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Set Up Your Profile',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            CompanyProfileForm(
              formKey: _formKey,
              company: company,
              onEmailSaved: (value) => company.contactEmail = value,
              onAddressSaved: (value) => company.address = value,
              onWorkHoursSaved: (value) => company.workHours = value,
              onContactNumberSaved: (value) => company.contactNumber = value,
            ),
            Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: canoePrices.length,
                  itemBuilder: (context, index) => CompanyPriceFields(
                    lowPrice: lowPrice[index],
                    chosenCanoeType: canoePrices[index].type,
                    onCanoeTypeChosen: (value) {
                      setState(() {
                        canoePrices[index].type = value;
                      });
                    },
                    onPriceChanged: (value) {
                      setState(() {
                        canoePrices[index].price = lowPrice[index].numberValue;
                      });
                    },
                    onAddNew: () {
                      if (index == canoePrices.length - 1) {
                        if (canoePrices.length < 4) {
                          canoePrices.add(CanoePrice());
                          lowPrice.add(MoneyMaskedTextController());
                        }
                      } else {
                        canoePrices.removeAt(index);
                      }
                      setState(() {});
                    },
                    canAdd: index == canoePrices.length - 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: RaisedButton(
                    elevation: 5.0,
                    child: Text('Save'),
                    onPressed: saveProfile,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
