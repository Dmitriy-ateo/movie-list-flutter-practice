import 'package:flutter/material.dart';

class DisplayHlpr {
  BuildContext context;

  // Constructor, with syntactic sugar for assignment to members.
  DisplayHlpr(this.context) {
    // Initialization code goes here.
  }

  void displayDialog(title, text) => showDialog(
    context: context,
    builder: (context) =>
      AlertDialog(
        title: Text(title),
        content: Text(text)
      ),
  );
}
