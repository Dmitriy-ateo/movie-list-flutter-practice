import 'package:flutter/material.dart';

class RouteHelper {
  BuildContext context;
  int exitAttempts = 0;
  var subscription;

  RouteHelper(this.context) {
    // Initialization code goes here.
  }

  void replaceAllTo(String pathName) {
    this.exitAttempts = 0;
    Navigator.of(this.context).pushNamedAndRemoveUntil(pathName, (Route<dynamic> route) => false);
  }

  void navigateTo(String pathName) {
    this.exitAttempts = 0;
    Navigator.pushNamed(this.context, pathName);
  }

  void replaceTo(String pathName) {
    this.exitAttempts = 0;
    Navigator.pushReplacementNamed(this.context, pathName);
  }

  Future<bool> onBackPressed() {
    return showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Warning'),
        content: Text('Do you really want to exit'),
        actions: [
          FilledButton(
            child: Text('Yes'),
            onPressed: () => Navigator.pop(c, true),
          ),
          FilledButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(c, false),
          ),
        ],
      ),
    );
  }
}
