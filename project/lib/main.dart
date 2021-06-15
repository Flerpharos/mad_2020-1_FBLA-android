// Package Imports
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/screen/signin_picker.dart';
import 'package:supercharged/supercharged.dart';

// Screen Imports
import 'screen/app.dart';
import 'screen/bookmarks_list.dart';
import 'screen/bug_page.dart';
import 'screen/channels_list.dart';
import 'screen/edit_page.dart';
import 'screen/home.dart';
import 'screen/profile.dart';
import 'screen/settings.dart';
import 'screen/users_list.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    defaultTransition: Transition.noTransition,
    routes: {
      // Routes here
      '/': (ctx) => App(),
      '/home': (ctx) => HomeScreen(),
      '/picker': (ctx) => SignInPickerScreen(),
      '/users': (ctx) => UserListScreen(),
      '/messages': (ctx) => ChannelsListScreen(),
      '/settings': (ctx) => SettingsScreen(),
      '/bookmarks': (ctx) => BookmarksScreen(),
      '/profile': (ctx) => ProfileScreen(),
      '/reports': (ctx) => ReportsScreen(),
      '/my_page': (ctx) => MyPageScreen()
      /* Add More routes here */
    },
    theme: ThemeData(
      // Light Theme
      primaryColor: '#4c73c7'.toColor(),
      colorScheme: ColorScheme.light(
          primary: '#4c73c7'.toColor(),
          primaryVariant: '#0444cc'.toColor(),
          secondaryVariant: Colors.amber.shade600,
          secondary: Colors.amber),
    ),
    darkTheme: ThemeData(
      // Dark Theme
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
          primary: '#b5d2ff'.toColor(),
          primaryVariant: '#81a1fa'.toColor(),
          secondaryVariant: Colors.amber.shade100,
          secondary: Colors.amber.shade200),
    ),
  ));
}
