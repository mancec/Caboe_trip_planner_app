import 'package:canoe_trip_planner/components/appBarMenu.dart';
import 'package:canoe_trip_planner/components/company_price_fields.dart';
import 'package:canoe_trip_planner/components/company_profile.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/canoe_price.dart';
import 'package:canoe_trip_planner/models/company.dart';
import 'package:canoe_trip_planner/models/company_map_route.dart';
import 'package:canoe_trip_planner/provider/company_map_route_provider.dart';
import 'package:canoe_trip_planner/screens/Company/company_map_list_screen.dart';
import 'package:canoe_trip_planner/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';

class CompanyProfileEditScreen extends StatefulWidget {
  static const String id = 'company_profile_edit_screen';
  @override
  _CompanyProfileEditScreenState createState() =>
      _CompanyProfileEditScreenState();
}

class _CompanyProfileEditScreenState extends State<CompanyProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  CompanyMapRoute mapRoute = CompanyMapRoute();
  Company company = Company();
  CompanyMapRouteProvider companyMapRouteProvider =
      locator<CompanyMapRouteProvider>();
  static List<CanoePrice> canoePrices = [null];
  List<MoneyMaskedTextController> lowPrice = [];

  void initState() {
    companyMapRouteProvider.getCompanyProfile().then((value) {
      company = companyMapRouteProvider.company;
      canoePrices = companyMapRouteProvider.company.canoePrice;
      for (int i = 0; i < canoePrices.length; i++) {
        MoneyMaskedTextController temp = MoneyMaskedTextController();
        temp.updateValue(canoePrices[i].price);
        lowPrice.add(temp);
      }
    });
    super.initState();
  }

  saveProfile() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // submitForm();
      company.canoePrice = canoePrices;
      companyMapRouteProvider.editCompanyProfile(company);
      _formKey.currentState.reset();
      Navigator.pushNamed(context, CompanyMapListScreen.id);
    }
    // Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (__) => new CompanyMapCreateScreen(
    //           company: companyMapRouteProvider.company,
    //         )));
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
            body: companyMapRouteProvider.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      CompanyProfileForm(
                        formKey: _formKey,
                        company: companyMapRouteProvider.company,
                        onEmailSaved: (value) => company.contactEmail = value,
                        onAddressSaved: (value) => company.address = value,
                        onWorkHoursSaved: (value) => company.workHours = value,
                        onContactNumberSaved: (value) =>
                            company.contactNumber = value,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: canoePrices.length,
                              itemBuilder: (context, index) =>
                                  CompanyPriceFields(
                                lowPrice: lowPrice[index],
                                chosenCanoeType: canoePrices[index].type,
                                onCanoeTypeChosen: (value) {
                                  setState(() {
                                    canoePrices[index].type = value;
                                  });
                                },
                                onPriceChanged: (value) {
                                  setState(() {
                                    canoePrices[index].price =
                                        lowPrice[index].numberValue;
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
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                              child: RaisedButton(
                                elevation: 5.0,
                                child: Text('Update'),
                                onPressed: saveProfile,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ));
      }),
    );
  }
}
