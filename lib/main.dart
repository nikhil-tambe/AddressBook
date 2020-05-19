import 'package:addressbook/providers/address_provider.dart';
import 'package:addressbook/screens/address_list_screen.dart';
import 'package:addressbook/screens/deep_link_screen.dart';
import 'package:addressbook/screens/map_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: AddressProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: AddressListScreen.routeName,
        routes: {
          AddressListScreen.routeName: (context) => AddressListScreen(),
          MapScreen.routeName: (context) => MapScreen(),
          DeepLinkScreen.routeName: (context) => DeepLinkScreen()
        },
      ),
    );
  }
}
