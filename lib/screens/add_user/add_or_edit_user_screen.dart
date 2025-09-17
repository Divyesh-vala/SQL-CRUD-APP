// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sql_crud_app/screens/add_user/add_or_edit_user_controller.dart';
import 'package:sql_crud_app/utils/show_snakbar.dart';

class AddOrEditUserScreen extends StatelessWidget {
  final bool isEdit;
  AddOrEditUserScreen({super.key, required this.isEdit});
  final AddOrEditUserController addOrEditUserController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: addOrEditUserController.formKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${isEdit ? 'Update' : 'Add'} User'),
        ),
        body: GetBuilder<AddOrEditUserController>(
          builder: (addrEtidUserValue) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap:
                              addrEtidUserValue.pImage != null
                                  ? null
                                  : () {
                                    addrEtidUserValue.selectImage();
                                  },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                ),
                                height: MediaQuery.of(context).size.width * 0.4,

                                width: MediaQuery.of(context).size.width * 0.4,

                                child:
                                    addrEtidUserValue.pImage != null
                                        ? Image.file(
                                          File(
                                            addrEtidUserValue.pImage?.path ??
                                                '',
                                          ),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Center(
                                                    child: Icon(Icons.person),
                                                  ),
                                        )
                                        : Center(child: Icon(Icons.image)),
                              ),
                            ),
                          ),
                        ),
                        if (addrEtidUserValue.pImage != null)
                          Positioned(
                            bottom: -10,
                            left: -10,
                            child: IconButton.filled(
                              onPressed: () {
                                addrEtidUserValue.selectImage();
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ),
                        if (addrEtidUserValue.pImage != null)
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: IconButton.filled(
                              onPressed: () {
                                addrEtidUserValue.removeImage();
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),

                        if (addrEtidUserValue.pImage == null)
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: IconButton.filled(
                              onPressed: () {
                                addrEtidUserValue.selectImage();
                              },
                              icon: Icon(Icons.camera_alt),
                            ),
                          ),
                      ],
                    ),
                    itemWidget(
                      title: 'Name',
                      controller: addrEtidUserValue.nameController,
                      enable:
                          !addrEtidUserValue.inserting &&
                          !addrEtidUserValue.updating,
                      validator: (text) {
                        if (text == null) {
                          return 'Please enter name';
                        } else if (text.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    itemWidget(
                      title: 'Email',
                      controller: addrEtidUserValue.emailController,
                      enable:
                          !addrEtidUserValue.inserting &&
                          !addrEtidUserValue.updating,
                      validator: (text) {
                        if (text == null) {
                          return 'Please enter email';
                        } else if (text.isEmpty) {
                          return 'Please enter email';
                        } else if (!addrEtidUserValue.emailValidate(text)) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 16,
                      ),
                      child:
                          addrEtidUserValue.inserting ||
                                  addrEtidUserValue.updating
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  maximumSize: Size(double.infinity, 60),
                                  minimumSize: Size(double.infinity, 60),
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () async {
                                  if (addrEtidUserValue.formKey.currentState
                                          ?.validate() ==
                                      true) {
                                    if (addrEtidUserValue.pImage != null) {
                                      if (isEdit) {
                                        await addrEtidUserValue.updateUser(
                                          context,
                                        );
                                      } else {
                                        await addrEtidUserValue.addUser(
                                          context,
                                        );
                                      }
                                    } else {
                                      showFailSnakbar(
                                        context,
                                        msg: 'Please select user image',
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  isEdit ? 'Update' : 'Add',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget itemWidget({
    required String title,
    required TextEditingController? controller,
    required bool enable,
    required String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            enabled: enable,
            validator: validator,
            keyboardType: keyboardType,
            textInputAction: textInputAction ?? TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(),
              errorBorder: OutlineInputBorder(),
              disabledBorder: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
