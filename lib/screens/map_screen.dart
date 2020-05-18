import 'package:addressbook/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  static const routeName = "MapScreen";

  //MapScreen(this.initialAddress, this.isSelecting);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Address address;

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

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    address = arguments['address'];
    LatLng pinPosition = LatLng(address.lat, address.long);
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: pinPosition, zoom: 16),
          markers: {
            Marker(
                markerId: MarkerId("now"),
                position: pinPosition,
                visible: true,
                icon: BitmapDescriptor.defaultMarker)
          },
          onMapCreated: (controller) {
            //showAddress(context);
          },
        ),
      ),
    );
  }
}
