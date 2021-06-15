import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Destination {
  final String name;
  final IconData icon;

  const Destination(this.name, this.icon);

  BottomNavigationBarItem call() {
    return BottomNavigationBarItem(icon: Icon(icon), label: name);
  }
}

class ScreenController extends GetxController {}

abstract class Screen<T extends GetxController>
    extends GetResponsiveView<ScreenController> {
  final String _title;
  final String _path;

  late final T pageController;
  final bool getX;
  final bool bottomBar;
  final bool fab;
  final String? taggedController;

  Screen(this._title, this._path,
      [this.getX = false,
      this.bottomBar = true,
      this.fab = false,
      this.taggedController])
      : super(alwaysUseBuilder: false) {
    Get.lazyPut(() => ImagePicker());
    Get.put(ScreenController());
  }

  static const Map<String, Destination> destinations = {
    "home": const Destination("Home", Icons.house),
    "users": const Destination("People", Icons.groups),
    "messages": const Destination("Messages", Icons.message),
  };

  AppBar topBar(String title) {
    return AppBar(
      title: Text(title),
    );
  }

  Widget getFAB() {
    throw UnimplementedError();
  }

  BottomNavigationBar _bottomBar(String active) {
    final List<String> dests = [...destinations.keys];

    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Get.theme.bottomAppBarColor,
        items: <BottomNavigationBarItem>[
          ...destinations.values.map((e) => e()),
          BottomNavigationBarItem(icon: const Icon(Icons.menu), label: "Menu")
        ],
        onTap: (int index) {
          if (index >= dests.length && !Get.isBottomSheetOpen!) {
            Get.bottomSheet(
                _ToolBox(screen.height *
                        screen.responsiveValue(
                            mobile: 2 / 3,
                            tablet: 4 / 5,
                            desktop: 7 / 10,
                            watch: 1)! -
                    100),
                elevation: 100,
                clipBehavior: Clip.none,
                backgroundColor: Get.theme.dialogBackgroundColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))));
          } else if (dests.indexOf(active) != index) {
            Get.offAllNamed('/${dests[index]}');
          }
        },
        showUnselectedLabels: true,
        currentIndex: dests.indexOf(active),
        unselectedItemColor:
            Get.theme.bottomNavigationBarTheme.unselectedItemColor,
        selectedItemColor:
            Get.theme.bottomNavigationBarTheme.selectedItemColor);
  }

  /* OVERRIDE THIS */
  Widget body(T controller) {
    throw UnimplementedError();
  }

  /* DO NOT OVERRIDE */
  @override
  Widget builder() {
    return Scaffold(
        appBar: topBar(_title),
        body: getX
            ? GetX<T>(
                init: pageController, builder: this.body, tag: taggedController)
            : this.body(pageController),
        bottomNavigationBar: bottomBar ? _bottomBar(_path) : null,
        floatingActionButton: fab ? getFAB() : null);
  }
}

class _ToolBox extends StatelessWidget {
  static const Map<String, Destination> otherDests = {
    "settings": const Destination("Settings", Icons.settings),
    "bookmarks": const Destination(
        "Bookmarked People", Icons.collections_bookmark_sharp),
    "profile": const Destination("My Profile", Icons.account_circle_sharp),
    'reports': const Destination('Tickets', Icons.contact_support),
    'my_page': const Destination('My Page', Icons.assignment)
  };

  final double height;

  _ToolBox(this.height);

  Widget item(IconData data, String text, String path) {
    return Row(children: [
      Expanded(
          child: TextButton.icon(
              onPressed: () => Get.offAllNamed('/$path'),
              icon: Icon(data, color: Get.theme.textTheme.bodyText1!.color),
              label: Text(text,
                  style:
                      TextStyle(color: Get.theme.textTheme.bodyText1!.color)),
              style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 17, horizontal: 30))))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final String? photoURL = Get.find<FirebaseAuth>().currentUser?.photoURL;

    return Container(
        height: height,
        padding: EdgeInsets.only(top: 20),
        child: ListView(children: [
          CircleAvatar(
              radius: 40,
              backgroundImage: ((photoURL != null)
                  ? NetworkImage(photoURL)
                  : AssetImage('')) as ImageProvider<Object>),
          Center(
              child: Text(
                  Get.find<FirebaseAuth>().currentUser?.providerData[0].email ??
                      'Error: Unable to get user email',
                  style: TextStyle(fontSize: 18))),
          ...Screen.destinations.entries
              .map((d) => item(d.value.icon, d.value.name, d.key)),
          ...otherDests.entries
              .map((d) => item(d.value.icon, d.value.name, d.key)),
          Row(
            children: [
              Expanded(
                  child: TextButton.icon(
                      onPressed: () => Get.find<FirebaseAuth>().signOut(),
                      icon: Icon(Icons.logout, color: Colors.redAccent),
                      label: Text('Sign Out',
                          style: TextStyle(color: Colors.redAccent)),
                      style: TextButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30))))
            ],
          )
        ]));
  }
}
