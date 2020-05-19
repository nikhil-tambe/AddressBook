import 'package:flutter/material.dart';

class DeepLinkScreen extends StatelessWidget {
  static const routeName = "/deepLinkScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Deep Link'),
        ),
        body: Center(
          child: Text("Deep Link Screen"),
        ));
  }
}
