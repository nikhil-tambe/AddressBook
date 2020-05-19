import 'package:addressbook/models/address_model.dart';
import 'package:addressbook/utils/location_helper.dart';
import 'package:addressbook/utils/location_search_deligate.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:share/share.dart';

import 'map_screen.dart';

class AddressListScreen extends StatefulWidget {
  static const routeName = "/";

  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  String _locationURL;
  double latitude, longitude;

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    print('Deep Link: ${deepLink.toString()}');
    if (deepLink != null) {
      gotoDeepLink(deepLink);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          print('Deep Link: onLink => ${deepLink.toString()}');
          if (deepLink != null) {
            gotoDeepLink(deepLink);
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  void gotoDeepLink(deepLink){
    print(deepLink.path);
    if (deepLink.path.startsWith('/mapScreen')) {
      return;
    }
    Navigator.pushNamed(context, deepLink.path);
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Address Book"),
        actions: <Widget>[
          buildSearchWidget(context),
          buildShareWidget(),
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

  IconButton buildSearchWidget(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        showSearch(
            context: context, delegate: LocationSearchDelegate(gotoNext: true));
      },
    );
  }

  Builder buildShareWidget() {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(Icons.share),
          onPressed: latitude == null
              ? () {
                  final snackBar = SnackBar(
                    content: Text('Update Current Location First!!'),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              : () {
                  final RenderBox box = context.findRenderObject();
                  Share.share('Latitude: $latitude,\nLongitude: $longitude',
                      subject: "My Co-ordinates",
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
        );
      },
    );
  }
}
