// Project: Flutter-base Airdroper
// Purpose: Testing integration of Flutter & Google Maps
// Platforms:  Web, iOS and Android
// Authors: www.base.com

import 'package:flutter/material.dart';
import 'package:baseairdroper/types/trip.dart';
import 'package:baseairdroper/providers/active_trip.dart';
import 'package:baseairdroper/ui/common.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:baseairdroper/providers/theme.dart';
import 'package:lottie/lottie.dart';

Widget tripFinishedScaffold(BuildContext context) {
  final trip = TripProvider.of(context);

  return buildAppScaffold(
      context,
      SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text(getTripStatusDescription(trip.activeTrip!.status),
                style: Theme.of(context).textTheme.headline5),
          ),
          Lottie.asset('assets/lottie/airdroper-driver.json'),
          Text('Rate your trip', style: Theme.of(context).textTheme.subtitle1),
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
          ),
          // tripFromTo(context, trip.activeTrip!),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: ElevatedButton(
                style: ThemeProvider.of(context).roundButtonStyle,
                onPressed: () => trip.deactivateTrip(),
                child: const Text('Close')),
          )
        ],
      )));
}
