

import 'package:flutter/material.dart';
import 'package:baseairdroper/api/google_api.dart';
import 'package:baseairdroper/types/resolved_address.dart';
import 'package:baseairdroper/ui/address_search.dart';
import 'package:baseairdroper/providers/location.dart';
import 'package:baseairdroper/ui/common.dart';

import 'package:google_maps_webservice/places.dart';
import 'package:lottie/lottie.dart';

class LocationScaffold extends StatelessWidget {
  LocationScaffold({Key? key}) : super(key: key);

  final demoAddressKyiv = ResolvedAddress(
      location: Location(lat: 50.271558, lng: 30.3125518),
      mainText: "Maidan, Kyiv",
      secondaryText: "KV 02000, UKRAINE");

  final demoAddressLondon = ResolvedAddress(
      location: Location(lat: 51.5007292, lng: -0.1268194),
      mainText: "Big Ben, London",
      secondaryText: "SW1A 0AA, United Kingdom");

  final demoAddressParis = ResolvedAddress(
      location: Location(lat: 48.8752611, lng: 2.2878047),
      mainText: "Arc de Triomphe, Paris",
      secondaryText: "75008 France");

  void _setDemoLocation(BuildContext context, ResolvedAddress address) {
    final locProvider = LocationProvider.of(context, listen: false);
    locProvider.currentAddress = address;
    showScaffoldSnackBarMessage(
        '${address.mainText} was set as a current location.');
  }

  void _selectCurrentLocation(BuildContext context) async {
    final Prediction? prd = await showSearch<Prediction?>(
        context: context, delegate: AddressSearch(), query: '');

    if (prd != null) {
      PlacesDetailsResponse placeDetails = await apiGooglePlaces
          .getDetailsByPlaceId(prd.placeId!, fields: [
        "address_component",
        "geometry",
        "type",
        "adr_address",
        "formatted_address"
      ]);

      final address = ResolvedAddress(
          location: placeDetails.result.geometry!.location,
          mainText: prd.structuredFormatting?.mainText ??
              placeDetails.result.addressComponents.join(','),
          secondaryText: prd.structuredFormatting?.secondaryText ?? '');

      final locProvider = LocationProvider.of(context, listen: false);
      locProvider.currentAddress = address;
      showScaffoldSnackBarMessage(
          '${address.mainText} was set as a current location.');

      showScaffoldSnackBarMessage(
          placeDetails.result.geometry?.location.lat.toString() ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool pendingDetermineLocation =
        LocationProvider.of(context).pendingDetermineCurrentLocation;
    return buildAppScaffold(
        context,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 64, top: 8),
              child: Text(
                "Base demo",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Expanded(child: Lottie.asset('assets/lottie/airdroper-animation.json')),
            if (pendingDetermineLocation) ...[
              LinearProgressIndicator(),
              Text('Please wait while your prosition is determined....'),
            ],
            if (!pendingDetermineLocation) ...[
              Text(
                'Choose your location',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Kyiv, UKRAINE'),
                subtitle: Text("Maidan"),
                onTap: () => _setDemoLocation(context, demoAddressKyiv),
                trailing: Icon(Icons.chevron_right),
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('London, UK'),
                subtitle: Text("Big Ben"),
                onTap: () => _setDemoLocation(context, demoAddressLondon),
                trailing: Icon(Icons.chevron_right),
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Paris, France'),
                subtitle: Text("Arc de Triomphe"),
                onTap: () => _setDemoLocation(context, demoAddressParis),
                trailing: Icon(Icons.chevron_right),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.search),
                title: Text('Search location by name'),
                onTap: () => _selectCurrentLocation(context),
              ),
              ListTile(
                leading: Icon(Icons.gps_fixed),
                title: Text('Dertemine my location by GPS'),
                onTap: () => LocationProvider.of(context, listen: false)
                    .determineCurrentLocation(),
              )
            ],
          ]),
        ),
        isLoggedIn: false);
  }
}
