import 'package:canoe_trip_planner/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CompanyPriceFields extends StatelessWidget {
  final String chosenCanoeType;
  final Function onCanoeTypeChosen;
  final Function onPriceChanged;
  final bool canAdd;
  final Function onAddNew;
  final MoneyMaskedTextController lowPrice;

  CompanyPriceFields(
      {this.chosenCanoeType,
      this.onCanoeTypeChosen,
      this.onPriceChanged,
      this.canAdd,
      this.onAddNew,
      this.lowPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: chosenCanoeType,
          onChanged: onCanoeTypeChosen,
          items: canoeTypes.map<DropdownMenuItem<String>>((String value) {
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
              onChanged: onPriceChanged // Only numbers can be entered
              ),
        ),
        InkWell(
          onTap: onAddNew,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: (canAdd) ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              (canAdd) ? Icons.add : Icons.remove,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
