import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/util/screen.dart';

class SettingsController extends GetxController {
  var theme = Get.isDarkMode.obs;

  void updateTheme(bool val) {
    theme.value = val;
    Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
    print(Get.isDarkMode);
  }
}

class SettingsScreen extends Screen<SettingsController> {
  SettingsScreen() : super('Settings', 'home', true) {
    pageController = SettingsController();
  }

  @override
  Widget body(SettingsController controller) {
    return Container(
        child: ListView(children: [
      SwitchListTile(
          value: controller.theme.value,
          onChanged: controller.updateTheme,
          title: Text('Dark Mode')),
      ListTile(
        title: Text('About App'),
        trailing: Icon(Icons.arrow_forward),
        onLongPress: () => showAboutDialog(
            context: Get.context!,
            applicationName: 'Six Degrees',
            applicationIcon: Image.asset('assets/degrees.png',
                width: 100, height: 100, fit: BoxFit.fill),
            applicationLegalese: '\u{a9}2021 Six Degrees',
            applicationVersion: 'v1.0.1'),
      )
    ]));
  }
}
