import 'package:addressbook/models/address_model.dart';
import 'package:addressbook/providers/address_provider.dart';
import 'package:addressbook/screens/map_screen.dart';
import 'package:addressbook/utils/location_helper.dart';
import 'package:flutter/material.dart';

import 'location_helper.dart';

class LocationSearchDelegate extends SearchDelegate<List<Address>> {
  final AddressProvider addressProvider;

  LocationSearchDelegate({@required this.addressProvider});

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: LocationHelper.searchPlaces(query),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List<Address> list = snapshot.data;
          return list.length == 0
              ? Center(child: Text("No Matches Found"))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(MapScreen.routeName, arguments: {
                          'address': list[index],
                        });
                      },
                      child: ListTile(
                        title: Text(list[index].address),
                        subtitle: Text(list[index].formattedAddress),
                      ),
                    );
                  },
                );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

}
