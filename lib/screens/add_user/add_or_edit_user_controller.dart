// ignore_for_file: use_build_context_synchronously

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sql_crud_app/db_handler.dart';
import 'package:sql_crud_app/model/user_model.dart';
import 'package:sql_crud_app/screens/home/home_controller.dart';
import 'package:sql_crud_app/utils/show_snakbar.dart';

class AddOrEditUserController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int id = 0;
  final nameController = TextEditingController(),
      emailController = TextEditingController();

  ///For add user...
  bool inserting = false;
  startInsert() {
    inserting = true;
    update();
  }

  stopInsert() {
    inserting = false;
    update();
  }

  Future<bool> addUser(BuildContext context) async {
    startInsert();
    bool inserted = false;
    await dbHandler
        .insertDB(
          name: nameController.text,
          email: emailController.text,
          image: pImage!.path,
        )
        .then((value) {
          inserted = value != 0;

          stopInsert();
          if (inserted) {
            HomeController homeController = Get.find();
            homeController.getUserList();
            clearTempData();
            showSuccessSnakbar(context, msg: 'User added');
            Get.back();
          } else {
            showFailSnakbar(context, msg: 'User not added');
          }
        });
    return inserted;
  } //---------------------------------------------------//

  ///For set business profiles data to update business profile screen
  setUserFormForEdit(UserModel user) {
    nameController.text = user.name;
    emailController.text = user.email;
    pImage = XFile(user.image);
    id = user.id;
    update();
    print("FILE IMAGE ======> ${pImage?.path}");
  } //---------------------------------------------------//

  ///For update user...
  bool updating = false;
  startUpdating() {
    updating = true;
    update();
  }

  stopUpdating() {
    updating = false;
    update();
  }

  Future<bool> updateUser(BuildContext context) async {
    startUpdating();
    bool inserted = false;
    await dbHandler
        .updateDB(
          id,
          name: nameController.text,
          email: emailController.text,
          image: pImage!.path,
        )
        .then((value) {
          inserted = value != 0;

          stopUpdating();
          if (inserted) {
            HomeController homeController = Get.find();
            homeController.getUserList();
            clearTempData();
            showSuccessSnakbar(context, msg: 'User updated');
            Get.back();
          } else {
            showFailSnakbar(context, msg: 'User not updated');
          }
        });
    return inserted;
  } //---------------------------------------------------//

  ///For validate email
  bool emailValidate(String text) {
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(text);
    return emailValid;
  } //---------------------------------------------------//

  ///For Select Image From Device
  final ImagePicker picker = ImagePicker();
  XFile? pImage;
  selectImage() async {
    await picker.pickImage(source: ImageSource.gallery).then((pickedImage) {
      if (pickedImage != null) {
        pImage = pickedImage;

        update();
      }
    });
  }

  ///For Remove Selected Image
  removeImage() {
    pImage = null;
    update();
  }
  //---------------------------------------------------//

  ///For clear user form data
  clearTempData() {
    nameController.clear();
    emailController.clear();
    pImage = null;
    id = 0;
    update();
  } //---------------------------------------------------//
}
