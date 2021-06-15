import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/util/screen.dart';

class ProfileController extends GetxController {
  final firestore = Get.find<FirebaseFirestore>();
  Rx<DocumentSnapshot?> user = Rx<DocumentSnapshot?>(null);

  final currentUser = Get.find<FirebaseAuth>().currentUser!;

  final String id = Get.find<FirebaseAuth>().currentUser!.uid;

  late final DocumentReference userRef;

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  var fabExpanded = false.obs;
  var editingProfile = false.obs;

  var editIconOverProfileImage = false.obs;

  ProfileController() {
    userRef = firestore.collection('profiles').doc(id);
    sub = userRef.snapshots().listen((snap) => user.value = snap);
  }

  late final sub;

  @override
  void onClose() {
    sub.cancel();
    super.onClose();
  }

  void triggerProfileImageEditIcon() {
    if (editIconOverProfileImage.value) return;

    editIconOverProfileImage.value = true;
    Future.delayed(
        Duration(seconds: 1), () => editIconOverProfileImage.value = false);
  }

  void editProfile() async {
    final state = formKey.currentState!;

    if (state.saveAndValidate()) {
      if (state.value['email'] != currentUser.providerData[0].email) {
        if (currentUser.providerData[0].providerId != 'password') {
          Get.bottomSheet(
              Container(
                  height: 100,
                  color: Colors.red.shade400,
                  child: Center(
                    child: Text(
                        'Error: Your email is set by a third party account '
                        'and cannot by changed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  )),
              isDismissible: false);
          Future.delayed(Duration(seconds: 2), () => Get.back());
          return;
        } else
          await currentUser.updateEmail(state.value['email']);
      }

      await userRef.update({
        'age': int.parse(state.value['age']),
        'desc': state.value['desc'],
        'email': state.value['email'],
        'gender': state.value['gender'],
        'name': state.value['name'],
        'telephone': state.value['telephone']
      });

      fabExpanded.value = false;
      editingProfile.value = false;
    }
  }

  void editProfileImage() async {
    ImagePicker picker = Get.find<ImagePicker>();

    final imageRef = FirebaseStorage.instance.ref('/avatars/$id');

    final data = File((await picker.getImage(
            source: ImageSource.gallery,
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 20))!
        .path);
    try {
      await imageRef.putFile(data);
    } catch (err) {
      Get.bottomSheet(
          Container(
              height: 100,
              color: Colors.red.shade400,
              child: Center(
                child: Text(
                    'Error: Image too big to upload. Please use a '
                    'smaller file.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    )),
              )),
          isDismissible: false);
      Future.delayed(Duration(seconds: 2), () => Get.back());
      return;
    }

    final photoURL = await imageRef.getDownloadURL();

    await Get.find<FirebaseAuth>().currentUser!.updatePhotoURL(photoURL);
    await userRef.update({'photo': photoURL});
  }
}

class ProfileScreen extends Screen<ProfileController> {
  ProfileScreen() : super('Profile', 'home', true, true, true) {
    pageController = ProfileController();
  }

  @override
  Widget getFAB() {
    return GetX<ProfileController>(
        init: pageController,
        builder: (controller) {
          if (controller.fabExpanded.value)
            return FloatingActionButton.extended(
                heroTag: 'profileEditor',
                onPressed: () {},
                label: Row(children: [
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => controller.fabExpanded.value = false),
                  IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: () {
                        controller.editingProfile.value = false;
                        controller.fabExpanded.value = false;
                      }),
                  IconButton(
                      icon: Icon(Icons.done), onPressed: controller.editProfile)
                ]));
          if (controller.editingProfile.value)
            return FloatingActionButton(
                heroTag: 'profileEditor',
                onPressed: () => controller.fabExpanded.value = true,
                child: Icon(Icons.more_vert));
          return FloatingActionButton(
              heroTag: 'profileEditor',
              onPressed: () => controller.editingProfile.value = true,
              child: Icon(Icons.edit));
        });
  }

  @override
  Widget body(ProfileController controller) {
    final user = controller.user.value;

    if (user == null) {
      return Container();
    } else {
      final String photoURL = user.get('photo');

      if (controller.editingProfile.value) {
        return Container(
            child: FormBuilder(
          key: controller.formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            children: [
              GestureDetector(
                onTap: controller.triggerProfileImageEditIcon,
                onLongPress: controller.editProfileImage,
                child: controller.editIconOverProfileImage.value
                    ? Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white70),
                        child: Center(child: Icon(Icons.edit)))
                    : CircleAvatar(
                        radius: 60,
                        backgroundImage: (photoURL != ''
                                ? NetworkImage(photoURL)
                                : AssetImage('assets/degrees.png'))
                            as ImageProvider<Object>),
              ),
              const SizedBox(height: 20),
              FormBuilderTextField(
                  initialValue: user.get('name'),
                  name: 'name',
                  decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ))),
                  validator: FormBuilderValidators.required(Get.context!)),
              const SizedBox(height: 20),
              FormBuilderTextField(
                  initialValue: user.get('email'),
                  name: 'email',
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ))),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.email(Get.context!),
                    FormBuilderValidators.required(Get.context!)
                  ])),
              const SizedBox(height: 20),
              FormBuilderTextField(
                  initialValue: user.get('gender'),
                  name: 'gender',
                  decoration: InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          )))),
              const SizedBox(height: 20),
              FormBuilderTextField(
                  initialValue: user.get('age').toString(),
                  name: 'age',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ))),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.integer(Get.context!),
                    FormBuilderValidators.required(Get.context!)
                  ])),
              const SizedBox(height: 20),
              FormBuilderTextField(
                  initialValue: user.get('telephone'),
                  name: 'telephone',
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: "Phone #",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ))),
                  validator: FormBuilderValidators.required(Get.context!)),
              const SizedBox(height: 20),
              FormBuilderTextField(
                  initialValue: user.get('desc'),
                  name: 'desc',
                  maxLines: 2,
                  enableInteractiveSelection: true,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                      labelText: "About",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          )))),
            ],
          ),
        ));
      }

      return Container(
          child: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        children: [
          CircleAvatar(
              radius: 60,
              backgroundImage: (photoURL != ''
                  ? NetworkImage(photoURL)
                  : AssetImage('assets/degrees.png')) as ImageProvider<Object>),
          Text(user.get('name'), style: TextStyle(fontSize: 24)),
          Text(user.get('email'), style: TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          Text('Gender', style: TextStyle(fontSize: 18)),
          Text(user.get('gender')),
          const SizedBox(height: 20),
          Text('Age', style: TextStyle(fontSize: 18)),
          Text(user.get('age').toString()),
          const SizedBox(height: 20),
          Text('Phone #', style: TextStyle(fontSize: 18)),
          Text(user.get('telephone')),
          const SizedBox(height: 20),
          Text('About', style: TextStyle(fontSize: 18)),
          Text(user.get('desc')),
        ],
      ));
    }
  }
}
