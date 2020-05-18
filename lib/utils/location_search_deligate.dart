import 'package:addressbook/models/address_model.dart';
import 'package:addressbook/models/response_autocomplete.dart';
import 'package:addressbook/screens/map_screen.dart';
import 'package:addressbook/utils/location_helper.dart';
import 'package:flutter/material.dart';

import 'location_helper.dart';

class LocationSearchDelegate extends SearchDelegate<List<Address>> {
  final bool gotoNext;

  LocationSearchDelegate({this.gotoNext});

  @override
  Widget buildSuggestions(BuildContext context) {
    return provideSuggestions();
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
    return searchResultByName();
  }

  FutureBuilder<List<Predictions>> provideSuggestions() {
    return FutureBuilder(
      future: LocationHelper.placeAutoComplete(query),
      builder: (context, snapshot) {
        if (snapshot != null) {
          List<Predictions> list = snapshot.data;
          if (list != null) {
            return list.length == 0
                ? Center(child: Text("Type to view locations"))
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => fetchDetailsAndNavigateToMap(
                            context: context, placeId: list[index].placeId),
                        child: ListTile(
                          title: Text(list[index].description),
                        ),
                      );
                    },
                  );
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  FutureBuilder<List<Address>> searchResultByName() {
    return FutureBuilder(
      future: LocationHelper.searchPlacesByName(query),
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
                        navigate(context, list[index]);
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

  Future<void> fetchDetailsAndNavigateToMap(
      {BuildContext context, String placeId}) async {
    LocationHelper.getPlaceDetails(placeID: placeId).then((value) {
      print(value.formattedAddress);
      navigate(context, value);
    });
  }

  void navigate(BuildContext context, Address address) {
    if (gotoNext) {
      Navigator.of(context).pushNamed(MapScreen.routeName, arguments: {
        'address': address,
      });
    } else {
      Navigator.of(context).pop({'address': address});
    }
  }
}
