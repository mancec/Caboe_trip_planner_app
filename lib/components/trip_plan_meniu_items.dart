import 'package:flutter/material.dart';

class PlusMinusEntry extends PopupMenuEntry<int> {
  @override
  double height = 100;
  // height doesn't matter, as long as we are not giving
  // initialValue to showMenu().

  @override
  bool represents(int n) => n == 1 || n == -1;

  @override
  PlusMinusEntryState createState() => PlusMinusEntryState();
}

class PlusMinusEntryState extends State<PlusMinusEntry> {
  void _plus1() {
    // This is how you close the popup menu and return user selection.
    Navigator.pop<int>(context, 1);
  }

  void _minus1() {
    Navigator.pop<int>(context, -1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: FlatButton(onPressed: _plus1, child: Text('+1'))),
        Expanded(child: FlatButton(onPressed: _minus1, child: Text('-1'))),
      ],
    );
  }
}
