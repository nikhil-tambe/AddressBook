import 'dart:convert';

import 'package:addressbook/models/address_model.dart';
import 'package:addressbook/models/response_search.dart';

import 'package:http/http.dart' as http;

class LocationHelper {
  static const MAPS_API_KEY = '';

  static String generatePreview(double latitude, double longitude) {
    return 'https://maps.googleapis.com/maps/api/staticmap?'
        'center=$latitude,$longitude'
        '&zoom=16'
        '&size=600x300'
        '&maptype=roadmap'
        '&markers=color:red%7Clabel:C%7C$latitude,$longitude'
        '&key=$MAPS_API_KEY';
  }

  static Future<List<Address>> searchPlaces(String place) async {
    List<Address> addressList = new List();
    String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?'
        'key=${LocationHelper.MAPS_API_KEY}'
        '&input=$place'
        '&inputtype=textquery'
        '&fields=name,geometry,formatted_address';
    print(url);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
        var decode = json.decode(response.body) as Map<String, dynamic>;
        var searchResultBody = SearchResultBody.fromJson(decode);
        var candidates = searchResultBody.candidates;
        if (candidates.length > 0) {
          candidates.forEach((data) {
            var location = data.geometry.location;
            print(
                "Name: ${data.name} ==> Location: ${location.lat} ${location.lng}");
            addressList.add(Address(
              address: data.name,
              formattedAddress: data.formattedAddress,
              lat: location.lat,
              long: location.lng
            ));
          });
          return addressList;
        }
        //print(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      throw (e);
    }
    return addressList;
  }

}
