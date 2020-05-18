import 'package:addressbook/providers/address_provider.dart';
import 'package:addressbook/screens/address_list_screen.dart';
import 'package:addressbook/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AddressProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: AddressListScreen.routeName,
        routes: {
          AddressListScreen.routeName: (context) => AddressListScreen(),
          MapScreen.routeName : (context) => MapScreen(),
        },
      ),
    );
  }
}
