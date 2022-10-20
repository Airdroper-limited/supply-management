// Project: Flutter-base Airdroper
// Purpose: Testing integration of Flutter & Google Maps
// Platforms:  Web, iOS and Android
// Authors: www.base.com

import 'package:flutter/material.dart';
import 'package:baseairdroper/types/trip.dart';
import 'package:baseairdroper/ui/active_trip_scaffold.dart';
import 'package:baseairdroper/providers/assets_loader.dart';
import 'package:baseairdroper/providers/location.dart';
import 'package:baseairdroper/ui/new_trip_scaffold.dart';
import 'package:baseairdroper/ui/common.dart';
import 'package:baseairdroper/providers/active_trip.dart';
import 'package:baseairdroper/ui/select_location_scaffold.dart';
import 'package:baseairdroper/providers/theme.dart';
import 'package:baseairdroper/ui/trip_finished_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:touch_indicator/touch_indicator.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AssetLoaderProvider>(
            create: (_) => AssetLoaderProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider<TripProvider>(
          create: (_) => TripProvider(),
        )
      ],
      child: Consumer<ThemeProvider>(
          builder: (context, ThemeProvider themeProvider, child) => MaterialApp(
              theme: themeProvider.currentThemeData,
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: rootScaffoldMessengerKey,
              builder: (context, child) => TouchIndicator(child: child!),
              home: Builder(
                builder: (ctx) {
                  // Get Current Location Provider
                  final locProvider = LocationProvider.of(context);

                  // Get Current Trip Provider
                  final currentTrip = TripProvider.of(context);

                  // if Current location is not known
                  if (!locProvider.isDemoLocationFixed)
                    // show Location Selection screen
                    return LocationScaffold();

                  // else if there is an Active Trip
                  if (currentTrip.isActive) {
                    // and if this trip is finished
                    return tripIsFinished(currentTrip.activeTrip!.status)
                        // show Rate the Trip screen
                        ? tripFinishedScaffold(context)
                        // if not finished - show the trip in progress screen
                        : ActiveTrip();
                  }

                  // else if there is no active trip - display UI for new trip creation
                  return NewTrip();
                },
              ))),
    ));
