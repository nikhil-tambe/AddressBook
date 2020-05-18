import 'package:addressbook/models/address_model.dart';
import 'package:addressbook/providers/address_provider.dart';
import 'package:addressbook/utils/location_helper.dart';
import 'package:addressbook/utils/location_search_deligate.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'map_screen.dart';

class AddressListScreen extends StatefulWidget {
  static const routeName = "AddressListScreen";

  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  String _locationURL;
  double latitude, longitude;

  Future<void> showCurrentLocation() async {
    var locationData = await Location().getLocation();
    latitude = locationData.latitude;
    longitude = locationData.longitude;
    print("Lat: $latitude Long: $longitude");
    var generatePreview = LocationHelper.generatePreview(latitude, longitude);
    setState(() {
      _locationURL = generatePreview;
    });
  }

  gotoLocation(BuildContext context) {
    var selectedLocation =
        Navigator.of(context).pushNamed(MapScreen.routeName, arguments: {
      'address': Address(
          address: "Current Address",
          formattedAddress: "N/A",
          lat: latitude,
          long: longitude),
    });

    if (selectedLocation == null) {
      return;
    }
    // Save in List
  }

  @override
  Widget build(BuildContext context) {
    AddressProvider provider = Provider.of<AddressProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Address Book"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: LocationSearchDelegate(addressProvider: provider));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(25, 10, 0, 0),
              leading: Icon(Icons.my_location),
              title: Text("My Curren Location"),
              subtitle: latitude != null
                  ? Text("Latitude: $latitude, Longitude: $longitude}")
                  : Text("From GPS"),
              onTap: showCurrentLocation,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: _locationURL == null
                  ? Text("Tap on current location")
                  : InkWell(
                      child: Image.network(
                        _locationURL,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        gotoLocation(context);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
