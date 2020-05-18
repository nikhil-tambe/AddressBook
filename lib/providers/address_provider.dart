

import 'package:addressbook/models/address_model.dart';
import 'package:flutter/material.dart';

class AddressProvider with ChangeNotifier {

  List<Address> _addressList = [];

  List<Address> get addressList => [..._addressList];

  setAddressList(List<Address> value) {
    _addressList = value;
    notifyListeners();
  }

}