import 'package:addressbook/models/address_model.dart';
import 'package:addressbook/providers/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const routeName = "MapScreen";

  //MapScreen(this.initialAddress, this.isSelecting);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const double sheetHeight = 150;
  Address address;

  @override
  Widget build(BuildContext context) {
    AddressProvider provider = Provider.of<AddressProvider>(context);
    var arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    address = arguments['address'];
    LatLng pinPosition = LatLng(address.lat, address.long);
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Container(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            GoogleMap(
              padding: EdgeInsets.only(bottom: sheetHeight),
              initialCameraPosition:
                  CameraPosition(target: pinPosition, zoom: 16),
              markers: provider.markers,
              onMapCreated: (controller) {
                provider.setMarkers({
                  Marker(
                      markerId: MarkerId('now'),
                      position: pinPosition,
                      visible: true,
                      icon: BitmapDescriptor.defaultMarker)
                });
                //showAddress(context);
              },
              onCameraMove: (position) {
                var target = position.target;
                pinPosition = LatLng(target.latitude, target.longitude);
                provider.setMarkers({
                  Marker(
                      markerId: MarkerId('now'),
                      position: pinPosition,
                      visible: true,
                      icon: BitmapDescriptor.defaultMarker)
                });
              },
              onCameraMoveStarted: () {
                print("onCameraMoveStarted");
              },
              onCameraIdle: () {
                print("onCameraIdle");
                //LocationHelper.searchPlaceByCoordinates(pinPosition);
              },
            ),
            //showBottomSheet(context)
          ],
        ),
      ),
    );
  }

  void showAddress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: Column(
            children: <Widget>[
              Text(address.address),
              Text(address.formattedAddress),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Close"))
            ],
          ),
        );
      },
    );
  }

  Container showBottomSheet(BuildContext context) {
    return Container(
            width: double.infinity,
            height: sheetHeight,
            child: Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  Text(address.address),
                  SizedBox(height: 10,),
                  Text(address.formattedAddress),
                  SizedBox(height: 20,),
                  RaisedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Close"))
                ],
              ),
            ),
          );
  }
}
