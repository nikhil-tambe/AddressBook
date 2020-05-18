

import 'package:addressbook/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressProvider with ChangeNotifier {

  List<Address> _addressList = [];
  Set<Marker> _markers = {};

  List<Address> get addressList => [..._addressList];

  setAddressList(List<Address> value) {
    _addressList = value;
    notifyListeners();
  }

  Set<Marker> get markers => _markers;

  setMarkers(Set<Marker> value) {
    _markers = value;
    notifyListeners();
  }


}