import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sql_crud_app/screens/add_user/add_or_edit_user_controller.dart';
import 'package:sql_crud_app/screens/add_user/add_or_edit_user_screen.dart';
import 'package:sql_crud_app/screens/home/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AddOrEditUserController addOrEditUserController = Get.find();
  @override
  void initState() {
    super.initState();
    HomeController homeController = Get.find();
    homeController.getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addOrEditUserController.clearTempData();
          Get.to(AddOrEditUserScreen(isEdit: false));
        },
        child: Icon(Icons.add),
      ),
      body: GetBuilder<HomeController>(
        builder: (hValue) {
          return hValue.fetching
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: hValue.userList.length,
                itemBuilder:
                    (context, index) => ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.file(
                          File(hValue.userList[index].image),
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  Icon(Icons.person),
                        ),
                      ),
                      title: Text(hValue.userList[index].name),
                      subtitle: Text(hValue.userList[index].email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              addOrEditUserController.setUserFormForEdit(
                                hValue.userList[index],
                              );
                              Get.to(AddOrEditUserScreen(isEdit: true));
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text('Delete'),
                                      content: RichText(
                                        text: TextSpan(
                                          text:
                                              'Are you sure, Want to delete user ',
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '"${hValue.userList[index].name}"',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            TextSpan(text: ' ?'),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            hValue.deleteUser(
                                              hValue.userList[index].id,
                                            );
                                          },
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
              );
        },
      ),
    );
  }
}
