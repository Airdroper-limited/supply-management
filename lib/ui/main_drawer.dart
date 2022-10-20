// Project: Flutter-base Airdroper
// Purpose: Testing integration of Flutter & Google Maps
// Platforms:  Web, iOS and Android
// Authors: www.base.com

import 'package:flutter/material.dart';
import 'package:baseairdroper/providers/active_trip.dart';
import 'package:baseairdroper/providers/location.dart';
import 'package:baseairdroper/providers/theme.dart';
import 'package:baseairdroper/ui/common.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

Widget mainDrawer(BuildContext context, {bool isLoggedIn = true}) => Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: Expanded(
                        child:
                            Lottie.asset('assets/lottie/airdroper-animation.json')),
                  ),
                  Text(
                    "Base Airdroper",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.black),
                  ),
                ],
              )),
          ListTile(
            leading: const Icon(Icons.local_airdroper),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Toggle theme'),
            onTap: () {
              final tp = Provider.of<ThemeProvider>(context, listen: false);
              tp.isDark = !tp.isDark;
              Navigator.pop(context);
            },
          ),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                  TripProvider.of(context, listen: false).deactivateTrip();
                  LocationProvider.of(context, listen: false).reset();
                });
                Navigator.pop(context);
              },
            ),
          const Divider(
            height: 10,
            thickness: 1,
          ),
          ListTile(
            title: const Text('Connect with Developer'),
            subtitle: Text(
              'www.linkedin.com/in/mapi/',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              launchUrl('https://www.linkedin.com/in/mapi/');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Get Full Source Code'),
            subtitle: Text(
              'github.com/YakivGalkin/base-airdroper',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              launchUrl('https://github.com/YakivGalkin/base-airdroper');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
